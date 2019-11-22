% Sampling with a random matrix: The sensing matrix A is M by N in this case 
% and is generated from a collection of random Gaussian variables, 
% then the rows are orthonor- malized, i.e.,
% A = randn(M, N); A = orth(A?)?
function [A] = generateRandomGaussianOrthonormalizedMatrix(m, n)
    A = randn(m, n);
    A = orth(A')';
end