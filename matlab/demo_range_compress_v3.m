clear; clc; close all;

% 太赫兹前下视 SAR 距离压缩示例。
% 本脚本流程：
%   1. 基于 v3 几何模型生成单点目标原始基带回波；
%   2. 沿快时间维进行距离压缩；
%   3. 检查距离压缩峰值位置是否与理论瞬时斜距一致。

params.fc = 220e9;              % 载频，Hz
params.B = 5e9;                 % 调频带宽，Hz
params.Tp = 0.2e-6;             % 脉冲宽度，s
params.fs = 12e9;               % 快时间采样率，Hz
params.PRF = 5e3;               % 脉冲重复频率，Hz
params.Na = 256;                % 慢时间采样点数
params.V = 300;                 % 平台速度，m/s
params.alpha = deg2rad(10);     % 俯冲角，rad
params.H = 100;                 % 初始平台高度，m
params.fast_margin = 0.05e-6;   % 回波窗口两侧额外保留的快时间裕量，s

% 单点目标：[x, y, h, sigma]。
targets = [0, 10, 0, 1.0];

[echo, axes_out, geom] = generate_echo_v3(params, targets);
[echo_rc, rc_info] = range_compress_v3(echo, axes_out);

% 取中心慢时间，检查距离压缩峰值位置。
idx_az = floor(params.Na/2) + 1;
[peak_amp, idx_rg] = max(abs(echo_rc(idx_az, :)));

peak_range = axes_out.range(idx_rg);
theory_range = geom.R(idx_az, 1);
range_error = peak_range - theory_range;

fprintf('距离压缩后回波矩阵尺寸：Na x Nr = %d x %d\n', size(echo_rc, 1), size(echo_rc, 2));
fprintf('中心慢时间：%.6e s\n', axes_out.ta(idx_az));
fprintf('理论瞬时斜距：%.6f m\n', theory_range);
fprintf('距离压缩峰值位置：%.6f m\n', peak_range);
fprintf('峰值位置误差：%.6e m\n', range_error);
fprintf('峰值幅度：%.6e\n', peak_amp);

figure('Name', '原始回波幅度');
imagesc(axes_out.range, axes_out.ta * 1e3, abs(echo));
axis xy;
xlabel('表观距离 c\tau/2 (m)');
ylabel('慢时间 (ms)');
title('原始基带回波幅度');
colorbar;

figure('Name', '距离压缩后回波幅度');
imagesc(axes_out.range, axes_out.ta * 1e3, abs(echo_rc));
axis xy;
xlabel('距离 (m)');
ylabel('慢时间 (ms)');
title('距离压缩后回波幅度');
colorbar;

figure('Name', '中心慢时间距离剖面');
plot(axes_out.range, abs(echo_rc(idx_az, :)), 'LineWidth', 1.2);
grid on;
xlabel('距离 (m)');
ylabel('幅度');
title('中心慢时间距离压缩剖面');
xline(theory_range, '--r', '理论斜距');
xline(peak_range, '--k', '峰值位置');

save('range_compress_v3_demo.mat', ...
    'echo', 'echo_rc', 'axes_out', 'geom', 'rc_info', 'params', 'targets');
fprintf('距离压缩示例数据已保存到 range_compress_v3_demo.mat\n');
