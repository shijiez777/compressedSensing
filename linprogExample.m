% Problem:
% max(20000x1 + 15000x2 + 16000x3)
% Subject to:
%  50x1 + 30x2 + 30x3 <= 2000
%  2x1 + 3x2 + 2x3 <= 70
%  x1 + x2 + x3 <= 30
%  x1, x2, x3 >= 0


% [X, Z] = linprog(f, A, b, Aeq, beq, lb, ub)
% linprog solves minimization problems. So we have to convert problems to 
% minimization problem
%% So above problem is converted to :
% min(-20000x1 - 15000x2 - 16000x3)

% f: objective function
f = [-20000; - 15000; -16000];

% A: constraint coefficient of less-than or equal constraint.(left hand side coeffecient of the constraints)
A = [50 30 30; 2 3 2; 1 1 1];

% b: right hand side of the less-than or equal constraints.
% row vector, column vector, no difference
b = [2000 70 30];

% Aeq: left hand side constraint coefficients of equality contraints
% no equality constraint.
Aeq = [];

% beq: right hand side of the equality constraints
% no equality constraint.
beq = [];

% lb: lower bound of variables
lb = [0 0 0];

% ub: upper bounds for variables
ub = [];


% [X, Z] = linprog(f, A, b, Aeq, beq, lb, ub)
% X; value of decision variables
% Z: objective function output
[X, Z] = linprog(f, A, b, Aeq, beq, lb, ub)




