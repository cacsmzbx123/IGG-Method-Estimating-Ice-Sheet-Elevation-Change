BeamPath = {'F:\Totten\result\LS\Ascending','F:\Totten\result\LS\Ascending'};
BeamName = {'f11','f12','f21','f22','f31','f32'};
for n = 1:6
    beam1 = [];
    for m = 1:2
        OneBeamPath = dir(string(strcat(BeamPath(m),'\',BeamName(n))));
        OneBeamPath(1:2, :) = [];
        for i = 1: height(OneBeamPath)
            if OneBeamPath(i).bytes < 1000
                continue
            end
            dataresult = load(strcat(OneBeamPath(i).folder, '\', OneBeamPath(i).name));
            dataresult = dataresult.resultLS;

            FF = find(dataresult(:,1)==0);
            dataresult(FF, :) = [];


            beam1 = [beam1; dataresult];
        end
    end
    beamlatlon = beam1;
    proj1 = projcrs(3031);
    [beamlatlon(:,1), beamlatlon(:,2)] = projinv(proj1, beamlatlon(:,1), beamlatlon(:,2));
    savePath1 = strcat('F:\Totten\result\LS\统计结果（经纬度）\',BeamName(n));
    save(string(savePath1), 'beamlatlon');
    savePath2 = strcat('F:\Totten\result\LS\统计结果（xy）\',BeamName(n));
    save(string(savePath2), 'beam1');

end
%%
% 将xy轴数据放置到一起
pathname = dir('F:\Totten\result\LS\统计结果（xy）');
orbittotal = [];
for i = 3 : 8
    orbit = load(strcat(pathname(i).folder, '\', pathname(i).name));
    orbit = orbit.beam1;
    orbittotal = [orbittotal; orbit];
end
dataRemove = removeOutliers(orbittotal, 4);%取第四列进行粗差剔除

fileID = fopen('your_data_resultLS.dat', 'a+');
if fileID == -1
    error('File cannot be opened');
end
% 遍历 data 数组并写入文件
[rows, ~] = size(dataRemove);
for j = 1:rows
    fprintf(fileID, '%.5f\t%.5f\t%.5f\t%.5f\t%.5f\t%.5f\t%.5f\t%.5f\n', dataRemove(j, :));
end
% 关闭文件
fclose(fileID);
