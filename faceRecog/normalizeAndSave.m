datadir = "/home/fatken/data/CompressedSensing/CroppedYale/";

classes = dir(fullfile(datadir, 'yale*'));
classes = {classes.name};
photoNames = {dir(fullfile(datadir + classes(1), '*.pgm')).name};
% get rid of the ambient photo
photoNames(contains(photoNames,'Ambient')) = [];
img = imread(datadir + classes(1) +'/' + photoNames(10));
[imgH, imgW] = size(img);

c = containers.Map;
classes = dir(fullfile(datadir, 'yale*'));
classes = {classes.name};
for i = 1:length(classes)
    class = classes(i);
    photoNames = {dir(fullfile(datadir + class, '*.pgm')).name};
    % get rid of the ambient photo
    photoNames(contains(photoNames,'Ambient')) = [];
    tmpMatrix = zeros(64, imgH*imgW);
    for j = 1:length(photoNames)
        img = imread(datadir + class +'/' + photoNames(j));
        img = img(:);
        img = double(img)/255;
        tmpMatrix(j, :) = img;
    end
    c(char(class)) = tmpMatrix;
end

save("/home/fatken/data/CompressedSensing/CroppedYaleProcessed/data.mat", "c");

