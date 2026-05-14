function [echo_rc, rc_info] = range_compress_v3(echo, axes_in, varargin)
%RANGE_COMPRESS_V3 对 generate_echo_v3 生成的原始回波进行距离压缩。
%
%   [echo_rc, rc_info] = range_compress_v3(echo, axes_in)
%   [echo_rc, rc_info] = range_compress_v3(echo, axes_in, 'Window', window_name)
%
% 输入：
%   echo      原始基带回波矩阵，维度为 Na x Nr
%   axes_in   generate_echo_v3 输出的 axes 结构体，至少包含：
%             axes_in.Kr、axes_in.params.fs、axes_in.params.B
%
% 输出：
%   echo_rc   距离压缩后的回波矩阵，维度仍为 Na x Nr
%   rc_info   距离压缩使用的频率轴、匹配滤波器等信息
%
% 频域距离压缩模型：
%   原始基带 LFM 回波可近似写为
%       s(tau,t) = rect((tau-td)/Tp) exp(j*pi*Kr*(tau-td)^2) exp(j*phi)
%
%   对快时间 tau 做傅里叶变换后，LFM 二次相位近似为
%       exp(-j*pi*f^2/Kr)
%
%   因此距离压缩匹配滤波器取
%       H(f) = exp(j*pi*f^2/Kr), |f| <= B/2
%
%   若加入窗函数，则只改变距离旁瓣，不改变理论峰值位置。

p = inputParser;
addParameter(p, 'Window', 'rect', @(x) ischar(x) || isstring(x));
parse(p, varargin{:});
window_name = lower(string(p.Results.Window));

Kr = axes_in.Kr;
fs = axes_in.params.fs;
B = axes_in.params.B;

[Na, Nr] = size(echo);

% 构造与 fftshift 后频谱对应的快时间频率轴。
f = (-floor(Nr/2):ceil(Nr/2)-1) * (fs / Nr);

% 频域匹配滤波器。带宽外置零，相当于做距离向带限滤波。
band_mask = abs(f) <= B/2;
H = exp(1j*pi*(f.^2)/Kr) .* band_mask;

% 可选窗函数，用于降低距离压缩旁瓣。
win = make_range_window(window_name, Nr);
H = H .* win;

% 沿快时间维做频域匹配滤波。
S = fftshift(fft(echo, [], 2), 2);
echo_rc = ifft(ifftshift(S .* H, 2), [], 2);

rc_info.f = f;
rc_info.H = H;
rc_info.band_mask = band_mask;
rc_info.window = win;
rc_info.window_name = window_name;
rc_info.Kr = Kr;
rc_info.fs = fs;
rc_info.B = B;
rc_info.Na = Na;
rc_info.Nr = Nr;

end

function win = make_range_window(window_name, Nr)
switch window_name
    case {"rect", "rectangle", "none"}
        win = ones(1, Nr);
    case {"hann", "hanning"}
        win = hann(Nr).';
    case "hamming"
        win = hamming(Nr).';
    case "kaiser"
        beta = 6;
        win = kaiser(Nr, beta).';
    otherwise
        error('range_compress_v3:BadWindow', ...
            '不支持的距离向窗函数：%s。可选 rect、hann、hamming、kaiser。', window_name);
end
end
