%% load raw data and generate dataNorm for post-processing
[dataRaw, dataBG, posInfo] = loadRawData(...
    AlNew, AlNewBG, pixel_coord);

% offset = 80;
[x,y,offset] = rawDataDistribution(dataRaw,dataBG);

dataNorm = generateData(dataRaw, dataBG, posInfo, offset=offset);

%% show some measured DRPs and background DRP
figure(Position=[100 100 800 800])
tiledlayout(4,4,"TileSpacing","compact","padding","compact")
nexttile(1)
plotDRP(dataBG.drp,dataNorm.plotPara,caxis=[min(dataBG.drp),max(dataBG.drp)],colorbar=false)
rand_idx = randi(size(dataNorm.drplist,1),15);
for idx = 1:length(rand_idx)
    nexttile(idx+1)
    plotDRP(dataNorm.drplist(rand_idx(idx),:), dataNorm.plotPara, format="3d",colorbar=false)
end
%% otherwise, you can use 
[drp_selected, x_pos, y_pos] = showSampleDRP(dataNorm, dataNorm.plotPara);

%% create DRP Library and run dictionary indexing
ang_res = 3;
drpLib = createDRPLib(posInfo, ang_res*degree, faceting=[1,1,1], ...
    fitting_para=[1,0.7,25,4,0.8,8]);
%% indexing dataNorm
indexResult = IndexEngine_sDRM(dataNorm, drpLib);
figure, imshow(plot_ipf_map(indexResult.eulerMap),Border="tight")

figure, imshow(indexResult.distanceMap,[min(indexResult.distance),max(indexResult.distance)], ...
    "Border","tight")
colormap(jet)

%% offset value investigation
outputFolder = "/Users/chenyangzhu/Library/CloudStorage/OneDrive-NanyangTechnologicalUniversity/Research-2023/scanningDRM/defocusMethod";
offset_values = 0:2:72;
for ii = 1:length(offset_values)
    offset = offset_values(ii);
    dataNorm = generateData(dataRaw, dataBG, posInfo, offset=offset);
    indexResult = IndexEngine_sDRM(dataNorm,drpLib);

    f1 = figure("name",sprintf("offset value %d ",offset_values(ii)));
    imshow(plot_ipf_map(indexResult.eulerMap),Border="tight")
    print(f1, fullfile(outputFolder,sprintf("err_map_offset_%02d.tif",offset_values(ii))),'-dtiff');
    close(f1)

    f2 = figure("name",sprintf("offset value %d ",offset_values(ii)));
    imshow(indexResult.distanceMap,[min(indexResult.distance),max(indexResult.distance)], ...
        "Border","tight")
    colormap("jet")
    print(f2, fullfile(outputFolder,sprintf("distance_map_offset_%02d.tif",offset_values(ii))),'-dtiff');
    close(f2)
    fprintf("Finishing %02d / %02d offset values.\n",[ii length(offset_values)]);
end

%% function to get offset value
function [x,y,offset] = rawDataDistribution(dataRaw,dataBG)
    pos_x = sort(unique(dataRaw.x),"ascend");
    pos_y = sort(unique(dataRaw.y),"ascend");
    num_x = numel(pos_x);
    num_y = numel(pos_y);
    num_pixel = size(dataRaw.drplist,2);
    
    drpMap = nan(num_x, num_y, num_pixel);
    for idx = 1:length(dataRaw.x)
        x_temp = dataRaw.x(idx);
        y_temp = dataRaw.y(idx);
        drpMap(pos_x == x_temp, pos_y == y_temp, :) = ...
            dataRaw.drplist(idx, :) - dataBG.drp;
    end
    drpList = reshape(drpMap,[],608);
    x = 0:99;
    y = x;
    for ii = 1:length(x)
        y(ii) = prctile(drpList,x(ii),"all");
        workbar(ii/length(x));
    end
    [~,idxpeak] = findpeaks(diff(y),'MinPeakProminence',2);
    offset = -y(idxpeak(end) + 9);
end