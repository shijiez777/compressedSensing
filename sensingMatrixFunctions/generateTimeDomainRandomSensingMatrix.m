% Random sampling in the time domain: Suppose I is the N by N identity matrix. 
% Create the sensing matrix A by keeping M rows of I at random locations 
% (and deleting the remaining M ? N rows). ?
function [A] = generateTimeDomainRandomSensingMatrix(m, n)
    I = eye(n);
    randIndeces = randperm(n);
    A = I(randIndeces(1:m), :);
end