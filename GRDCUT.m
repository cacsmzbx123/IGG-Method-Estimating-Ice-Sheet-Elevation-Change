result = load('output.dat');
boundary = load('Totten_Boundary.txt');
maxsize = 1.70141000000000e+38;

% 编码进行坐标转换
proj1 = projcrs(3031);
[result(:,1), result(:,2)] = projinv(proj1, result(:,1), result(:,2));   
% plot(result(1:100:end,1),result(1:100:end,2),'.')
% 使用inpolygon检测点是否在边界内
[in, ~] = inpolygon(result(:,1), result(:,2), boundary(:,1), boundary(:,2));


% 将不在边界内的点的值设置为maxsize
result(~in, :) = maxsize;
%%
result11 = load('output.dat');
result11(~in, 3) = maxsize;
fileID = fopen('your_datapingmian_cut111.dat', 'a+');
    if fileID == -1
        error('File cannot be opened');
    end
 [rows, ~] = size(result11);
    for j = 1:rows
        fprintf(fileID, '%.5f\t%.5f\t%.5f\n', result11(j, :));
    end
    % 关闭文件
    fclose(fileID);
%% 
idx = result11(:,3)>100000;
result11(idx, :) = [];
mean(result11(:,3))
histogram
%%
% 创建直方图
data = result11(:,3);
% 计算直方图数据
binWidth = 0.02;
edges = -1:binWidth:1;
counts = histcounts(data, edges);

% 将计数转换为百分比
totalCount = sum(counts);
percentages = (counts / totalCount) * 100;

% 计算bin中心
binCenters = edges(1:end-1) + binWidth/2;

% 绘制以百分比为单位的直方图
figure;
bar(binCenters, percentages, 'BarWidth', 1);

% 在直方图上绘制连接顶点的线
% hold on;
% plot(binCenters, percentages, 'r-', 'LineWidth', 2);

% 设置标题和轴标签

xlabel('Elevation Change(m/yr)');
ylabel('Percentage (%)');

ylim([0 20]);

xline(mean(data))

hold off;
%%
result = load("your_data_result_sigma.dat")
maxsize = 1.70141000000000e+38;
result(~in, 3) = maxsize;

fileID = fopen('your_datapingmian_cutsigma.dat', 'a+');
    if fileID == -1
        error('File cannot be opened');
    end
 [rows, ~] = size(result);
    for j = 1:rows
        fprintf(fileID, '%.5f\t%.5f\t%.5f\n', result(j, :));
    end
    % 关闭文件
    fclose(fileID);

    %%
    idx = result(:,3)>100000;
result(idx, :) = [];
mean(result(:,3))
