clear; clc; close all;

% 太赫兹前下视 SAR 距离徙动曲线验证。
% 本脚本验证三件事：
%   1. 距离压缩峰值轨迹是否与理论瞬时斜距 R(t) 一致；
%   2. 峰值轨迹的最小点是否出现在理论零多普勒时刻 tc 附近；
%   3. 相同 (x,h)、不同 y 的目标是否具有相同 tc，但 Rmin 不同。

params.fc = 220e9;              % 载频，Hz
params.B = 5e9;                 % 调频带宽，Hz
params.Tp = 0.2e-6;             % 脉冲宽度，s
params.fs = 12e9;               % 快时间采样率，Hz
params.PRF = 5e3;               % 脉冲重复频率，Hz
params.Na = 512;                % 慢时间采样点数
params.V = 300;                 % 平台速度，m/s
params.alpha = deg2rad(10);     % 俯冲角，rad
params.H = 100;                 % 初始平台高度，m
params.fast_margin = 0.05e-6;   % 回波窗口两侧额外保留的快时间裕量，s

% 为了能在慢时间窗口内看到 R(t) 的最小点，这里把慢时间中心设到目标 tc 附近。
x0 = -15;
y0 = 10;
h0 = 0;
tc0 = (x0*cos(params.alpha) + (params.H - h0)*sin(params.alpha)) / params.V;
params.t0 = tc0;

% 第一部分：单点目标距离徙动轨迹验证。
target_single = [x0, y0, h0, 1.0];
[echo, axes_out, geom] = generate_echo_v3(params, target_single);
[echo_rc, ~] = range_compress_v3(echo, axes_out);

[peak_range, peak_amp, peak_index] = extract_peak_track(abs(echo_rc), axes_out.range);

theory_range = geom.R(:, 1);
range_error = peak_range - theory_range;

[meas_Rmin, idx_min_meas] = min(peak_range);
[theory_Rmin, idx_min_theory] = min(theory_range);
meas_tc = axes_out.ta(idx_min_meas);
theory_tc = geom.tc(1);

range_sample = axes_out.range(2) - axes_out.range(1);

fprintf('--- 单点目标 RCM 验证 ---\n');
fprintf('目标坐标：[x, y, h] = [%.3f, %.3f, %.3f] m\n', x0, y0, h0);
fprintf('距离采样间隔：%.6f m\n', range_sample);
fprintf('理论 tc：%.9e s\n', theory_tc);
fprintf('实测最小距离时刻：%.9e s\n', meas_tc);
fprintf('tc 误差：%.6e s\n', meas_tc - theory_tc);
fprintf('理论 Rmin：%.6f m\n', geom.Rmin(1));
fprintf('理论轨迹最小值：%.6f m\n', theory_Rmin);
fprintf('实测峰值轨迹最小值：%.6f m\n', meas_Rmin);
fprintf('Rmin 实测误差：%.6e m\n', meas_Rmin - geom.Rmin(1));
fprintf('峰值轨迹均方根误差：%.6e m\n', rms(range_error));
fprintf('峰值轨迹最大绝对误差：%.6e m\n', max(abs(range_error)));

figure('Name', '单点目标距离徙动曲线验证');
plot(axes_out.ta * 1e3, theory_range, 'r-', 'LineWidth', 1.5); hold on;
plot(axes_out.ta * 1e3, peak_range, 'k.', 'MarkerSize', 6);
grid on;
xlabel('慢时间 (ms)');
ylabel('距离 (m)');
title('距离压缩峰值轨迹与理论 R(t) 对比');
legend('理论 R(t)', '距离压缩峰值轨迹', 'Location', 'best');

figure('Name', '单点目标距离徙动误差');
plot(axes_out.ta * 1e3, range_error * 1e3, 'LineWidth', 1.2);
grid on;
xlabel('慢时间 (ms)');
ylabel('误差 (mm)');
title('距离压缩峰值轨迹误差');

figure('Name', '单点目标距离压缩幅度图');
imagesc(axes_out.range, axes_out.ta * 1e3, abs(echo_rc));
axis xy;
xlabel('距离 (m)');
ylabel('慢时间 (ms)');
title('距离压缩后幅度图');
colorbar;
hold on;
plot(theory_range, axes_out.ta * 1e3, 'r-', 'LineWidth', 1.2);

% 第二部分：验证相同 (x,h)、不同 y 的目标具有相同 tc，但 Rmin 不同。
y_list = [0, 5, 10, 20];
targets_y = [ ...
    x0 * ones(numel(y_list), 1), ...
    y_list(:), ...
    h0 * ones(numel(y_list), 1), ...
    ones(numel(y_list), 1)];

[~, axes_y, geom_y] = generate_echo_v3(params, targets_y);

fprintf('\n--- 相同 (x,h)、不同 y 的几何量验证 ---\n');
fprintf('固定 x = %.3f m, h = %.3f m\n', x0, h0);
fprintf('    y (m)        tc (s)              Rmin (m)\n');
for k = 1:numel(y_list)
    fprintf('%9.3f   % .9e   %12.6f\n', ...
        targets_y(k, 2), geom_y.tc(k), geom_y.Rmin(k));
end
fprintf('tc 最大差异：%.6e s\n', max(geom_y.tc) - min(geom_y.tc));

figure('Name', '不同 y 下的理论 R(t)');
plot(axes_y.ta * 1e3, geom_y.R, 'LineWidth', 1.2);
grid on;
xlabel('慢时间 (ms)');
ylabel('理论斜距 R(t) (m)');
title('相同 (x,h)、不同 y 目标的理论距离徙动曲线');
legend(compose('y = %.1f m', y_list), 'Location', 'best');

save('validate_rcm_v3_demo.mat', ...
    'params', 'target_single', 'axes_out', 'geom', 'echo', 'echo_rc', ...
    'peak_range', 'peak_amp', 'peak_index', 'theory_range', 'range_error', ...
    'targets_y', 'axes_y', 'geom_y');
fprintf('\nRCM 验证示例数据已保存到 validate_rcm_v3_demo.mat\n');

function [peak_range, peak_amp, peak_index] = extract_peak_track(echo_abs, range_axis)
Na = size(echo_abs, 1);
peak_range = zeros(Na, 1);
peak_amp = zeros(Na, 1);
peak_index = zeros(Na, 1);
dr = range_axis(2) - range_axis(1);

for i = 1:Na
    [peak_amp_raw, idx] = max(echo_abs(i, :));
    peak_index(i) = idx;

    % 用峰值左右三个采样点做抛物线插值，减小距离采样量化带来的 tc 偏差。
    if idx > 1 && idx < numel(range_axis)
        y1 = echo_abs(i, idx - 1);
        y2 = echo_abs(i, idx);
        y3 = echo_abs(i, idx + 1);
        denom = y1 - 2*y2 + y3;
        if abs(denom) > eps
            delta_bin = 0.5 * (y1 - y3) / denom;
            delta_bin = max(min(delta_bin, 0.5), -0.5);
        else
            delta_bin = 0;
        end
        peak_range(i) = range_axis(idx) + delta_bin * dr;
        peak_amp(i) = y2 - 0.25 * (y1 - y3) * delta_bin;
    else
        peak_range(i) = range_axis(idx);
        peak_amp(i) = peak_amp_raw;
    end
end
end
