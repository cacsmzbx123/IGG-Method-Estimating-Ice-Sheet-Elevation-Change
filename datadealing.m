% 遍历升轨和降轨文件夹   
% ['F:\Totten\Ascending'] ['F:\Totten\Descending']
folderPath = 'F:\Totten\Descending';
files = dir(folderPath);
files(1:2, :) = [];
dataAll = struct('f11', [], 'f12', [], 'f21', [], 'f22', [], 'f31', [], 'f32', []); % 初始化一个空结构体用于存储所有数据

for i = 1: height(files)
    orbitnumPath = strcat(files(i).folder, '\', files(i).name);
    orbitnum = dir(orbitnumPath);
    orbitnum(1:2, :) = [];
    for j = 1: height(orbitnum)
        tempData = load(fullfile(orbitnum(j).folder, orbitnum(j).name));
        dataall = tempData.descendingdata; % 将数据添加到结构体数组中
        for k = 1: height(dataall)
            beamNum = cell2mat(dataall(k, 2));
        switch beamNum
            case 11
                dataAll(j).f11 = cell2mat(dataall(k, 1));
            case 12
                dataAll(j).f12 = cell2mat(dataall(k, 1));
            case 21
                dataAll(j).f21 = cell2mat(dataall(k, 1));
            case 22
                dataAll(j).f22 = cell2mat(dataall(k, 1));
            case 31
                dataAll(j).f31 = cell2mat(dataall(k, 1));
            case 32
                dataAll(j).f32 = cell2mat(dataall(k, 1));
        end
        end
    end
    savePath = strcat('F:\Totten\Matrix_reset\Descending\',files(i).name);
    save(savePath, 'dataAll');
end



