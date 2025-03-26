% Definition of objective functions
fun = @(x) [-50*x(1) - 70*x(2);   % Profit (maximize)
            2*x(1) + 3*x(2)];      % Machine time (minimize)

% Desired goals
goal = [-2000; 60]; 

% Scaled weights
weight = [1; 1]; 

% Constraints
A = [2, 3;     % Machine time
     3, 4];    % Material
b = [100; 120];
lb = [0; 0];
x0 = [10; 10];

% Call to fgoalattain
[x, attn, gamma] = fgoalattain(fun, x0, goal, weight, A, b, [], [], lb);

%% Formatted output
fprintf('---------------- Results ----------------\n');
fprintf('Optimal quantities:\n');
fprintf('• Product A: %.2f units\n', x(1));
fprintf('• Product B: %.2f units\n\n', x(2));

fprintf('Achieved values:\n');
fprintf('• Profit: $%.2f (goal: $2000)\n', -attn(1));
fprintf('• Machine time: %.2f hours (goal: 60 hours)\n\n', attn(2));

fprintf('Attainment factor gamma: %.4f\n', gamma);
fprintf('-------------------------------------------\n');

%% Plot the results
figure;
subplot(2,1,1);
bar(x);
title('Optimal Production');
xticklabels({'Product A', 'Product B'});
ylabel('Quantity');

subplot(2,1,2);
bar([-attn(1), 2000; attn(2), 60]);
legend('Achieved Value', 'Goal');
set(gca, 'XTickLabel', {'Profit (€)', 'Machine time (hours)'});
title('Comparison with Goals');
