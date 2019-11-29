% x = R^256, 10-sparse
N = 256;
S = 10;
epsilon = 10e-6;



x = zeros(N, 1);
q = randperm(N);
x(q(1:S))=randn(S, 1);

