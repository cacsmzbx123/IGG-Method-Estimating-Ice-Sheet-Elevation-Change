tic;
folderPath = dir('F:\Totten\Matrix_reset\Descending');
folderPath(1:2, :) = [];

beamNum = {'f11', 'f12', 'f21', 'f22', 'f31', 'f32'};
proj1 = projcrs(3031);

%数据加载与处理
for i =130: height(folderPath)
    pathData = load(strcat('F:\Totten\Matrix_reset\Descending\', folderPath(i).name));
    pathData = pathData.dataAll;


    % 按照波束分别处理数据
    for j = 1: 6
        beamFieldName = beamNum{j};
        resultLS = [];resultIGG = [];
        % 创建空cell保存单个波束数据
        beamData = cell(length(pathData),1);
        for k = 1: length(pathData)
            beamingData = pathData(k).(beamFieldName); % 使用动态字段名访问

            % 数据重新存储的过程中把距离换了
            [beamingData(:,1), beamingData(:,2)] = projfwd(proj1, beamingData(:,1), beamingData(:,2));       
            beamData{k, 1} = beamingData(:, 1:4);
            heightMax(k, 1) = height(beamingData);

        end

        shortCell = cellfun(@(x) numel(x)<10, beamData);
        beamData(shortCell) = [];
        heightMax(shortCell) = [];

        % 获取最大数据所在位置
        [numMax, indexMax] = max(heightMax);

        % 设置参考轨道和重复轨道
        orbitRef = cell2mat(beamData(indexMax, 1)); % 参考轨道
        beamData(indexMax) = [];                    % 重复轨道

        % 参考轨道的经纬度和时间
        xCal = orbitRef(:, 1);
        yCal = orbitRef(:, 2);
        elevationCal = orbitRef(:, 3);
        timeCal = orbitRef(:, 4);
        distCal = zeros(size(xCal));

        xRef = orbitRef(:, 1);
        yRef = orbitRef(:, 2);
        elevationRef = orbitRef(:, 3);
        timeRef = orbitRef(:, 4);

        % 重复轨道遍历一遍
        for sizeBeamOrbit = 1: height(beamData)
            orbitRep = cell2mat(beamData(sizeBeamOrbit));
            yCal_ = orbitRep(:,2);
            [indexNearPoint, dist] = knnsearch([orbitRep(:,1) orbitRep(:,2)], [xRef yRef], 'K', 2); % 检索所有点？？

            for sizeOrbitRef = 1: height(orbitRef)
                % 删除距离太大的点
                if dist(sizeOrbitRef, 1) > 100 || dist(sizeOrbitRef, 2) > 100
                    xCal(sizeOrbitRef, sizeBeamOrbit + 1) = nan;
                    yCal(sizeOrbitRef, sizeBeamOrbit + 1) = nan;
                    elevationCal(sizeOrbitRef, sizeBeamOrbit + 1) = nan;
                    timeCal(sizeOrbitRef, sizeBeamOrbit + 1) = nan;
                    distCal(sizeOrbitRef, sizeBeamOrbit + 1) = nan;
                    continue
                end
                % 反距离加权
                idx1 = indexNearPoint(sizeOrbitRef, 1);
                idx2 = indexNearPoint(sizeOrbitRef, 2);
                xCal(sizeOrbitRef, sizeBeamOrbit+ 1) = xCal(sizeOrbitRef, 1);
                yCal(sizeOrbitRef, sizeBeamOrbit+ 1) = inverseDistanceWeighting([orbitRep(idx1, 1),orbitRep(idx2, 1)], [orbitRep(idx1, 2),orbitRep(idx2, 2)], xCal(sizeOrbitRef, 1), 1);
                elevationCal(sizeOrbitRef, sizeBeamOrbit+ 1) = inverseDistanceWeighting([orbitRep(idx1, 1),orbitRep(idx2, 1)], [orbitRep(idx1, 3),orbitRep(idx2, 3)], xCal(sizeOrbitRef, 1), 1);
                timeCal(sizeOrbitRef, sizeBeamOrbit+ 1) = inverseDistanceWeighting([orbitRep(idx1, 1),orbitRep(idx2, 1)], [orbitRep(idx1, 4),orbitRep(idx2, 4)], xCal(sizeOrbitRef, 1), 1);
                distCal(sizeOrbitRef, sizeBeamOrbit+ 1) = yCal(sizeOrbitRef, sizeBeamOrbit+ 1) - yCal(sizeOrbitRef, 1);
            end
        end

        % 获得所有轨道结果，进行解算
        for sizeOrbitRef = 1: height(orbitRef)
            tYear = timeCal(sizeOrbitRef, :)./31557600 - 1;
            MatrixCal = [ones(1, length(tYear)); tYear; sin(2*pi*tYear); cos(2*pi*tYear); distCal(sizeOrbitRef, :)];
            MatrixElevation = elevationCal(sizeOrbitRef, :);

            % 删除不足起算的数据
            subMatrix = MatrixCal(2:5, :);
            columnsWithAllNaN = all(isnan(subMatrix), 1);
            numColumnsWithAllNaN = sum(columnsWithAllNaN);
            if width(tYear)-numColumnsWithAllNaN < 7
                continue
            end
            MatrixCal(:, columnsWithAllNaN) = [];
            elevation = elevationCal(sizeOrbitRef, :);
            elevation(:, columnsWithAllNaN) = [];
            [vResultLS, vResultIGG] = IGG3Estimation(MatrixCal, elevation);
            resultLS(sizeOrbitRef, 3:8) = vResultLS';
            resultLS(sizeOrbitRef, 1:2) = orbitRef(sizeOrbitRef, 1:2);
            resultIGG(sizeOrbitRef, 3:8) = vResultIGG';
            resultIGG(sizeOrbitRef, 1:2) = orbitRef(sizeOrbitRef, 1:2);
        end
        % 一个波束计算完毕，按照波束进行保存

        savePathLS = strcat('F:\Totten\result\LS\Descending\',beamNum(j), '\',folderPath(i).name);
        save(string(savePathLS), 'resultLS');
        savePathIGG = strcat('F:\Totten\result\IGG\Descending\',beamNum(j), '\',folderPath(i).name);
        save(string(savePathIGG), 'resultIGG');
    end
end
toc;