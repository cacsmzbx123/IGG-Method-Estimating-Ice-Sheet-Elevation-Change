OneBeamPath = dir('F:\Totten\result\Ascending\f32');
OneBeamPath(1:2, :) = [];
beam1 = [];
for i = 1: height(OneBeamPath)
    if OneBeamPath(i).bytes < 1000
        continue
    end
    dataresult = load(strcat(OneBeamPath(i).folder, '\', OneBeamPath(i).name));
    dataresult = dataresult.result;

    beam1 = [beam1; dataresult];
end

[max(beam1(:,4)), min(beam1(:,4)), mean(beam1(:,4))]

boundary = cell2mat(table2cell(TottenBoundary))
plot(boundary(:,2), boundary(:,1), '.')

%%
worldmap('Antarctica');

% 获取地图边界
load coastlines;

% 使用 plotm 函数绘制南极的轮廓
plotm(coastlat, coastlon);

% 添加网格线和标签
setm(gca, 'MLabelLocation', 30, 'PLabelLocation', -70, 'MLineLocation', 30, 'PLineLocation', 10);
gridm on;



% 添加地图标题
title('Map of Antarctica');

boundary = load("D:\Desktop\Totten_Boundary.txt");
plotm(boundary(:,1), boundary(:,2), 'r.-')
%%

path = dir("F:\Totten\result\IGG\Descending\f12");
dataall = [];meanV = [];meanSigma =[];
for i = 1: height(path)
    if path(i).bytes < 1000
        continue
    end


    orbitdata = load(strcat(path(i).folder, '\', path(i).name));
    orbitdata = orbitdata.resultIGG;

    FF = find(orbitdata(:,1)==0);
    orbitdata(FF, :) = [];
    dataall = [dataall; orbitdata];
end

dataalllatlon = dataall;
proj1 = projcrs(3031);
[dataalllatlon(:,1), dataalllatlon(:,2)] = projinv(proj1, dataalllatlon(:,1), dataalllatlon(:,2));

savePath1 = strcat('F:\Totten\result\统计结果 （经纬度）\Descending_f12');
save(savePath1, 'dataalllatlon');
savePath2 = strcat('F:\Totten\result\统计结果（xy）\Descending_f12');
save(savePath2, 'dataall');




%%
% 绘制统计直方图

data = load('F:\Totten\result\统计结果（xy）\Ascending_f11.mat');
data = data.dataall;

vh = data(:, 4);

% 设置直方图的边界和条形数量
edges = -1.5:0.001:1.5;

% 绘制直方图
histogram(vh, edges, 'Normalization', 'probability');

% 设置图表标题和轴标签
title('频率统计直方图');
xlabel('数值');
ylabel('频率');
% 将 y 轴刻度格式化为百分比
ytickformat('percentage');
mean(vh)
median(vh)


%%
data = load('F:\Totten\result\统计结果 （经纬度）\Descending_f12.mat');
data = data.dataalllatlon;

dataRemove = removeOutliers(data, 4);
mean(dataRemove(:,4))
median(dataRemove(:,4))
scatter(dataRemove(1:30:end,2), dataRemove(1:30:end,1), 5, dataRemove(1:30:end,4), 'filled')
colorbar
caxis([-0.5 0.5])
hold on
boundary = load("D:\Desktop\Totten_Boundary.txt");
plot(boundary(:,2), boundary(:,1), 'r.-')
%%

% 数据重新进行存储
Pathname = "F:\Totten\result\统计结果（xy）\";
Filename = {'Ascending_f11', 'Ascending_f12', 'Ascending_f21', 'Ascending_f22', 'Ascending_f31', 'Ascending_f32',...
    'Descending_f11', 'Descending_f12', 'Descending_f21', 'Descending_f22', 'Descending_f31', 'Descending_f32'};
dataintotal = [];
for i = 1: 12
    data = load(strcat(Pathname,Filename(i)));
    data = data.dataall;
    dataRemove = removeOutliers(data, 4);
    dataintotal = [dataintotal; dataRemove];
end
%%
    fileID = fopen('your_data_result.dat', 'a+');
    if fileID == -1
        error('File cannot be opened');
    end
    % 遍历 data 数组并写入文件
    [rows, ~] = size(dataintotal);
    for j = 1:rows
        fprintf(fileID, '%.5f\t%.5f\t%.5f\t%.5f\t%.5f\t%.5f\t%.5f\t%.5f\n', dataintotal(j, :));
    end
    % 关闭文件
    fclose(fileID);
%% 

plot(output(:,1),output(:,2),'.')
