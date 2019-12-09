% addpath('../../3/');
addpath('../../sensingMatrixFunctions/');


img = imread("twitter_cards_potus.jpg");
gray = rgb2gray(img);

% block 80% of image

[nRow, nCol] = size(gray);

y = gray;
y(round(nRow*0.1):nRow, :) = 0;
transposedY = transpose(y);
% flattenedY shape: N * 1
flattenedY = transposedY(:);
% check tanslation correct:
% transpose(flattenedY(1:100)) == gray(1, 1:100)
yNonZero = flattenedY ~= 0;
yHat = flattenedY(yNonZero);
[m, ~] = size(yHat);
N = nRow * nCol;


A = generateRandomGaussianOrthonormalizedMatrix(m, N);
pinvA = pinv(A);
xHat = pinvA*double(yHat);
% gray range: 0 ~ 250
% xHat range: -150 ~ +150
zeroed = xHat + abs(min(xHat));
normalized = zeroed / max(zeroed);
scaled = round(normalized * 255);


figure(1)
imshow(gray);
title("original");

figure(2)
imshow(y);
title("covered");

figure(3)
imshow(uint8(reshape(scaled, nRow, nCol)));
title("recovered");

figure(4)
imshow(uint8(transpose(reshape(scaled, nRow, nCol))));
title("recovered transposed");
