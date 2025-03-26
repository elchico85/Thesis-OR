%That's an easy example, and it's designed
% Define the objective function coefficients (costs)
c = [8 4];

% Define the constraint matrices
% For constraints of the form Ax <= b
A_leq = [15 2];    % Fat constraint
b_leq = 60;         % Fat limit

% Convert Ax >= b to -Ax <= -b [could be done by multiplication, e.g. A_geq_neg = A_geq_pos*(-1)]
A_geq = [-5 -15;    % Carbohydrates constraint
         -20 -5];   % Protein constraint
b_geq = [-50; -40];  % Minimum requirements

% Combine inequality constraints [concatenation -note that leq and geq are in the same order]
A = [A_leq; A_geq];
b = [b_leq; b_geq];

% Lower bounds [non-negativity]
lb = [0 0];

% Solve the diet
[x, fval] = linprog(c, A, b, [], [], lb, []);

% Display the results
fprintf('Optimal solution:\n');
fprintf('Servings of steak: %.2f\n', x(1));
fprintf('Servings of potatoes: %.2f\n', x(2));
fprintf('Minimum daily cost: €%.2f\n', fval);

% Display the nutritional content
carbs = 5*x(1) + 15*x(2);
protein = 20*x(1) + 5*x(2);
fat = 15*x(1) + 2*x(2);
fprintf('\nNutritional content:\n');
fprintf('Carbohydrates: %.2f g (minimum: 50 g)\n', carbs);
fprintf('Protein: %.2f g (minimum: 40 g)\n', protein);
fprintf('Fat: %.2f g (maximum: 60 g)\n', fat);