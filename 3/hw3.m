% X: 256 * 1
% 5-sparse, S = 5
% generated a sparse signal, of sparsity 5, 
% randomly choose 5 indexes using randperm, and assign the 5 random indeces
% with value randn(5, 1)

% load("../ps2/ps2_2018.mat")

% N = 256;
% S = 5;
% x = zeros(N, 1);
% q = randperm(N);
% x(q(1:S)) = randn(S, 1);
% epsilon = 10e-10;
% M = 50;
% sparsity = 5;
% 
% 
% A = generateTimeDomainSensingMatrix(M, N);
% B = generateFreqDomainSensingMatrix(M, N);
% C = generateRandomGaussianOrthonormalizedMatrix(M, N);
% % 
% y = A * x;
% % 
% [perfect_recovery, residues,x_hat] = OrthogonalMatchingPursuit(A, y, sparsity, epsilon);


% optimization algorithms: 'OMP', 'SP'
% signal cases: 'time-sparse', 'freq-sparse'
% signalCase = 'time-sparse';


% M = 50;
% x = generateFrequencySparseSignal(N, sparsity);            
% A = generateTimeDomainSensingMatrix(M, N);
% sparsity = 1000;
% 
% [perfect_recovery, residues, x_hat, itera] = OrthogonalMatchingPursuit(A, x, sparsity, epsilon);
% 


% perfectRecoveryRatios
% [perfectRecoveryRatios, avgIterations] = runExperiment(signalCase, sensingMatrixCase, algorithm, iterations, Ms, N, sparsity, epsilon);
% disp(perfectRecoveryRatios)
% disp(avgIterations)


% sensing matrix cases: 'time-random', 'freq-random', 'gaussian'
sensingMatrixCase = 'time-random';
iterations = 50;
Ms = [10, 20, 30, 40, 50];
N = 256;
sparsity = 5;
epsilon = 10e-10;

signalCase = 'time-sparse';
algorithm = 'SP';

sensingMatrixCases = ["time-random"; "freq-random"; "gaussian"];
experimentWrapper(signalCase, sensingMatrixCases, algorithm, iterations, Ms, N, sparsity, epsilon);