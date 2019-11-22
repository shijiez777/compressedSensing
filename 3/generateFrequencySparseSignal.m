% frequency-sparse signal generation function
function x = generateFrequencySparseSignal(N, sparsity)
    alpha = zeros(N, 1);
    q = randperm(N);
    alpha(q(1:sparsity)) = randn(sparsity, 1);
    x = idct(alpha);
end