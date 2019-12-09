% corrupt image by oclluting certain percentage of pixels in a shape of box
% randomly choose location of occlusion using uniform distribution.
% takes as input GRAYSCALE IMG WITHIN RANGE 0 - 1.
function corruptedImg = ocllusionCorrput(img, ratio)
    corruptedImg = img;
    [h, w] = size(img);
    coverArea = h*w*ratio;
    repeatFlag = true;
    while repeatFlag
        ys = randperm(h, 2);
        y1 = min(ys);
        y2 = max(ys);
        height = y2 - y1;
        x1 = randperm(w, 1);
        width = int16(coverArea / height);
        x2 = x1 + width;
        if x2 < w
            repeatFlag = false;
        end
    end
    corruptedImg(y1:y2, x1:x2) = 0;
end