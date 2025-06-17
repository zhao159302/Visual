function enhanced_img = improved_enhancement(img)
% IMPROVED_ENHANCEMENT 改进的图像增强算法，结合小波和Retinex的优点
%   参数:
%     img - 输入的灰度图像
%   返回:
%     enhanced_img - 增强后的图像

% 步骤1: 使用Retinex算法进行初步增强
retinex_img = retinex_enhancement(img);

% 步骤2: 对Retinex结果进行小波增强
wavelet_img = wavelet_enhancement(retinex_img);

% 步骤3: 计算原始图像的梯度
img_double = im2double(img);
[Gx, Gy] = imgradientxy(img_double);
G = imgradient(Gx, Gy);

% 步骤4: 自适应融合
alpha = 0.7;  % 基础融合系数
sigma = 10;   % 控制梯度影响的参数

% 归一化梯度
G_norm = mat2gray(G);

% 计算每个像素的融合权重
weights = alpha * exp(-G_norm.^2 / (2 * sigma^2));

% 融合Retinex和小波增强的结果
retinex_double = im2double(retinex_img);
wavelet_double = im2double(wavelet_img);
enhanced_double = weights .* retinex_double + (1 - weights) .* wavelet_double;

% 转回uint8类型
enhanced_img = im2uint8(enhanced_double);
end    