 fun = @(x) -20*exp(-0.2*sqrt(0.5*(x(1)^2+x(2)^2))) - exp(0.5*(cos(2*pi*x(1))+cos(2*pi*x(2)))) + exp(1) + 20;

 hybridopts = optimoptions('fmincon', 'Algorithm', 'sqp');

    % PSO configuration with fmincon as hybrid function
    options = optimoptions('particleswarm',...
        'SwarmSize', 50,...
        'MaxIterations', 100,...
        'Display', 'iter',...
        'UseVectorized', false,...
        'InertiaRange', [0.1 0.5],...
        'SocialAdjustmentWeight', 1.5,...
        'SelfAdjustmentWeight', 1.5,...
        'HybridFcn', {'fmincon', hybridopts});

    % Search parameters
    nvars = 2;
    lb = [-5, -5];
    ub = [5, 5];

    % Execute PSO with automatic local refinement using fmincon
    [x_refined, fval_refined] = particleswarm(fun, nvars, lb, ub, options);

     
    fprintf('\n=== Final result ===\n')
    fprintf('Optimal coordinates: [%.2f, %.2f]\n', x_refined)
    fprintf('Function value: %.2f\n', fval_refined)
    fprintf('Absolute error: %.2e\n', norm(x_refined))