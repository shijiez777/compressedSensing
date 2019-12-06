function [perfectRecoveryRatios, avgIterations] = runExperiment(signalCase, sensingMatrixCase, algorithm, iterations, Ms, N, sparsity, epsilon)
    perfectRecoveryCounts = zeros(length(Ms), 1);
    perfectRecoveryTotalIterations = zeros(length(Ms), 1);

    switch signalCase
        % psi: sparsifying dictionary
        case 'time-sparse' 
            sigGenFun = @generateTimeSparseSignal;
            psi = eye(N);
            % psiInv = inv(psi);
        case 'freq-sparse'
            sigGenFun = @generateFrequencySparseSignal;
            %% DCT: time domain to freq domain
            psi = inv(dctmtx(N));
            % psiInv = inv(psi);

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
        for iter = 1:iterations
            % sensing matrix
            phi = sensingMatGenFun(M, N);
            x = sigGenFun(N, sparsity);
            
            %% y = phi * x NO MATTER if x is time or frequency sparse!!!
            y = phi * x;
            
            [~, x_hat, itera] = optiAlgo(phi, psi, y, sparsity, epsilon);
            
            %% converts time-sparse x_hat back to original domain
            % A = (m x n)
            % dct(A) = dctmtx(m) * A
            % idct(A) = inv(dctmtx(m)) * A
            %% why following line doesnt work???    
            % x_hat = psiInv * x_hat;

            if signalCase == "freq-sparse"
                x_hat = idct(x_hat);

            end
            
            if norm((x - x_hat), 2) < epsilon
                perfectRecoveryCounts(Midx) = perfectRecoveryCounts(Midx) + 1;
                perfectRecoveryTotalIterations(Midx) = perfectRecoveryTotalIterations(Midx) + itera;
            end
        end
    end
    
    perfectRecoveryRatios = perfectRecoveryCounts/iterations;

    avgIterations = perfectRecoveryTotalIterations ./ perfectRecoveryCounts;
end