%% create gif from .tiff image files

imageFolder = "./tempFigures";
outputFolder = "./tempFigures";
gifFile = "offset_errorMap.gif";
for idx = 1:41
    imgName = sprintf("offset_%02d_errorMap.tiff",(idx-1)*2);
    img = imread(fullfile(imageFolder,imgName));
    [Q,map] = rgb2ind(img,256);
    if idx == 1
        imwrite(Q,map,fullfile(outputFolder,gifFile),'DelayTime',0.2,'LoopCount',inf);
    else
        imwrite(Q,map,fullfile(outputFolder,gifFile),'DelayTime',0.2,'WriteMode','append');
    end
end