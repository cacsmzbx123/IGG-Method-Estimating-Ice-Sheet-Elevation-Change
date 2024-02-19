function weight = computeWeight(betaValue, sigma, K0, K1)
    % 使用提供的公式计算权重
    if abs(betaValue/sigma) <= K0
        weight = 1; % 当前权重保持不变
    elseif abs(betaValue/sigma) > K0 && abs(betaValue/sigma) <= K1
        weight = K0 * (K1 - abs(betaValue/sigma))^2 / (K1 - K0)^2;
    else
        weight = 0; % 与极端异常值相关的权重设置为0
    end
end