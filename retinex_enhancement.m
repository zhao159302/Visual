function enhanced_img = retinex_enhancement(img)
% RETINEX_ENHANCEMENT 基于多尺度Retinex的图像增强算法
%   参数:
%     img - 输入的灰度图像
%   返回:
%     enhanced_img - 增强后的图像

% 转换为double类型进行计算
img_double = im2double(img);

% 添加小常数避免对数计算时出现问题
epsilon = 1e-6;
img_log = log(img_double + epsilon);

% 定义不同尺度的高斯核
sigma1 = 15;
sigma2 = 80;
sigma3 = 250;

% 计算不同尺度的模糊图像
img_blur1 = imgaussfilt(img_double, sigma1);
img_blur2 = imgaussfilt(img_double, sigma2);
img_blur3 = imgaussfilt(img_double, sigma3);

% 避免对数计算时出现零值
img_blur1 = img_blur1 + epsilon;
img_blur2 = img_blur2 + epsilon;
img_blur3 = img_blur3 + epsilon;

% 计算不同尺度的Retinex结果
retinex1 = img_log - log(img_blur1);
retinex2 = img_log - log(img_blur2);
retinex3 = img_log - log(img_blur3);

% 加权融合三个尺度的结果
weight1 = 1/3;
weight2 = 1/3;
weight3 = 1/3;
retinex_result = weight1 * retinex1 + weight2 * retinex2 + weight3 * retinex3;

% 调整对比度
min_val = min(retinex_result(:));
max_val = max(retinex_result(:));
enhanced_img = (retinex_result - min_val) / (max_val - min_val);

% 转回uint8类型
enhanced_img = im2uint8(enhanced_img);
end    