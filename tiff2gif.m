%% create gif from .tiff image files

imageFolder = "./tempFigures";
outputFolder = "./tempFigures";
gifFile = "sigmoidResult_DRPcheck.gif";
for idx = 1:9
    imgName = sprintf("sigmoid_func_%02d_DRPcheck.tiff",idx);
    img = imread(fullfile(imageFolder,imgName));
    [Q,map] = rgb2ind(img,256);
    if idx == 1
        imwrite(Q,map,fullfile(outputFolder,gifFile),'DelayTime',0.2,'LoopCount',inf);
    else
        imwrite(Q,map,fullfile(outputFolder,gifFile),'DelayTime',0.2,'WriteMode','append');
    end
end