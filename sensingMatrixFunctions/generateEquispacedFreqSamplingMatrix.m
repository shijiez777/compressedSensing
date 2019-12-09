% Equispaced frequency sampling
% Generate the sensing matrix A by keeping M rows
% of the matrix at location
%{1*[n/m], 2*[n/m], 3*[n/m], ... , m*[n/m]}
% Similar to time domain uniform subsampling matrix
function [A] = generateEquispacedFreqSamplingMatrix(m, n)
    F = dct(eye(n));
    
    
    stepSize = floor(n/m);
    indices = zeros(m, 1);
    for i = 1:m
        indices(i, 1) = stepSize * i;
    end
    A = F(indices, :);
end
