
% Uniform subsampling in the time domain
% the sensing matrix A is constructed by selecting M rows of I whose row
% indices are in the uniformly-spaced set at location
% %{1*[n/m], 2*[n/m], 3*[n/m], ... , m*[n/m]}

function [A] = generateTimeDomainUniformSubsamplingMatrix(m, n)
    I = eye(n);
    stepSize = floor(n/m);
    indices = zeros(m, 1);

    for i = 1:m
        indices(i, 1) = stepSize * i;
    end
    A = I(indices, :);
end
