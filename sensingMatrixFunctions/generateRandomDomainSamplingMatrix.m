% Sampling in a random domain
% the sensing matrix A (m x n) is generated from a collection
% of random gaussian variables, then the rows are orthonormalized
% A = randn(M, N); A = orth(A')';

function [A] = generateRandomDomainSamplingMatrix(m, n)
    A = randn(m, n);
    A = orth(A')';
end



