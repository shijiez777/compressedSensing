function [perfect_recovery, residues, x_hat, itera] = OrthogonalMatchingPursuit(A, x, sparsity, epsilon)
    % find best x_hat, such that minimizes ||(A* x_hat - y)||_2 < epsilon
    y = A * x;
    
    [~, xLen] = size(A);
    x_hat = zeros(xLen, 1);
    residue_prev = y;
    residue_new = residue_prev;
    S = [];
    ATranspose = A';
    itera = 0;
    residues = [];
    perfect_recovery = 0;
    
    while itera < sparsity
        itera = itera + 1;
        residue_prev = residue_new;
        % sprintf("residue_new: %f, residue_prev: %f\n", norm(residue_new, 2), norm(residue_prev, 2))

        % set the columns from A, that gives the argmax of residue*A to be
        % 0, so that the new argmax cannot choose previously chosen n.
        % Because it is calculating the covariance.
        ATranspose(S, :) = 0;
        [~ ,n] = max(abs(ATranspose * residue_prev));
        S = [S, n];
        temp = zeros(size(A));
        temp(:, S) = A(:, S);
        ADaggerS = pinv(temp);
        
        x_hat = ADaggerS*y;
        residue_new = y - A*x_hat;

        residues = [residues, norm(residue_new, 2)];
        
        % sprintf("residue_new: %f, residue_prev: %f\n", norm(residue_new, 2), norm(residue_prev, 2))

         if norm(residue_new, 2) >= norm(residue_prev, 2)
             % sprintf("Residue not decreasing, terminating. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat ~= 0))
             break
         end
        if norm((x - x_hat), 2) < epsilon
            % sprintf("Residue smaller than epsilon, PERFECT RECOVERY, terminating.. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat~= 0))
            perfect_recovery = 1;
            break
        end
    end
end