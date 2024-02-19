% define loading path
folderPath = 'Z:\ICESAT-2\ATL06';
h5Files = dir(fullfile(folderPath, '*.h5'));
gt={'1l' 11;'2l' 21;'3l' 31;'1r' 12;'2r' 22;'3r' 32};

% 获取region10(升轨) 11(极区) 12(降轨) ，再剔除前两个周期
for i = 1: length(h5Files)
    splitData = strsplit(h5Files(i).name,'_');
    str = cell2mat(splitData(3));
    orbitalNum = str(1:4);
    cycleNum = str(end-3: end-2);
    orbitalRegion = str(end-1: end);

    % 清空ascending和descending
    descendingdata = {};
    ascendingdata = {};

    if strcmp(cycleNum, '01')|| strcmp(cycleNum, '02')
        continue
    elseif strcmp(orbitalRegion, '10')
        % Region10为descending
        fileName = strcat(folderPath, '\', h5Files(i).name);
        descendingdata = h5FileRead(fileName);

        if isempty(descendingdata{1,1})
            continue
        end

        % 创建以orbitalNum命名的文件夹
        saveFolderPath = fullfile('F:\Totten\Descending', orbitalNum);
        if ~exist(saveFolderPath, 'dir')
            mkdir(saveFolderPath);
        end

        % 拼接保存路径和文件名
        saveFileName = fullfile(saveFolderPath, strcat(orbitalNum, '_', cycleNum, '.mat'));

        % 保存数据
        save(saveFileName, 'descendingdata');
    elseif strcmp(orbitalRegion, '12')
        % Region12为ascending
        fileName = strcat(folderPath, '\', h5Files(i).name);
        ascendingdata = h5FileRead(fileName);

        if isempty(ascendingdata{1,1})
            continue
        end

        % 创建以orbitalNum命名的文件夹
        saveFolderPath = fullfile('F:\Totten\Ascending', orbitalNum);
        if ~exist(saveFolderPath, 'dir')
            mkdir(saveFolderPath);
        end

        % 拼接保存路径和文件名
        saveFileName = fullfile(saveFolderPath, strcat(orbitalNum, '_', cycleNum, '.mat'));

        % 保存数据
        save(saveFileName, 'ascendingdata');
    end
end

