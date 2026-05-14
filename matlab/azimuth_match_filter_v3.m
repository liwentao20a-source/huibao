function [az_response, az_info] = azimuth_match_filter_v3(echo_rc, axes_in, x_grid, y_ref, h_ref)
%AZIMUTH_MATCH_FILTER_V3 基于精确斜距模型进行一维方位匹配滤波。
%
%   [az_response, az_info] = azimuth_match_filter_v3(echo_rc, axes_in, x_grid, y_ref, h_ref)
%
% 输入：
%   echo_rc      距离压缩后的回波矩阵，维度为 Na x Nr
%   axes_in      generate_echo_v3 输出的 axes 结构体
%   x_grid       待搜索的方位向/水平向坐标网格，单位 m
%   y_ref        假设目标的 y 坐标，单位 m
%   h_ref        假设目标的高度坐标，单位 m
%
% 输出：
%   az_response  每个 x_grid 位置对应的方位匹配滤波复响应
%   az_info      中间变量，包括理论距离轨迹、插值后的方位信号等
%
% 处理思想：
%   对于每个候选位置 (x, y_ref, h_ref)，先计算其理论瞬时斜距 R_x(t)，
%   然后从距离压缩数据中沿 R_x(t) 这条距离徙动曲线插值得到方位信号，
%   最后乘以 exp(j*4*pi*fc*R_x(t)/c) 补偿传播相位并沿慢时间相干积累。
%
%   这一步本质上是“已知 y,h 条件下的一维精确方位匹配滤波”。它比完整
%   二维 BP 成像简单，但可以直接验证方位相位模型是否正确。

params = axes_in.params;
c = params.c;
fc = params.fc;
ta = axes_in.ta(:);
range_axis = axes_in.range(:).';

Na = numel(ta);
Nx = numel(x_grid);

if size(echo_rc, 1) ~= Na
    error('azimuth_match_filter_v3:BadSize', ...
        'echo_rc 的慢时间维度必须与 axes_in.ta 长度一致。');
end

xp = params.V * cos(params.alpha) * ta;
hp = params.H - params.V * sin(params.alpha) * ta;

az_response = complex(zeros(1, Nx));
range_track = zeros(Na, Nx);
az_signal = complex(zeros(Na, Nx));
az_signal_phase_comp = complex(zeros(Na, Nx));

for ix = 1:Nx
    x = x_grid(ix);
    R = sqrt((x - xp).^2 + y_ref.^2 + (hp - h_ref).^2);
    range_track(:, ix) = R;

    % 沿理论距离徙动轨迹，从距离压缩后的二维数据中抽取方位相位历程。
    s_az = complex(zeros(Na, 1));
    for ia = 1:Na
        s_az(ia) = interp1(range_axis, echo_rc(ia, :), R(ia), 'linear', 0);
    end

    % 原始回波中包含 exp(-j*4*pi*fc*R/c)，因此这里乘以共轭相位进行匹配。
    phase_ref = exp(1j * 4*pi*fc*R/c);
    s_comp = s_az .* phase_ref;

    az_signal(:, ix) = s_az;
    az_signal_phase_comp(:, ix) = s_comp;
    az_response(ix) = sum(s_comp);
end

az_info.range_track = range_track;
az_info.az_signal = az_signal;
az_info.az_signal_phase_comp = az_signal_phase_comp;
az_info.x_grid = x_grid;
az_info.y_ref = y_ref;
az_info.h_ref = h_ref;
az_info.ta = ta;
az_info.range_axis = range_axis;

end
