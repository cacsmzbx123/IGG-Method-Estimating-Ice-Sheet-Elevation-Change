function value = inverseDistanceWeighting(x, values, targetX, power)
    % x - 已知点的位置数组
    % values - 已知点的值
    % targetX - 目标点的位置
    % power - 幂参数，决定了距离的影响程度

    % 计算所有已知点到目标点的距离
    distances = abs(x - targetX);

    % 防止除以0的情况，对于距离非常小的值进行调整
    distances(distances == 0) = eps;

    % 计算权重（使用距离的倒数的幂）
    weights = 1 ./ distances.^power;

    % 计算加权平均
    value = sum(weights .* values) / sum(weights);
end