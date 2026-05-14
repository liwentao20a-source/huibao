function [img, bp_info] = bp_image_v3(echo_rc, axes_in, x_grid, h_grid, y_ref)
%BP_IMAGE_V3 基于 v3 几何模型的二维后向投影成像。
%
%   [img, bp_info] = bp_image_v3(echo_rc, axes_in, x_grid, h_grid, y_ref)
%
% 输入：
%   echo_rc   距离压缩后的回波矩阵，维度为 Na x Nr
%   axes_in   generate_echo_v3 输出的 axes 结构体
%   x_grid    成像网格的 x 坐标，单位 m
%   h_grid    成像网格的 h 坐标，单位 m
%   y_ref     成像时假设的 y 坐标，单位 m
%
% 输出：
%   img       二维复图像，维度为 length(h_grid) x length(x_grid)
%   bp_info   成像中使用的慢时间、距离轴和参考 y 坐标等信息
%
% 基本思想：
%   对每个候选像素 (x,h)，计算该像素到平台的理论瞬时斜距 R(t)，
%   从距离压缩数据中沿 R(t) 插值得到该像素对应的方位信号，
%   再乘以 exp(j*4*pi*fc*R/c) 补偿传播相位并沿慢时间相干积累。
%
%   这就是二维时域 BP 成像的核心形式。这里暂时固定 y = y_ref，
%   因此图像平面为 x-h 平面上的一个 y 切片。

params = axes_in.params;
c = params.c;
fc = params.fc;
ta = axes_in.ta(:);
range_axis = axes_in.range(:).';
r0 = range_axis(1);
dr = range_axis(2) - range_axis(1);
Nr = numel(range_axis);

Na = numel(ta);
Nx = numel(x_grid);
Nh = numel(h_grid);

if size(echo_rc, 1) ~= Na
    error('bp_image_v3:BadSize', ...
        'echo_rc 的慢时间维度必须与 axes_in.ta 长度一致。');
end

xp = params.V * cos(params.alpha) * ta;
hp = params.H - params.V * sin(params.alpha) * ta;

img = complex(zeros(Nh, Nx));

for ih = 1:Nh
    h = h_grid(ih);
    for ix = 1:Nx
        x = x_grid(ix);

        R = sqrt((x - xp).^2 + y_ref.^2 + (hp - h).^2);

        s_pixel = interp_range_uniform(echo_rc, R, r0, dr, Nr);

        phase_ref = exp(1j * 4*pi*fc*R/c);
        img(ih, ix) = sum(s_pixel .* phase_ref);
    end
end

bp_info.x_grid = x_grid;
bp_info.h_grid = h_grid;
bp_info.y_ref = y_ref;
bp_info.ta = ta;
bp_info.range_axis = range_axis;

end

function s_pixel = interp_range_uniform(echo_rc, R, r0, dr, Nr)
%INTERP_RANGE_UNIFORM 对均匀距离轴上的距离压缩数据做逐慢时间线性插值。
%
% echo_rc 的第 ia 行对应第 ia 个慢时间，R(ia) 是该慢时间下待取样距离。

Na = numel(R);
s_pixel = complex(zeros(Na, 1));

pos = (R - r0) / dr + 1;
idx = floor(pos);
frac = pos - idx;

valid = idx >= 1 & idx < Nr;
if any(valid)
    ia = find(valid);
    idx_valid = idx(valid);
    frac_valid = frac(valid);

    ind1 = sub2ind(size(echo_rc), ia, idx_valid);
    ind2 = sub2ind(size(echo_rc), ia, idx_valid + 1);

    s1 = echo_rc(ind1);
    s2 = echo_rc(ind2);
    s_pixel(valid) = (1 - frac_valid) .* s1 + frac_valid .* s2;
end
end
