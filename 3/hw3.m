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

% sensing matrix cases: 'time-random', 'freq-random', 'gaussian'
sensingMatrixCase = 'time-random';
iterations = 50;
Ms = [10, 20, 30, 40, 50];
N = 256;
sparsity = 5;
epsilon = 10e-10;

signalCase = 'freq-sparse';
algorithm = 'SP';

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


sensingMatrixCases = ["time-random"; "freq-random"; "gaussian"];
experimentWrapper(signalCase, sensingMatrixCases, algorithm, iterations, Ms, N, sparsity, epsilon);


function experimentWrapper(signalCase, sensingMatrixCases, algorithm, iterations, Ms, N, sparsity, epsilon)
    perfectRecoveryRecords = zeros(3, 5);
    % perfectRecoveryIterations = zeros(3, 5, 50);
    for i = 1:length(sensingMatrixCases)
        [perfectRecoveryRatios, avgIterations] = runExperiment(signalCase, sensingMatrixCases(i), algorithm, iterations, Ms, N, sparsity, epsilon);
        perfectRecoveryRecords(i, :) = transpose(perfectRecoveryRatios);
        disp(sensingMatrixCases(i) + " avg iterations: " + avgIterations);
    end
    for i = 1:3
        hold on
        plot(Ms, perfectRecoveryRecords(i, :));
        hold off
    end
    title(signalCase + " signal, algorithm: " + algorithm)
    xlabel('M') 
    ylabel('perfect recovery ratio')
    legend(sensingMatrixCases,'Location','southwest') 
    xticks(Ms)
    xticklabels(Ms)

end

% 
function [perfectRecoveryRatios, avgIterations] = runExperiment(signalCase, sensingMatrixCase, algorithm, iterations, Ms, N, sparsity, epsilon)
    perfectRecoveryCounts = zeros(length(Ms), 1);
    perfectRecoveryTotalIterations = zeros(length(Ms), 1);

    switch signalCase
        case 'time-sparse' 
            sigGenFun = @generateTimeSparseSignal;
        case 'freq-sparse'
            sigGenFun = @generateFrequencySparseSignal;
    end
    
    switch sensingMatrixCase
        case 'time-random' 
            sensingMatGenFun = @generateTimeDomainSensingMatrix;
        case 'freq-random'
            sensingMatGenFun = @generateFreqDomainSensingMatrix;
        case 'gaussian'
            sensingMatGenFun = @generateRandomGaussianOrthonormalizedMatrix;
    end

    switch algorithm
        case 'OMP' 
            optiAlgo = @OrthogonalMatchingPursuit;
        case 'SP'
            optiAlgo = @SubspacePursuit;
    end   

    for Midx = 1:length(Ms)
        M = Ms(Midx);
        % disp(M);
        for iter = 1:iterations
            A = sensingMatGenFun(M, N);
            x = sigGenFun(N, sparsity);            
            [perfect_recovery, ~, ~, itera] = optiAlgo(A, x, sparsity, epsilon);

            if perfect_recovery == 1
                perfectRecoveryCounts(Midx) = perfectRecoveryCounts(Midx) + perfect_recovery;
                % disp("perfectRecoveryiterations(Midx): ");
                % disp(perfectRecoveryiterations(Midx));

                % disp("itera: " + itera);
                % tmpLen = length(perfectRecoveryiterations(Midx));
                perfectRecoveryTotalIterations(Midx) = perfectRecoveryTotalIterations(Midx) + itera;
                % perfectRecoveryiterations(Midx, tmpLen+1) = itera;
            end
        end
    end
    
    perfectRecoveryRatios = perfectRecoveryCounts/iterations;
%     disp(perfectRecoveryTotalIterations);
%     disp(perfectRecoveryCounts);

    avgIterations = perfectRecoveryTotalIterations ./ perfectRecoveryCounts;
    % histogram(perfectRecoveryRatios, 5);
    % plot(1:length(Ms), perfectRecoveryRatios);
    
end

function [perfect_recovery, residues, x_hat, itera] = OrthogonalMatchingPursuit(A, x, sparsity, epsilon)
    % find best x_hat, such that minimizes ||(A* x_hat - y)||_2 < epsilon
    y = A * x;
    
    [~, xLen] = size(A);
    x_hat = zeros(xLen, 1);
    residue_prev = y;
    residue_new = residue_prev;
    S = [];
    ATranspose = A';
    itera = 0;
    residues = [];
    perfect_recovery = 0;
    
    while itera < sparsity
        itera = itera + 1;
        residue_prev = residue_new;
        % sprintf("residue_new: %f, residue_prev: %f\n", norm(residue_new, 2), norm(residue_prev, 2))

        % set the columns from A, that gives the argmax of residue*A to be
        % 0, so that the new argmax cannot choose previously chosen n.
        % Because it is calculating the covariance.
        ATranspose(S, :) = 0;
        [~ ,n] = max(abs(ATranspose * residue_prev));
        S = [S, n];
        temp = zeros(size(A));
        temp(:, S) = A(:, S);
        ADaggerS = pinv(temp);
        
        x_hat = ADaggerS*y;
        residue_new = y - A*x_hat;

        residues = [residues, norm(residue_new, 2)];
        
        % sprintf("residue_new: %f, residue_prev: %f\n", norm(residue_new, 2), norm(residue_prev, 2))

         if norm(residue_new, 2) >= norm(residue_prev, 2)
             % sprintf("Residue not decreasing, terminating. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat ~= 0))
             break
         end
        if norm((x - x_hat), 2) < epsilon
            % sprintf("Residue smaller than epsilon, PERFECT RECOVERY, terminating.. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat~= 0))
            perfect_recovery = 1;
            break
        end
    end
end



function [perfect_recovery, residues, x_hat, itera] = SubspacePursuit(A, x, sparsity, epsilon)
    % find best x_hat, such that minimizes ||(A* x_hat - y)||_2 < epsilon
    y = A * x;

    [~, xLen] = size(A);
    residue_prev = y;
    residue_new = residue_prev;
    S = [];

    ATranspose = A';
    itera = 0;
    residues = [];
    perfect_recovery = 0;
    
    while true
        S_prev = S;
        x_hat = zeros(xLen, 1);

        itera = itera + 1;
        residue_prev = residue_new;
        % sprintf("residue_new: %f, residue_prev: %f\n", norm(residue_new, 2), norm(residue_prev, 2))

        % set the columns from A, that gives the argmax of residue*A to be
        % 0, so that the new argmax cannot choose previously chosen n.
        % Because it is calculating the covariance.
        ATransposeTemp = ATranspose;
        ATransposeTemp(S, :) = 0;
        
        
        % find new set of candidates that maximizes the covariance
        [ci ,ciIndeces] = maxk(abs(ATransposeTemp * residue_prev), 5);
        % add new candidate indeces to S set
        S = [S, ciIndeces];
        S = S(:);
        % disp("added S: ")
        % disp(S);
        % pruning for the new best S set
        temp = zeros(size(A));
        temp(:, S) = A(:, S);
        ADaggerS = pinv(temp);        
        tmp = ADaggerS*y;
        [~ ,x_hatIndex] = maxk(abs(tmp), sparsity);
        S = x_hatIndex;
        S = S(:);
        % disp("updated S: ")
        % disp(S);
        x_hat(x_hatIndex, 1) = tmp(x_hatIndex, 1);        
        residue_new = y - A*x_hat;
        residues = [residues, norm(residue_new, 2)];
        
        % sprintf("residue_new: %f, residue_prev: %f\n", norm(residue_new, 2), norm(residue_prev, 2))

         if (size(S_prev) == size(S)) & (S_prev == S)
             % sprintf("S set not changing, terminating. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat ~= 0))
             break
         end
         if norm(residue_new, 2) >= norm(residue_prev, 2)
              % sprintf("Residue not decreasing, terminating. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat ~= 0))
              break
          end
        if norm((x - x_hat), 2) < epsilon
            % sprintf("Residue smaller than epsilon, PERFECT RECOVERY, terminating.. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat~= 0))
            perfect_recovery = 1;
            break
        end
    end
end

% time-sparse signal generation function
function x = generateTimeSparseSignal(N, sparsity)
    x = zeros(N, 1);
    q = randperm(N);
    x(q(1:sparsity)) = randn(sparsity, 1);
end

% frequency-sparse signal generation function
function x = generateFrequencySparseSignal(N, sparsity)
    alpha = zeros(N, 1);
    q = randperm(N);
    alpha(q(1:sparsity)) = randn(sparsity, 1);
    x = idct(alpha);
end

% Random sampling in the time domain: Suppose I is the N by N identity matrix. 
% Create the sensing matrix A by keeping M rows of I at random locations 
% (and deleting the remaining M ? N rows). ?
function [A] = generateTimeDomainSensingMatrix(m, n)
    I = eye(n);
    randIndeces = randperm(n);
    A = I(randIndeces(1:m), :);
end

% (Random sampling in the frequency domain: Suppose F is the N by N DCT matrix 
% (F = dct(eye(N));). Create the sensing matrix A by keeping M rows of F at random locations
% (and deleting the remaining M-N rows). ?
function [A] = generateFreqDomainSensingMatrix(m, n)
    F = dct(eye(n));
    randIndeces = randperm(n);
    A = F(randIndeces(1:m), :);
end

% Sampling with a random matrix: The sensing matrix A is M by N in this case 
% and is generated from a collection of random Gaussian variables, 
% then the rows are orthonor- malized, i.e.,
% A = randn(M, N); A = orth(A?)?
function [A] = generateRandomGaussianOrthonormalizedMatrix(m, n)
    A = randn(m, n);
    A = orth(A')';
end