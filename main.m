% 电力设备红外图像增强算法设计课程设计
% 主程序：读取图像并调用各种增强算法进行对比


% % 读取电力设备红外图像
% img = imread(' (4).jpg');
% 
% 
% % 如果是彩色图像，转换为灰度图像
% if size(img, 3) == 3
%     img_gray = rgb2gray(img);
% else
%     img_gray = img;
% end
% 
% % 显示原始图像
% figure('Position', [100, 100, 1200, 800]);
% subplot(2, 3, 1);
% imshow(img_gray);
% title('原始红外图像');
% 
% % 1. 直方图均衡化   histeq 使用直方图均衡增强对比度
% img_hist = histeq(img_gray);% J = histeq(I) 变换灰度图像 I，以使输出灰度图像 J 的直方图具有 64 个 bin 且大致平坦。
% subplot(2, 3, 2);
% imshow(img_hist);
% title('直方图均衡化');
% 
% % 2. 限制对比度自适应直方图均衡化(CLAHE)
% img_clahe = adapthisteq(img_gray, 'ClipLimit', 0.02);
% subplot(2, 3, 3);
% imshow(img_clahe);
% title('CLAHE增强');
% 
% % 3. 基于Retinex的增强算法
% img_retinex = retinex_enhancement(img_gray);
% subplot(2, 3, 4);
% imshow(img_retinex);
% title('Retinex增强');
% 
% % 4. 基于小波变换的增强算法
% img_wavelet = wavelet_enhancement(img_gray);
% subplot(2, 3, 5);
% imshow(img_wavelet);
% title('小波变换增强');
% 
% % 5. 提出的改进算法（结合小波和Retinex）
% img_improved = improved_enhancement(img_gray);
% subplot(2, 3, 6);
% imshow(img_improved);
% title('改进算法增强');
% 
% % 保存结果
% save_results(img_gray, img_hist, img_clahe, img_retinex, img_wavelet, img_improved);
% 
% % 显示评价指标
% display_metrics(img_gray, img_hist, img_clahe, img_retinex, img_wavelet, img_improved);
% 
% fprintf('电力设备红外图像增强算法设计完成\n');    

function main()
% MAIN 电力设备红外图像增强算法主函数
% 批量处理100张图片，比较不同增强算法效果并计算平均指标

%% 参数配置
imageDir = 'D:\game\ComputerVisual2\ComputerVisual\Material'; % 图像文件夹路径
outputDir = 'enhanced_results';   % 输出结果文件夹
imageCount = 100;                % 处理的图片数量

% 创建输出文件夹
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

%% 初始化结果存储数组
metrics_original = zeros(imageCount, 3); % 原始图像指标 [熵, 对比度, UIQM]
metrics_hist = zeros(imageCount, 3);     % 直方图均衡化指标
metrics_clahe = zeros(imageCount, 3);    % CLAHE指标
metrics_retinex = zeros(imageCount, 3);  % Retinex指标
metrics_wavelet = zeros(imageCount, 3);  % 小波增强指标
metrics_improved = zeros(imageCount, 3); % 改进算法指标

%% 批量处理图像
fprintf('开始处理 %d 张图像...\n', imageCount);

% 获取图像文件列表
imageFiles = dir(fullfile(imageDir, '*.jpg'));
if length(imageFiles) < imageCount
    warning('图像数量不足，仅能处理 %d 张', length(imageFiles));
    imageCount = length(imageFiles);
end

% 循环处理每张图像
for i = 1:imageCount
    % 读取图像
    imgPath = fullfile(imageDir, imageFiles(i).name);
    img = imread(imgPath);

    % 转换为灰度图像
    if size(img, 3) == 3
        img_gray = rgb2gray(img);
    else
        img_gray = img;
    end

    % 应用不同的增强算法
    fprintf('正在处理第 %d 张图像: %s\n', i, imageFiles(i).name);

    % 1. 直方图均衡化
    img_hist = histeq(img_gray);

    % 2. CLAHE
    img_clahe = adapthisteq(img_gray);

    % 3. Retinex增强 (简化版)
    img_retinex = retinex_enhancement(img_gray);

    % 4. 小波增强
    img_wavelet = wavelet_enhancement(img_gray);

    % 5. 改进算法 (结合小波和Retinex)
    img_improved = improved_enhancement(img_gray);

    % 保存增强结果
    [~, imgName, ~] = fileparts(imageFiles(i).name);
    imwrite(img_hist, fullfile(outputDir, [imgName '_hist.jpg']));
    imwrite(img_clahe, fullfile(outputDir, [imgName '_clahe.jpg']));
    imwrite(img_retinex, fullfile(outputDir, [imgName '_retinex.jpg']));
    imwrite(img_wavelet, fullfile(outputDir, [imgName '_wavelet.jpg']));
    imwrite(img_improved, fullfile(outputDir, [imgName '_improved.jpg']));

    % 计算评价指标 (修改后的display_metrics函数返回指标)
    metrics = display_metrics(img_gray, img_hist, img_clahe, img_retinex, img_wavelet, img_improved);

    % 存储指标结果
    metrics_original(i, :) = [metrics.original.entropy, metrics.original.contrast, metrics.original.uiqm];
    metrics_hist(i, :) = [metrics.hist.entropy, metrics.hist.contrast, metrics.hist.uiqm];
    metrics_clahe(i, :) = [metrics.clahe.entropy, metrics.clahe.contrast, metrics.clahe.uiqm];
    metrics_retinex(i, :) = [metrics.retinex.entropy, metrics.retinex.contrast, metrics.retinex.uiqm];
    metrics_wavelet(i, :) = [metrics.wavelet.entropy, metrics.wavelet.contrast, metrics.wavelet.uiqm];
    metrics_improved(i, :) = [metrics.improved.entropy, metrics.improved.contrast, metrics.improved.uiqm];
end

%% 计算平均指标
avg_metrics = struct();
avg_metrics.original = mean(metrics_original);
avg_metrics.hist = mean(metrics_hist);
avg_metrics.clahe = mean(metrics_clahe);
avg_metrics.retinex = mean(metrics_retinex);
avg_metrics.wavelet = mean(metrics_wavelet);
avg_metrics.improved = mean(metrics_improved);

%% 打印平均结果
fprintf('\n=== %d 张图像的平均评价指标 ===\n', imageCount);
fprintf('-------------------------------------------------------------------\n');
fprintf('方法\t\t熵\t\t对比度\t\tUIQM\n');
fprintf('-------------------------------------------------------------------\n');
fprintf('原始图像\t%.4f\t\t%.4f\t\t%.4f\n', avg_metrics.original);
fprintf('直方图均衡化\t%.4f\t\t%.4f\t\t%.4f\n', avg_metrics.hist);
fprintf('CLAHE\t\t%.4f\t\t%.4f\t\t%.4f\n', avg_metrics.clahe);
fprintf('Retinex\t\t%.4f\t\t%.4f\t\t%.4f\n', avg_metrics.retinex);
fprintf('小波增强\t%.4f\t\t%.4f\t\t%.4f\n', avg_metrics.wavelet);
fprintf('改进算法\t%.4f\t\t%.4f\t\t%.4f\n', avg_metrics.improved);
fprintf('-------------------------------------------------------------------\n');

%% 可视化平均结果
labels = {'原始图像', '直方图均衡化', 'CLAHE', 'Retinex', '小波增强', '改进算法'};

% 熵对比
figure('Position', [100, 100, 1200, 400]);
subplot(1, 3, 1);
bar([avg_metrics.original(1), avg_metrics.hist(1), avg_metrics.clahe(1), ...
     avg_metrics.retinex(1), avg_metrics.wavelet(1), avg_metrics.improved(1)]);
set(gca, 'XTick', 1:6, 'XTickLabel', labels, 'XTickLabelRotation', 45);
title('平均熵比较');
ylabel('熵');

% 对比度对比
subplot(1, 3, 2);
bar([avg_metrics.original(2), avg_metrics.hist(2), avg_metrics.clahe(2), ...
     avg_metrics.retinex(2), avg_metrics.wavelet(2), avg_metrics.improved(2)]);
set(gca, 'XTick', 1:6, 'XTickLabel', labels, 'XTickLabelRotation', 45);
title('平均对比度比较');
ylabel('对比度');

% UIQM对比
subplot(1, 3, 3);
bar([avg_metrics.original(3), avg_metrics.hist(3), avg_metrics.clahe(3), ...
     avg_metrics.retinex(3), avg_metrics.wavelet(3), avg_metrics.improved(3)]);
set(gca, 'XTick', 1:6, 'XTickLabel', labels, 'XTickLabelRotation', 45);
title('平均UIQM比较');
ylabel('UIQM');

sgtitle('不同增强算法的平均评价指标对比');
saveas(gcf, fullfile(outputDir, 'average_metrics_comparison.jpg'));

fprintf('\n处理完成！结果已保存到 %s 文件夹\n', outputDir);
end

%% 改进的增强算法 (结合小波和Retinex)
function img_improved = improved_enhancement(img)
% 先进行Retinex增强
img_retinex = retinex_enhancement(img);
% 再进行小波增强
img_improved = wavelet_enhancement(img_retinex);
end