function data_clean = removeOutliers(dataOriginal, i)
    % 计算平均值和标准差
    data = dataOriginal(:, i);
    mu = mean(data);
    sigma = std(data);

    % 找出超过三倍标准差的数据点
    outliers = abs(data - mu) > 3 * sigma;

    % 剔除这些异常值
    data_clean = dataOriginal(~outliers, :);
end