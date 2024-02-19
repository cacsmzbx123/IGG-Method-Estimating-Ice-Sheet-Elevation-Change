function [result1, result2] = IGG3Estimation(subMatrix, elevationCal)
% 输入:
% subMatrix - 系数矩阵
% elevationCal - 常数项阵

% 输出:
% result1,reult2 - 计算得到的LS结果与IGGⅢ结果
% 每个结果内含六个参数，包括解算的五个参数和最后一个误差
K0 = 1;
K1 = 2.5;

n = height(subMatrix');
maxIter = 3;
tol = 1e-3;


B0 = subMatrix';
P = eye(n);
L = elevationCal';

% 初始估计
v1 = inv((B0' * P * B0))* (B0' * P * L);
res1 = L - B0 * v1;
sigma1 = sqrt((res1' * P * res1) / (n - 5));

v0 = v1;


for iter = 1:maxIter
    % 计算残差和标准偏差
    res0 = L - B0 * v0;
    sigma = sqrt((res0' * P * res0) / (n - 5));

    % 更新权重矩阵 Q
    P = diag(arrayfun(@(x) computeWeight(x, sigma, K0, K1), res0));

    % 使用加权最小二乘法更新估计值 v0
    v0_new = inv((B0' * P * B0))* (B0' * P * L);

    % 检查收敛
    if norm(v0_new - v0) < tol
        v0 = v0_new;
        sigma0 = sqrt((res0' * P * res0) / (n - 5));
        break;
    end
    v0 = v0_new;
    res0 = L - B0 * v0;
    sigma0 = sqrt((res0' * P * res0) / (n - 5));
end
result1 = vertcat(v1, sigma1);
result2 = vertcat(v0, sigma0);
end