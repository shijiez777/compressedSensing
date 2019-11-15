A = [4 1 8 ; 2 3 1 ; 0 4 3];
constraints = [1 1 1];

minimum =  simplexAlgorithm(A, constraints)

function minimum =  simplexAlgorithm(A, constraints)
    % A: matrix
    % constraints: column vector
    [m, n] = size(A);
    [~, constraintsM] = size(constraints);
    if n ~= constraintsM
        printf("wrong input dimensions!");
        return
    end
    
    % initialize a matrix for pivoting and updating
    constructedMatrix = zeros(m+1, n);
    constructedMatrix(1:m, 1:n) = A;
    constructedMatrix(1:m, n + 1) = constraints;
    % last row initialized by default to be -1.
    constructedMatrix(m+1, 1:n) = -1;
    % disp(constructedMatrix)
    
    % check there are still items in the bottom row are negative/ it can
    % still pivot
    [val, pivotCol] = min(constructedMatrix(m+1, :));
    
    while val < 0
        pivotRow = findPivotRow(constructedMatrix, pivotCol);
        % sprintf("pivot row: %d pivot col: %d", pivotRow, pivotCol)
        % disp(pivotRow)
        constructedMatrix = pivot(constructedMatrix, pivotRow, pivotCol);
        % disp(constructedMatrix)
        [val, pivotCol] = min(constructedMatrix(m+1, :));

    end
    % disp(constructedMatrix)
    minimum = 1/constructedMatrix(m+1, n+1);
end

function pivotRow = findPivotRow(constructedMatrix, pivotCol)
    tmpTestRatio = 0;
    minTestRatio = 0;
    pivotRow = 0;
    
    [m, n] = size(constructedMatrix);
    
    % find all positive candidates for pivoting row
    pivotRowCandidates = find(constructedMatrix(:, pivotCol) > 0);
    % calculate test ratio for all candidate rows
      for rowIdx = 1:length(pivotRowCandidates)
          row = pivotRowCandidates(rowIdx);
          % disp("current val:")
          % disp(constructedMatrix(row, pivotCol))
          tmpTestRatio = constructedMatrix(row, n)/ constructedMatrix(row, pivotCol);
          % disp(tmpTestRatio)

          if rowIdx == 1
              minTestRatio = tmpTestRatio;
              pivotRow = row;
          else
              if tmpTestRatio < minTestRatio
                minTestRatio = tmpTestRatio;
                pivotRow = row;
              end
          end
      end
end




function pivotedMatrix = pivot(constructedMatrix, pivotRow, pivotCol)
    [m, n] = size(constructedMatrix);
    pivotedMatrix = zeros(m, n);
    % update all the q(cells that are not on the pivotRow or pivotCol) first
    for rowIdx = 1:m
        for colIdx = 1:n
            if rowIdx ~= pivotCol && colIdx ~=pivotRow
                pivotedMatrix(rowIdx, colIdx) = constructedMatrix(rowIdx, colIdx) - constructedMatrix(pivotRow, colIdx) * constructedMatrix(rowIdx, pivotCol)/constructedMatrix(pivotRow, pivotCol);
            end
        end
    end
    
    % update pivot row and column
    pivotedMatrix(pivotRow, :) = constructedMatrix(pivotRow, :) / constructedMatrix(pivotRow, pivotCol);
    pivotedMatrix(:, pivotCol) = - constructedMatrix(:, pivotCol) / constructedMatrix(pivotRow, pivotCol);
    % update pivot point
    pivotedMatrix(pivotRow, pivotCol) = 1/ constructedMatrix(pivotRow, pivotCol);
end







% [m, n] = size(A);
% constructedMatrix = zeros(m+1, n);
% constructedMatrix(1:m, 1:n) = A;
% constructedMatrix(1:m, n + 1) = constraints;
% constructedMatrix(m+1, 1:n) = -1;
% [val, pivotCol] = min(constructedMatrix(m+1, :));
% pivotRow = findPivotRow(constructedMatrix, pivotCol);
% constructedMatrix = pivot(constructedMatrix, pivotRow, pivotCol);
% [val, pivotCol] = min(constructedMatrix(m+1, :));
% pivotRow = findPivotRow(constructedMatrix, pivotCol);
% constructedMatrix = pivot(constructedMatrix, pivotRow, pivotCol);



% tempA = simplexAlgorithm(A, constraints);



% constructedMatrix = [4 1 8 1; 2 3 1 1; 0 4 3 1; -1, -1, -1, 0];
% step = pivot(constructedMatrix, 1, 1);
% pivotCol = 2;
% findPivotRow(constructedMatrix, pivotCol)
