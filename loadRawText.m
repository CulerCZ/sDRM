% function to load raw scanning DRM dataset from .txt file
function dataRaw = loadRawText()
    
    [filename, path] = uigetfile('*.txt', 'Select a text file');
    dataFileName = fullfile(path, filename);
    
    dataRaw = load(dataFileName);
    fprintf("Dataset load successfully from %s!\n",filename);
end