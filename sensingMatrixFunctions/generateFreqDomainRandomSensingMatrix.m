% (Random sampling in the frequency domain: Suppose F is the N by N DCT matrix 
% (F = dct(eye(N));). Create the sensing matrix A by keeping M rows of F at random locations
% (and deleting the remaining M-N rows). ?
function [A] = generateFreqDomainRandomSensingMatrix(m, n)
    F = dct(eye(n));
    randIndeces = randperm(n);
    A = F(randIndeces(1:m), :);
end