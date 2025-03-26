%% Start capturing the output to a text file
diary('output.txt');

%% Clear workspace
clear;
clc;

%% Examples from OPERATIONS RESEARCH THEORY AND APPLICATIONS - SHARMA [Uncomment to try]
% Example 1
% A_payoff_1 = [ 
%     1  -1   3;
%     3   5  -3;
%     6   2  -2 
% ];

% Example 2
% A_payoff_2 = [ 
%     9   1   4;
%     0   6   3;
%     5   2   8 
% ];

% Example 3
% A_payoff_3 = [ 
%     -6   7;
%      4  -5;
%     -1  -2;
%     -2   5;
%      7  -6 
% ];

 %% Read External Matrix
[num] = xlsread("payoff_matrix.xlsx");
A_payoff = num(1:end, 1:end); % Extract only numerical values [exclude headers]

fprintf('Original Payoff Matrix (Player A):\n');
disp(A_payoff);

[m, n] = size(A_payoff); % m = A strategies, n = B strategies

%% Matrix evaluation and adjustment for non-positive value

min_val = min(A_payoff(:));
k = 0; % Shift constant

if min_val <= 0
    k = abs(min_val);
    A_shifted = A_payoff + k;
    fprintf('\nMinimum payoff <= 0. Shifting matrix by k = %g\n', k);
    fprintf('Shifted Payoff Matrix:\n');
    disp(A_shifted);
else
    A_shifted = A_payoff; % No shift needed
    fprintf('\nMinimum payoff > 0. No matrix shift needed.\n');
end

%% Set up and Solve Player A Linear Program [LP Primal]

f = ones(m, 1);           % Objective function coefficients (vector of 1s)
A_lp_PlayerA = -A_shifted';       % Inequality constraint matrix (-A^T)
b_lp_PlayerA = -ones(n, 1);       % Inequality constraint vector (vector of -1s)
lb_PlayerA = zeros(m, 1);         % Lower bounds for x_i (all zeros)

options = optimoptions('linprog', 'Display', 'off'); % Suppress linprog output

[x_A, Zp_inv_A, exitflag_A] = linprog(f, A_lp_PlayerA, b_lp_PlayerA, [], [], lb_PlayerA, [], options);

% Check if solution was found
if exitflag_A ~= 1
    error('Player A''s LP did not converge to a solution. Exit flag: %d', exitflag_A);
end

%% Calculate Player A's Optimal Strategy and Game Value

V_shifted_A = 1 / Zp_inv_A;
V_A = V_shifted_A - k; % Adjust game value back if matrix was shifted

p_A = x_A * V_shifted_A; % Player A's optimal probabilities

fprintf('====== Player A (Row Player) Results ======\n');
fprintf('Optimal Mixed Strategy (Probabilities):\n');
for i = 1:m
    fprintf('  Strategy A%d: %f\n', i, p_A(i));
end
fprintf('Probability Sum Check: %f \n', sum(p_A));
fprintf('Calculated Game Value (from A''s LP): V = %f\n', V_A);

%% Set up and Solve Player B's (Column Player) Linear Program (Dual)

f_B = -ones(n, 1);          % Objective function coefficients (vector of -1s)
A_lp_PlayerB = A_shifted;         % Inequality constraint matrix (A_shifted)
b_lp_PlayerB = ones(m, 1);        % Inequality constraint vector (vector of 1s)
lb_PlayerB = zeros(n, 1);         % Lower bounds for y_j (all zeros)

[y_B, Zp_neg_inv_B, exitflag_B] = linprog(f_B, A_lp_PlayerB, b_lp_PlayerB, [], [], lb_PlayerB, [], options);

% Check if solution was found
if exitflag_B ~= 1
    error('Player B''s LP did not converge to a solution. Exit flag: %d', exitflag_B);
end

%% Calculate Player B's Optimal Strategy and Verify Game Value

V_shifted_B = 1 / (-Zp_neg_inv_B);
V_B = V_shifted_B - k; % Adjust game value back

% q_j = y_j * V_shifted
q_B = y_B * V_shifted_B; % Player B's optimal probabilities

fprintf('====== Player B (Column Player) Results ======\n');
fprintf('Optimal Mixed Strategy (Probabilities):\n');
for j = 1:n
    fprintf('  Strategy B%d: %f\n', j, q_B(j));
end
fprintf('Probability Sum Check: %f \n', sum(q_B));
fprintf('Calculated Game Value (from B''s LP): V = %f\n', V_B);

%% Final Verification
fprintf('\n====== Verification ======\n');
fprintf('Game Value from A''s LP: %f\n', V_A);
fprintf('Game Value from B''s LP: %f\n', V_B);
expected_payoff_A = p_A' * A_payoff * q_B;
fprintf('Expected Payoff (p'' * A * q): %f (should be equal to Game Value)\n', expected_payoff_A);

%% Stop capturing the output and automatically write the txt and .tex file
diary off;

% Read the captured output
fileID = fopen('output.txt', 'r');
outputText = fread(fileID, '*char')';
fclose(fileID);

% Open the LaTeX file to write
latexFileID = fopen('output_latex.tex', 'w');

%% Write the LaTeX document

fprintf(latexFileID, '\\\begin{mdframed}[backgroundcolor=gray!20, linecolor=black, roundcorner=10pt]\n');

% Write the captured MATLAB output to the LaTeX file
fprintf(latexFileID, '%s\n', outputText);

% Write the LaTeX document footer
fprintf(latexFileID, '\\\end{mdframed}\n');

% Close the LaTeX file
fclose(latexFileID);