function enhanced_img = wavelet_enhancement(img)
% WAVELET_ENHANCEMENT 基于小波变换的图像增强算法
%   参数:
%     img - 输入的灰度图像
%   返回:
%     enhanced_img - 增强后的图像

% 转换为double类型进行计算
img_double = im2double(img);

% 进行二层小波分解 (使用db4小波)
[c, s] = wavedec2(img_double, 2, 'db4');

% 提取近似系数和细节系数
a2 = appcoef2(c, s, 'db4', 2);
[h2, v2, d2] = detcoef2('all', c, s, 2);
[h1, v1, d1] = detcoef2('all', c, s, 1);

% 显示各系数维度（用于调试）
fprintf('小波系数维度信息：\n');
fprintf('a2: %dx%d\n', size(a2,1), size(a2,2));
fprintf('h2: %dx%d\n', size(h2,1), size(h2,2));
fprintf('v2: %dx%d\n', size(v2,1), size(v2,2));
fprintf('d2: %dx%d\n', size(d2,1), size(d2,2));
fprintf('h1: %dx%d\n', size(h1,1), size(h1,2));
fprintf('v1: %dx%d\n', size(v1,1), size(v1,2));
fprintf('d1: %dx%d\n', size(d1,1), size(d1,2));

% 增强细节系数 (提高对比度)
enhance_factor = 1.5;  % 增强因子
h2 = h2 * enhance_factor;
v2 = v2 * enhance_factor;
d2 = d2 * enhance_factor;
h1 = h1 * enhance_factor;
v1 = v1 * enhance_factor;
d1 = d1 * enhance_factor;

% 正确重构小波系数（按列向量顺序排列）
a2_col = a2(:);
h2_col = h2(:);
v2_col = v2(:);
d2_col = d2(:);
h1_col = h1(:);
v1_col = v1(:);
d1_col = d1(:);

% 按正确顺序组合系数向量
c_new = [a2_col; h2_col; v2_col; d2_col; h1_col; v1_col; d1_col];

% 使用原始尺寸信息进行重构
enhanced_img_double = waverec2(c_new, s, 'db4');

% 裁剪到有效范围
enhanced_img_double = max(min(enhanced_img_double, 1), 0);

% 转回uint8类型
enhanced_img = im2uint8(enhanced_img_double);
end