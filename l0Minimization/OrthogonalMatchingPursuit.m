
% function [residues, x_hat, itera] = OrthogonalMatchingPursuit(phi, psi, y, sparsity, epsilon, freqSparseFlag)

function [residues, x_hat, itera] = OrthogonalMatchingPursuit(phi, psi, y, sparsity, epsilon)
    % find best x_hat, that:
    % 1. minimizes ||(A* x_hat - y)||_2 < epsilon
    % 2. or when residue = y - A*x_hat stops decreasing
    % iteration equals sparsity
    A = phi * psi;

    [~, N] = size(phi);
    x_hat = zeros(N, 1);
    residue_prev = y;
    residue_new = residue_prev;
    S = [];
    itera = 0;
    residues = [];
    % (AB)^{−1}=B^{−1}A^{−1},
    % Ainv = inv(psi) * pinv(phi);
    ATranspose = A';

    
    while itera < sparsity
        % fprintf("itera: %d\n", itera)
        itera = itera + 1;
        residue_prev = residue_new;

        % set the columns from A, that gives the argmax of residue*A to be
        % 0, so that the new argmax cannot choose previously chosen n.
        % Because it is calculating the covariance.
        % ATranspose(S, :) = 0;
        

        % tmpPsiInvPhiInvProduct = psiInvPhiInvProduct;
        % tmpPsiInvPhiInvProduct(S, :) = 0;
        ATranspose(S, :) = 0;

        [~ ,n] = max(abs(ATranspose * residue_prev));
        S = [S, n];
        
        temp = zeros(size(A));
        temp(:, S) = A(:, S);
        ADaggerS = pinv(temp);
        
        % ADaggerS = zeros(size(ATranspose));
        % ADaggerS(S, :) = Ainv(S, :);

        x_hat = ADaggerS*y;
        % if the signal is frequency sparse, we need to convert the
        % time-sparse result back to frequency sparse.
        
        % dct converts FREQUENCY sparse signal to TIME SPARSE signal
        % psi = inv(dctmtx(N));
        % A = phi * psi
        % x_hat is time sparse, so X-hat has to multiply A (phi * psi)
        
        residue_new = y - A * x_hat;

        residues = [residues, norm(residue_new, 2)];
        
        if itera == sparsity - 1
            sprintf("iteration limit reached, %d\n", itera);
        end
        
        if norm(residue_new, 2) >= norm(residue_prev, 2)
            % sprintf("Residue not decreasing, terminating. Iteration: %d, x_hat l0 norm: %d\n", itera, sum(x_hat ~= 0))
            break
        end
%         if norm((phi * x_hat - y), 2) < epsilon
%             sprintf("phi * x_hat - y residue smaller than epsilon, terminating.. Iteration: %d, x_hat l0 norm: %d\n", itera, sum(x_hat~= 0))
%             break
%         end
    end
end


% function [residues, x_hat, itera] = OrthogonalMatchingPursuit(phi, psi, y, sparsity, epsilon, freqSparseFlag)
%     % find best x_hat, such that minimizes ||(A* x_hat - y)||_2 < epsilon
%     A = phi * psi;
%     
%     disp(A)
%     
%     [~, xLen] = size(A);
%     x_hat = zeros(xLen, 1);
%     residue_prev = y;
%     residue_new = residue_prev;
%     S = [];
%     ATranspose = A';
%     itera = 0;
%     residues = [];
%     perfect_recovery = 0;
%     
%     while itera < sparsity
%         itera = itera + 1;
%         residue_prev = residue_new;
%         % sprintf("residue_new: %f, residue_prev: %f\n", norm(residue_new, 2), norm(residue_prev, 2))
% 
%         % set the columns from A, that gives the argmax of residue*A to be
%         % 0, so that the new argmax cannot choose previously chosen n.
%         % Because it is calculating the covariance.
%         ATranspose(S, :) = 0;
%         [~ ,n] = max(abs(ATranspose * residue_prev));
%         S = [S, n];
%         temp = zeros(size(A));
%         temp(:, S) = A(:, S);
%         ADaggerS = pinv(temp);
%         
%         x_hat = ADaggerS*y;
%         residue_new = y - A*x_hat;
% 
%         residues = [residues, norm(residue_new, 2)];
%         
%         % sprintf("residue_new: %f, residue_prev: %f\n", norm(residue_new, 2), norm(residue_prev, 2))
% 
%          if norm(residue_new, 2) >= norm(residue_prev, 2)
%              % sprintf("Residue not decreasing, terminating. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat ~= 0))
%              break
%          end
% %         if norm((x - x_hat), 2) < epsilon
% %             % sprintf("Residue smaller than epsilon, PERFECT RECOVERY, terminating.. Iteration: %d, x_hat l0 norm: %d", itera, sum(x_hat~= 0))
% %             perfect_recovery = 1;
% %             break
% %         end
%     end
% end
% 



