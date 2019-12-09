A = [4 1 8 ; 2 3 1 ; 0 4 3];
constraints = [1 1 1];

minimum =  simplexAlgorithm(A, constraints)


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
