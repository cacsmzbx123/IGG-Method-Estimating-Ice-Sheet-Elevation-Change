function [dataall] = h5FileRead(fileName)
%H5FILEREAD 此处显示有关此函数的摘要
%   读取h5文件，依次读取经度、纬度、高程、时间、数据质量、逆气压改正和潮汐改正
gt={'1l' 11;'2l' 21;'3l' 31;'1r' 12;'2r' 22;'3r' 32};
dataall = {};
gtdata = [];
for k=1:6
        try
            lat = h5read(fileName,strcat('/gt',gt{k,1},'/land_ice_segments/latitude'));%获取经度
            lon = h5read(fileName,strcat('/gt',gt{k,1},'/land_ice_segments/longitude'));%获取纬度
            h = double(h5read(fileName,strcat('/gt',gt{k,1},'/land_ice_segments/h_li')));%获取高程
            time = double(h5read(fileName,strcat('/gt',gt{k,1},'/land_ice_segments/delta_time')));%获取时间（交叉点重复轨道都要用）
            quality = h5read(fileName,strcat('/gt',gt{k,1},'/land_ice_segments/atl06_quality_summary'));%轨道的数据质量情况
            gtdata=[double(lat) double(lon) double(h) double(time) double(quality)];

            % 裁切范围
            index_area = (gtdata(:,1) < -65) & (gtdata(:,1) > -77.5) & (gtdata(:,2) < 135) & (gtdata(:,2) > 93);
            gtdata = gtdata(index_area, :);

            % 删除质量差的点（1为质量差，0为质量好）
            dataall{k,1} = gtdata(gtdata(:,5) ~= 1, :);
            dataall{k,2} = gt{k,2};

            % 无数据改正
        catch 
            continue
        end

        %直接进行数据裁切
        
        
        
        end

