function save_results(original, hist, clahe, retinex, wavelet, improved)
% SAVE_RESULTS 保存各种增强算法的结果图像
%   参数:
%     original - 原始图像
%     hist - 直方图均衡化结果
%     clahe - CLAHE结果
%     retinex - Retinex增强结果
%     wavelet - 小波增强结果
%     improved - 改进算法结果

% 创建保存结果的文件夹
if ~exist('results', 'dir')
    mkdir('results');
end

% 保存各种增强结果
imwrite(original, 'results/original.jpg');
imwrite(hist, 'results/histogram_equalization.jpg');
imwrite(clahe, 'results/clahe.jpg');
imwrite(retinex, 'results/retinex.jpg');
imwrite(wavelet, 'results/wavelet.jpg');
imwrite(improved, 'results/improved.jpg');

fprintf('结果已保存到results文件夹\n');
end    