% time-sparse signal generation function
function x = generateTimeSparseSignal(N, sparsity)
    x = zeros(N, 1);
    q = randperm(N);
    x(q(1:sparsity)) = randn(sparsity, 1);
end