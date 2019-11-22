addpath('../../3/');

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


% A = generateRandomGaussianOrthonormalizedMatrix(m, N);
% xHat = pinv(A)*yHat;