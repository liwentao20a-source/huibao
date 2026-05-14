clear; clc; close all;

% 太赫兹前下视 SAR 回波生成最小示例。
% 本脚本只生成原始基带回波，不进行成像处理。

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

% 点目标参数：[x, y, h, sigma]。
% x 为沿航迹水平坐标，y 为偏离成像平面的侧向坐标，
% h 为高度，sigma 为复散射系数。
targets = [
     0,  10, 0, 1.0;
     2,  10, 0, 0.8;
    -2,  10, 1, 0.7
];

[echo, axes_out, geom] = generate_echo_v3(params, targets);

fprintf('回波矩阵尺寸：Na x Nr = %d x %d\n', size(echo, 1), size(echo, 2));
fprintf('快时间范围：%.3f ns 到 %.3f ns\n', axes_out.tau(1)*1e9, axes_out.tau(end)*1e9);
fprintf('对应距离范围：%.3f m 到 %.3f m\n', axes_out.range(1), axes_out.range(end));

disp('点目标几何参数：');
for k = 1:size(targets, 1)
    fprintf('  点目标 %d: D = %.6f m, tc = %.6e s, Rmin = %.6f m\n', ...
        k, geom.D(k), geom.tc(k), geom.Rmin(k));
end

figure('Name', '原始回波幅度');
imagesc(axes_out.range, axes_out.ta * 1e3, abs(echo));
axis xy;
xlabel('表观距离 c\tau/2 (m)');
ylabel('慢时间 (ms)');
title('原始基带回波幅度');
colorbar;

save('echo_v3_demo.mat', 'echo', 'axes_out', 'geom', 'params', 'targets');
fprintf('示例数据已保存到 echo_v3_demo.mat\n');
