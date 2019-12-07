function experimentWrapperandDrawer(signalCase, sensingMatrixCases, algorithm, iterations, Ms, N, sparsity, epsilon)
    perfectRecoveryRecords = zeros(length(sensingMatrixCases), length(Ms));
    % perfectRecoveryIterations = zeros(3, 5, 50);
    for i = 1:length(sensingMatrixCases)
        [perfectRecoveryRatios, ~] = runExperiment(signalCase, sensingMatrixCases(i), algorithm, iterations, Ms, N, sparsity, epsilon);
        perfectRecoveryRecords(i, :) = transpose(perfectRecoveryRatios);
        % disp(sensingMatrixCases(i) + " avg iterations: " + avgIterations);
    end
    for i = 1:length(sensingMatrixCases)
        hold on
        plot(Ms, perfectRecoveryRecords(i, :));
        hold off
    end
    title(signalCase + " signal, algorithm: " + algorithm)
    xlabel('M') 
    ylabel('perfect recovery ratio')
    legend(sensingMatrixCases,'Location','northwest') 
    xticks(Ms)
    xticklabels(Ms)

end