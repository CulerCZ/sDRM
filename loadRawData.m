function [dataRaw, dataBG, posInfo] = loadRawData(...
    datasetRaw, datasetBG, pixel_coord)
% OUTPUTS are:
% dataRaw with (1) position x; (2) position y; (3) corresponding DRP lists
% dataBG with (1) offset; (2) gain; (3) background DRP list
% posInfo with (1) azimuth angle phi; (2) polar angle theta
    dataRaw.x = datasetRaw(:,1);
    dataRaw.y = datasetRaw(:,2);
    dataRaw.drplist = datasetRaw(:,3:end);
    dataBG.offset = datasetBG(1);
    dataBG.gain = datasetBG(2);
    dataBG.drp = datasetBG(3:end);
    posInfo.theta = pixel_coord(2,:);
    posInfo.phi = pixel_coord(1,:);
    posInfo.phi(posInfo.theta<=70) = rem(270-posInfo.phi(posInfo.theta<=70)+360, 360);  % under current settings
    posInfo.phi(posInfo.theta>70) = rem(-90+posInfo.phi(posInfo.theta>70)+360,360);
    fprintf("Raw dataset is loaded!\n");
end