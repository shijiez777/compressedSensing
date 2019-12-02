function [perfectRecoveryRatios, avgIterations] = runExperiment(signalCase, sensingMatrixCase, algorithm, iterations, Ms, N, sparsity, epsilon)
    perfectRecoveryCounts = zeros(length(Ms), 1);
    perfectRecoveryTotalIterations = zeros(length(Ms), 1);

    switch signalCase
        % psi: sparsifying dictionary
        case 'time-sparse' 
            sigGenFun = @generateTimeSparseSignal;
            psi = eye(N);
            freqSparseFlag = 0;
        case 'freq-sparse'
            sigGenFun = @generateFrequencySparseSignal;
            psi = inv(dctmtx(N));
            freqSparseFlag = 1;
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
            % sensing matrix
            phi = sensingMatGenFun(M, N);
            x = sigGenFun(N, sparsity);
            
            %% y = phi * x NO MATTER if x is time or frequency sparse!!!
            y = phi * x;
            
            [~, x_hat, itera] = optiAlgo(phi, psi, y, sparsity, epsilon, freqSparseFlag);

            disp(norm((x - x_hat), 2))
            disp(norm((x - x_hat), 2) < epsilon)
            if norm((x - x_hat), 2) < epsilon
                perfectRecoveryCounts(Midx) = perfectRecoveryCounts(Midx) + 1;
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