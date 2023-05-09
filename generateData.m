function dataNorm = generateData(dataRaw, dataBG, posInfo, options)
    arguments
        dataRaw
        dataBG
        posInfo
        options.offset (1,1) double = 40
        options.gain (1,1) double = 20
    end
    
    pos_x = sort(unique(dataRaw.x),"ascend");
    pos_y = sort(unique(dataRaw.y),"ascend");
    [xx, yy] = meshgrid(pos_x, pos_y);
    num_x = numel(pos_x);
    num_y = numel(pos_y);
    num_pixel = size(dataRaw.drplist,2);
    
    dataNorm.drpMap = nan(num_x, num_y, num_pixel);
    for idx = 1:length(dataRaw.x)
        x_temp = dataRaw.x(idx);
        y_temp = dataRaw.y(idx);
        dataNorm.drpMap(pos_x == x_temp, pos_y == y_temp, :) = ...
            dataRaw.drplist(idx, :) - dataBG.drp;
    end
    
    dataNorm.x = reshape(xx, [], 1);
    dataNorm.y = reshape(yy, [], 1);
    dataNorm.num_x = num_x;
    dataNorm.num_y = num_y;
    dataNorm.num_pixel = num_pixel;
    
    dataNorm.drplist = reshape(dataNorm.drpMap, [], num_pixel);
    dataNorm.drplist = (dataNorm.drplist + options.offset) * options.gain;
    dataNorm.drplist(dataNorm.drplist < 0) = 0;
    dataNorm.drplist = dataNorm.drplist / prctile(dataNorm.drplist,95,"all");
    dataNorm.drplist(dataNorm.drplist > 1) = 1;
    dataNorm.drpMap = reshape(dataNorm.drplist,num_x,num_y,num_pixel);
    dataNorm.posInfo = posInfo;

    plotPara = calcPlotPixels(posInfo,resNum=20);
    dataNorm.plotPara = plotPara;

    fprintf("Dataset is reday for further processing!\n");
end