clear; clc; close all;

% 太赫兹前下视 SAR 简单方位匹配滤波示例。
% 流程：
%   1. 生成单点目标原始回波；
%   2. 距离压缩；
%   3. 在固定 y,h 条件下，对 x 方向做一维精确方位匹配滤波；
%   4. 验证聚焦峰值是否出现在真实 x 坐标处。

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

% 单点目标参数。
x0 = -15;
y0 = 10;
h0 = 0;
target = [x0, y0, h0, 1.0];

% 将慢时间窗口中心设在该点目标的理论零多普勒时刻附近。
params.t0 = (x0*cos(params.alpha) + (params.H - h0)*sin(params.alpha)) / params.V;

[echo, axes_out, geom] = generate_echo_v3(params, target);
[echo_rc, rc_info] = range_compress_v3(echo, axes_out);

% 在真实 y,h 条件下扫描 x。这里步长取 0.02 m，便于观察峰值位置。
x_grid = linspace(x0 - 8, x0 + 8, 801);
[az_response, az_info] = azimuth_match_filter_v3(echo_rc, axes_out, x_grid, y0, h0);

az_abs = abs(az_response);
[peak_value, idx_peak] = max(az_abs);
x_peak = x_grid(idx_peak);
x_error = x_peak - x0;

% 对比：如果不补偿方位传播相位，直接沿距离徙动曲线抽样求和，积累会明显变差。
idx_true = find(abs(x_grid - x0) == min(abs(x_grid - x0)), 1);
coherent_value = abs(sum(az_info.az_signal_phase_comp(:, idx_true)));
uncomp_value = abs(sum(az_info.az_signal(:, idx_true)));

fprintf('--- 简单方位匹配滤波验证 ---\n');
fprintf('真实目标 x：%.6f m\n', x0);
fprintf('方位匹配峰值 x：%.6f m\n', x_peak);
fprintf('峰值位置误差：%.6e m\n', x_error);
fprintf('峰值幅度：%.6e\n', peak_value);
fprintf('真实 x 处相位补偿后相干积累幅度：%.6e\n', coherent_value);
fprintf('真实 x 处未补偿相位直接积累幅度：%.6e\n', uncomp_value);
fprintf('相干补偿增益：%.3f 倍\n', coherent_value / max(uncomp_value, eps));

figure('Name', '方位匹配滤波响应');
plot(x_grid, az_abs / max(az_abs), 'LineWidth', 1.4); hold on;
xline(x0, '--r', '真实 x');
xline(x_peak, '--k', '峰值 x');
grid on;
xlabel('x 坐标 (m)');
ylabel('归一化幅度');
title('一维方位匹配滤波响应');
legend('匹配滤波响应', '真实 x', '峰值 x', 'Location', 'best');

% 当前 demo 只在固定 y,h 条件下扫描 x，因此聚焦结果是一条 x 向成像剖面。
% 为了更接近“图像”的显示方式，这里将其画成一幅 dB 形式的聚焦成像结果。
focused_image_db = 20*log10(az_abs / max(az_abs) + eps);
h_display = h0 + [-0.05, 0.05];
focused_image_display = repmat(focused_image_db, 2, 1);
figure('Name', '聚焦后的成像结果');
imagesc(x_grid, h_display, focused_image_display);
axis xy;
colormap jet;
colorbar;
caxis([-40, 0]);
xlabel('x 坐标 (m)');
ylabel('h 坐标 (m)');
title('聚焦后的成像结果（固定 y,h 的 x 向切片）');
hold on;
plot(x0, h0, 'wp', 'MarkerSize', 12, 'MarkerFaceColor', 'w');
text(x0, h0, ' 真实目标', 'Color', 'w', 'FontWeight', 'bold');

figure('Name', '方位相位补偿前后对比');
plot(axes_out.ta * 1e3, real(az_info.az_signal(:, idx_true)), 'Color', [0.5 0.5 0.5]); hold on;
plot(axes_out.ta * 1e3, real(az_info.az_signal_phase_comp(:, idx_true)), 'b');
grid on;
xlabel('慢时间 (ms)');
ylabel('实部');
title('真实 x 处方位信号：相位补偿前后实部对比');
legend('补偿前', '补偿后', 'Location', 'best');

figure('Name', '距离压缩幅度与理论徙动曲线');
imagesc(axes_out.range, axes_out.ta * 1e3, abs(echo_rc));
axis xy;
xlabel('距离 (m)');
ylabel('慢时间 (ms)');
title('距离压缩后幅度图与真实目标理论 R(t)');
colorbar;
hold on;
plot(geom.R(:, 1), axes_out.ta * 1e3, 'r-', 'LineWidth', 1.2);

save('azimuth_match_v3_demo.mat', ...
    'params', 'target', 'echo', 'echo_rc', 'axes_out', 'geom', 'rc_info', ...
    'x_grid', 'az_response', 'az_info', 'focused_image_db', ...
    'focused_image_display', 'h_display', 'x_peak', 'x_error');
fprintf('方位匹配滤波示例数据已保存到 azimuth_match_v3_demo.mat\n');
