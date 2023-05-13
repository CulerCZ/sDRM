%% load raw data and generate dataNorm for post-processing
[dataRaw, dataBG, posInfo] = loadRawData(...
    AlEJMdefocusRaw20230425125522, AlEJMdefocusBG20230425125522, pixel_coord);

offset = 15;

dataNorm = generateData(dataRaw, dataBG, posInfo, offset=offset);

%% show some measured DRPs and background DRP
figure(Position=[100 100 800 800])
tiledlayout(4,4,"TileSpacing","compact","padding","compact")
nexttile(1)
plotDRP(dataBG.drp,dataNorm.plotPara,caxis=[min(dataBG.drp),max(dataBG.drp)],colorbar=true)
rand_idx = randi(size(dataNorm.drplist,1),15);
for idx = 1:length(rand_idx)
    nexttile(idx+1)
    plotDRP(dataNorm_1.drplist(rand_idx(idx),:), dataNorm.plotPara, format="3d",colorbar=false)
end
%% otherwise, you can use 
[drp_selected, x_pos, y_pos] = showSampleDRP(dataNorm_1, dataNorm_1.plotPara);

%% create DRP Library and run dictionary indexing
ang_res = 3;
drpLib = createDRPLib(posInfo, ang_res*degree, faceting=[1,0,0], ...
    fitting_para=[1,0.7,25,4,0.8,8]);
%% indexing dataNorm
indexResult = IndexEngine_sDRM(dataNorm, drpLib);
figure, imshow(indexResult.distanceMap,[min(indexResult.distance),max(indexResult.distance)], ...
    "Border","tight")
colormap(jet)
figure, imshow(plot_ipf_map(indexResult.eulerMap),Border="tight")

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