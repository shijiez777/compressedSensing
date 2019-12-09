% corrupt image by certain percentage of pixels using uniform distribution,
% and corrupt the values of the pixel using values drawn from uniform
% distribution
% takes as input GRAYSCALE IMG WITHIN RANGE 0 - 1.
function corruptedImg = uniformCorrupt(img, ratio)
    corruptFlag = rand(size(img)) < ratio;
    corruptValue = rand(size(img));
    corruptedImg = img;
    corruptedImg(corruptFlag) = corruptValue(corruptFlag);
end