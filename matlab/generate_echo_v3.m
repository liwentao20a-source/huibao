function [echo, axes, geom] = generate_echo_v3(params, targets)
%GENERATE_ECHO_V3 基于 v3 俯冲前下视 SAR 几何模型生成原始基带 LFM 回波。
%
%   [echo, axes, geom] = generate_echo_v3(params, targets)
%
% 几何模型：
%   雷达平台位置：
%       x_p(t) = V*cos(alpha)*t
%       y_p(t) = 0
%       h_p(t) = H - V*sin(alpha)*t
%
%   点目标位置：
%       P = (x, y, h)
%
%   瞬时斜距：
%       R(t) = sqrt((x - x_p)^2 + y^2 + (H - V*sin(alpha)*t - h)^2)
%
% 原始基带回波模型：
%       s(tau,t) = sum_i sigma_i * rect((tau - 2R_i(t)/c)/Tp)
%                  * exp(j*pi*Kr*(tau - 2R_i(t)/c)^2)
%                  * exp(-j*4*pi*fc*R_i(t)/c)
%
% 必需的 params 字段：
%   fc          载频，Hz
%   B           调频带宽，Hz
%   Tp          脉冲宽度，s
%   fs          快时间采样率，Hz
%   PRF         脉冲重复频率，Hz
%   Na          慢时间采样点数
%   V           平台速度，m/s
%   alpha       俯冲角，rad
%   H           初始平台高度，m
%
% 可选的 params 字段：
%   c           电磁波传播速度，m/s，默认 299792458
%   t0          慢时间中心，s，默认 0
%   tau         用户自定义快时间轴，s
%   fast_margin 回波窗口两侧额外保留的快时间裕量，s，默认 Tp
%
% targets 可以是包含 x、y、h、sigma 字段的结构体数组，也可以是 N 行 4 列
% 数值矩阵 [x, y, h, sigma]。若结构体中未给出 sigma，则默认散射系数为 1。

arguments
    params struct
    targets
end

params = fill_default_params(params);
targets = normalize_targets(targets);

c = params.c;
Kr = params.B / params.Tp;
lambda = c / params.fc;

ta = ((0:params.Na-1).' - floor(params.Na/2)) / params.PRF + params.t0;

if isfield(params, 'tau') && ~isempty(params.tau)
    tau = params.tau(:).';
else
    tau = make_fast_time_axis(params, targets, ta);
end

Na = numel(ta);
Nr = numel(tau);
Nt = numel(targets.x);

echo = complex(zeros(Na, Nr));

geom.R = zeros(Na, Nt);
geom.tau_delay = zeros(Na, Nt);
geom.D = zeros(1, Nt);
geom.tc = zeros(1, Nt);
geom.Rmin = zeros(1, Nt);

xp = params.V * cos(params.alpha) * ta;
hp = params.H - params.V * sin(params.alpha) * ta;

for k = 1:Nt
    dx = targets.x(k) - xp;
    dh = hp - targets.h(k);
    R = sqrt(dx.^2 + targets.y(k).^2 + dh.^2);
    delay = 2 * R / c;

    dtau = tau - delay;
    win = abs(dtau) <= params.Tp/2;

    echo = echo + targets.sigma(k) ...
        .* win ...
        .* exp(1j*pi*Kr*dtau.^2) ...
        .* exp(-1j*4*pi*params.fc*R/c);

    D = targets.x(k)*sin(params.alpha) - (params.H - targets.h(k))*cos(params.alpha);
    A = targets.x(k)*cos(params.alpha) + (params.H - targets.h(k))*sin(params.alpha);

    geom.R(:, k) = R;
    geom.tau_delay(:, k) = delay;
    geom.D(k) = D;
    geom.tc(k) = A / params.V;
    geom.Rmin(k) = sqrt(D^2 + targets.y(k)^2);
end

axes.ta = ta;
axes.tau = tau;
axes.range = c * tau / 2;
axes.fc = params.fc;
axes.lambda = lambda;
axes.Kr = Kr;
axes.params = params;
axes.targets = targets;

end

function params = fill_default_params(params)
required = {'fc','B','Tp','fs','PRF','Na','V','alpha','H'};
for i = 1:numel(required)
    if ~isfield(params, required{i})
        error('generate_echo_v3:MissingParam', '缺少参数 params.%s', required{i});
    end
end

if ~isfield(params, 'c') || isempty(params.c)
    params.c = 299792458;
end
if ~isfield(params, 't0') || isempty(params.t0)
    params.t0 = 0;
end
if ~isfield(params, 'fast_margin') || isempty(params.fast_margin)
    params.fast_margin = params.Tp;
end
end

function targets = normalize_targets(targets)
if isnumeric(targets)
    if size(targets, 2) < 3
        error('generate_echo_v3:BadTargets', ...
            '数值形式的 targets 至少需要三列：[x, y, h]。');
    end
    if size(targets, 2) < 4
        sigma = ones(size(targets, 1), 1);
    else
        sigma = targets(:, 4);
    end
    targets = struct( ...
        'x', targets(:, 1).', ...
        'y', targets(:, 2).', ...
        'h', targets(:, 3).', ...
        'sigma', sigma(:).');
    return;
end

if ~isstruct(targets)
    error('generate_echo_v3:BadTargets', ...
        'targets 必须是结构体数组或数值矩阵。');
end

if ~isfield(targets, 'sigma')
    for k = 1:numel(targets)
        targets(k).sigma = 1;
    end
end

targets = struct( ...
    'x', [targets.x], ...
    'y', [targets.y], ...
    'h', [targets.h], ...
    'sigma', [targets.sigma]);
end

function tau = make_fast_time_axis(params, targets, ta)
c = params.c;

xp = params.V * cos(params.alpha) * ta;
hp = params.H - params.V * sin(params.alpha) * ta;

min_delay = inf;
max_delay = -inf;

for k = 1:numel(targets.x)
    R = sqrt((targets.x(k) - xp).^2 + targets.y(k).^2 + (hp - targets.h(k)).^2);
    delay = 2 * R / c;
    min_delay = min(min_delay, min(delay));
    max_delay = max(max_delay, max(delay));
end

tau_start = min_delay - params.Tp/2 - params.fast_margin;
tau_stop = max_delay + params.Tp/2 + params.fast_margin;

Nr = ceil((tau_stop - tau_start) * params.fs) + 1;
tau = tau_start + (0:Nr-1) / params.fs;
end
