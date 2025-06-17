function metrics = display_metrics(original, hist, clahe, retinex, wavelet, improved)
% DISPLAY_METRICS 计算并返回各种增强算法的评价指标
%   参数:
%     original - 原始图像
%     hist - 直方图均衡化结果
%     clahe - CLAHE结果
%     retinex - Retinex增强结果
%     wavelet - 小波增强结果
%     improved - 改进算法结果
%   返回:
%     metrics - 包含所有算法评价指标的结构体

% 确保所有图像为灰度图像
if size(original, 3) == 3
    original = rgb2gray(original);
    hist = rgb2gray(hist);
    clahe = rgb2gray(clahe);
    retinex = rgb2gray(retinex);
    wavelet = rgb2gray(wavelet);
    improved = rgb2gray(improved);
end

% 转换为double类型进行计算
original_double = im2double(original);
hist_double = im2double(hist);
clahe_double = im2double(clahe);
retinex_double = im2double(retinex);
wavelet_double = im2double(wavelet);
improved_double = im2double(improved);

% 计算各种评价指标
metrics = struct();

% 原始图像
metrics.original.entropy = entropy(original);
metrics.original.contrast = image_contrast(original);
metrics.original.uiqm = calculate_uiqm(original_double);

% 直方图均衡化
metrics.hist.entropy = entropy(hist);
metrics.hist.contrast = image_contrast(hist);
metrics.hist.uiqm = calculate_uiqm(hist_double);

% CLAHE
metrics.clahe.entropy = entropy(clahe);
metrics.clahe.contrast = image_contrast(clahe);
metrics.clahe.uiqm = calculate_uiqm(clahe_double);

% Retinex
metrics.retinex.entropy = entropy(retinex);
metrics.retinex.contrast = image_contrast(retinex);
metrics.retinex.uiqm = calculate_uiqm(retinex_double);

% 小波增强
metrics.wavelet.entropy = entropy(wavelet);
metrics.wavelet.contrast = image_contrast(wavelet);
metrics.wavelet.uiqm = calculate_uiqm(wavelet_double);

% 改进算法
metrics.improved.entropy = entropy(improved);
metrics.improved.contrast = image_contrast(improved);
metrics.improved.uiqm = calculate_uiqm(improved_double);

% 打印评价指标表格 (可选)
fprintf('\n图像增强算法评价指标:\n');
fprintf('-------------------------------------------------------------------\n');
fprintf('方法\t\t熵\t\t对比度\t\tUIQM\n');
fprintf('-------------------------------------------------------------------\n');
fprintf('原始图像\t%.4f\t\t%.4f\t\t%.4f\n', metrics.original.entropy, metrics.original.contrast, metrics.original.uiqm);
fprintf('直方图均衡化\t%.4f\t\t%.4f\t\t%.4f\n', metrics.hist.entropy, metrics.hist.contrast, metrics.hist.uiqm);
fprintf('CLAHE\t\t%.4f\t\t%.4f\t\t%.4f\n', metrics.clahe.entropy, metrics.clahe.contrast, metrics.clahe.uiqm);
fprintf('Retinex\t\t%.4f\t\t%.4f\t\t%.4f\n', metrics.retinex.entropy, metrics.retinex.contrast, metrics.retinex.uiqm);
fprintf('小波增强\t%.4f\t\t%.4f\t\t%.4f\n', metrics.wavelet.entropy, metrics.wavelet.contrast, metrics.wavelet.uiqm);
fprintf('改进算法\t%.4f\t\t%.4f\t\t%.4f\n', metrics.improved.entropy, metrics.improved.contrast, metrics.improved.uiqm);
fprintf('-------------------------------------------------------------------\n');
end

% 计算图像对比度
function cont = image_contrast(img)
img_double = im2double(img);
cont = var(img_double(:));
end

% 计算无参考图像质量评价（UIQM）
function uiqm_val = calculate_uiqm(img)
% 确保图像为double类型
if ~isa(img, 'double')
    img = im2double(img);
end

% 计算亮度对比度（Brenner梯度）
dx = img(1:end-2, 2:end-1) - img(3:end, 2:end-1);
dy = img(2:end-1, 1:end-2) - img(2:end-1, 3:end);
brisque = mean(dx(:).^2 + dy(:).^2);

% 计算清晰度（方差）
variance = var(img(:));

% 计算熵
[p, ~] = histcounts(img(:), 256, 'Normalization', 'probability');
p = p(p > 0); % 移除零概率
entropy_val = -sum(p .* log2(p));

% 组合三个指标
uiqm_val = 0.4 * brisque + 0.3 * variance + 0.3 * entropy_val;
end