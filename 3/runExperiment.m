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