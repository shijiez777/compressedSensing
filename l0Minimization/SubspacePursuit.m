% function [residues, x_hat, itera] = OrthogonalMatchingPursuit(phi, psi, y, sparsity, epsilon)




function [residues, x_hat, itera] = SubspacePursuit(phi, psi, y, sparsity, epsilon)
    % find best x_hat, such that minimizes ||(A* x_hat - y)||_2 < epsilon
    
    A = phi * psi;


    [~, xLen] = size(A);
    residue_prev = y;
    residue_new = residue_prev;
    S = [];

    ATranspose = A';
    itera = 0;
    residues = [];
    
    while true
        S_prev = S;
        x_hat = zeros(xLen, 1);

        itera = itera + 1;
        residue_prev = residue_new;

        % set the columns from A, that gives the argmax of residue*A to be
        % 0, so that the new argmax cannot choose previously chosen n.
        % Because it is calculating the covariance.
        ATransposeTemp = ATranspose;
        ATransposeTemp(S, :) = 0;
        
        
        % find new set of candidates that maximizes the covariance
        [~ ,ciIndeces] = maxk(abs(ATransposeTemp * residue_prev), 5);
        % add new candidate indeces to S set
        S = [S, ciIndeces];
        S = S(:);
        % pruning for the new best S set
        temp = zeros(size(A));
        temp(:, S) = A(:, S);
        ADaggerS = pinv(temp);        
        tmp = ADaggerS*y;
        [~ ,x_hatIndex] = maxk(abs(tmp), sparsity);
        S = x_hatIndex;
        S = S(:);
        x_hat(x_hatIndex, 1) = tmp(x_hatIndex, 1);        
        residue_new = y - A*x_hat;
        residues = [residues, norm(residue_new, 2)];
        
         if (size(S_prev) == size(S)) & (S_prev == S)
             % sprintf("S set not changing, terminating. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat ~= 0))
             break
         end
         if norm(residue_new, 2) >= norm(residue_prev, 2)
              % sprintf("Residue not decreasing, terminating. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat ~= 0))
              break
         end
    end
end