% (Random sampling in the frequency domain: Suppose F is the N by N DCT matrix 
% (F = dct(eye(N));). 
% Create the sensing matrix A by keeping FIRST M rows of F
function [A] = generateLowFreqSamplingMatrix(m, n)
    F = dct(eye(n));
    A = F(1:m, :);
end