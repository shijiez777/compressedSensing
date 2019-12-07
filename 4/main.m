addpath('../sparseSignalGenerations/');
addpath('../l1minimization/');
addpath('../helpers/');

% M = 50;

% x = generateTimeSparseSignal(N, sparsity);
% 
% 
% psi = eye(N);
% phi = generateFreqDomainRandomSensingMatrix(M, N);
% A = phi * psi;
% y = A* x;
% 
% 
% [x_hat, Z] = standardLP(N, A, y);
% sum(x_hat ~= 0)

N = 256;
sparsity = 10;
epsilon = 10e-6;

iterations = 100;
Ms = [20 30 40 50 60 70 80 90 100];

signalCase = 'freq-sparse';
algorithm = 'standardLP';

sensingMatrixCases = ["time-random", "time-uniform subsampling", "freq-random", "low-frequency sampling", "equispaced frequency sampling", "gaussian"];

experimentWrapperandDrawer(signalCase, sensingMatrixCases, algorithm, iterations, Ms, N, sparsity, epsilon);


