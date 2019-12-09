% this is the wrapper for solving l1 minimization with standard LP
% using linprog.
% problem: 
% min||x||1
% subject to y = Ax
% standard LP:
% Z = [u; v]
% B = [A -A]
% now ||x||1 = 1^T u + 1^T v
% min 1^T z subject to Bz = y,z >= 0.
% f = (1*u + 1 *v), 2*n ones.

% [~, x_hat, itera] = optiAlgo(phi, psi, y, sparsity, epsilon);


function [residues, x_hat, itera] = standardLP(phi, psi, y, ~, ~)
    A = phi * psi;
    [~, N] = size(A);
    f = ones(N*2, 1);
    ineqConsLeft = [];
    ineqConsRight = [];
    Aeq = [A -A];
    beq = y;
    lb = zeros(1, N*2);
    ub = [];
    
%     options = optimset('linprog');
%     options.Display = 'off';
%     
    options = optimoptions('linprog','Display','none');
        
    [X, ~] = linprog(f, ineqConsLeft, ineqConsRight, Aeq, beq, lb, ub, options); %
    x_hat = X(1:N, :) - X(N+1:N*2, :);
    residues = [];
    itera = inf;
end

