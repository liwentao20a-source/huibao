clear; clc; close all;

% 太赫兹前下视 SAR 二维 BP 成像示例。
% 流程：
%   1. 生成单点目标原始基带回波；
%   2. 距离压缩；
%   3. 在 x-h 平面进行二维 BP 成像；
%   4. 检查图像峰值是否落在真实目标坐标附近。

params.fc = 220e9;              % 载频，Hz
params.B = 5e9;                 % 调频带宽，Hz
params.Tp = 0.2e-6;             % 脉冲宽度，s
params.fs = 12e9;               % 快时间采样率，Hz
params.PRF = 5e3;               % 脉冲重复频率，Hz
params.Na = 384;                % 慢时间采样点数
params.V = 300;                 % 平台速度，m/s
params.alpha = deg2rad(10);     % 俯冲角，rad
params.H = 100;                 % 初始平台高度，m
params.fast_margin = 0.05e-6;   % 回波窗口两侧额外保留的快时间裕量，s

% 单点目标参数。
x0 = -15;
y0 = 10;
h0 = 0;
target = [x0, y0, h0, 1.0];

% 将慢时间窗口中心设在该点目标的理论零多普勒时刻附近。
params.t0 = (x0*cos(params.alpha) + (params.H - h0)*sin(params.alpha)) / params.V;

[echo, axes_out, geom] = generate_echo_v3(params, target);
[echo_rc, rc_info] = range_compress_v3(echo, axes_out);

% 二维成像网格。先取小场景，便于快速验证。
x_grid = linspace(x0 - 3, x0 + 3, 161);
h_grid = linspace(h0 - 3, h0 + 3, 161);

[img, bp_info] = bp_image_v3(echo_rc, axes_out, x_grid, h_grid, y0);

img_abs = abs(img);
img_db = 20*log10(img_abs / max(img_abs(:)) + eps);

[peak_value, peak_linear_idx] = max(img_abs(:));
[idx_h_peak, idx_x_peak] = ind2sub(size(img_abs), peak_linear_idx);
x_peak = x_grid(idx_x_peak);
h_peak = h_grid(idx_h_peak);

fprintf('--- 二维 BP 成像验证 ---\n');
fprintf('真实目标坐标：[x, h] = [%.6f, %.6f] m，成像假设 y = %.6f m\n', x0, h0, y0);
fprintf('图像峰值坐标：[x, h] = [%.6f, %.6f] m\n', x_peak, h_peak);
fprintf('x 误差：%.6e m\n', x_peak - x0);
fprintf('h 误差：%.6e m\n', h_peak - h0);
fprintf('峰值幅度：%.6e\n', peak_value);

figure('Name', '二维 BP 聚焦成像结果');
imagesc(x_grid, h_grid, img_db);
axis xy image;
colormap jet;
colorbar;
caxis([-40, 0]);
xlabel('x 坐标 (m)');
ylabel('h 坐标 (m)');
title('二维 BP 聚焦成像结果 (dB)');
hold on;
% plot(x0, h0, 'wp', 'MarkerSize', 12, 'MarkerFaceColor', 'w');
% plot(x_peak, h_peak, 'kx', 'MarkerSize', 12, 'LineWidth', 2);
% legend('真实目标', '图像峰值', 'TextColor', 'w', 'Location', 'best');

figure('Name', 'x 向剖面');
plot(x_grid, img_db(idx_h_peak, :), 'LineWidth', 1.3); grid on;
xlabel('x 坐标 (m)');
ylabel('归一化幅度 (dB)');
title(sprintf('峰值高度 h = %.3f m 处的 x 向剖面', h_peak));
xline(x0, '--r', '真实 x');

figure('Name', 'h 向剖面');
plot(h_grid, img_db(:, idx_x_peak), 'LineWidth', 1.3); grid on;
xlabel('h 坐标 (m)');
ylabel('归一化幅度 (dB)');
title(sprintf('峰值方位 x = %.3f m 处的 h 向剖面', x_peak));
xline(h0, '--r', '真实 h');

save('bp_image_v3_demo.mat', ...
    'params', 'target', 'echo', 'echo_rc', 'axes_out', 'geom', 'rc_info', ...
    'x_grid', 'h_grid', 'img', 'img_abs', 'img_db', 'bp_info', ...
    'x_peak', 'h_peak');
fprintf('二维 BP 成像示例数据已保存到 bp_image_v3_demo.mat\n');
