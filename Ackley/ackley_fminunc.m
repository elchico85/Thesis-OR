fun = @(x) -20*exp(-0.2*sqrt(0.5*(x(1)^2+x(2)^2))) - exp(0.5*(cos(2*pi*x(1))+cos(2*pi*x(2)))) + exp(1) + 20;
options = optimset('OutputFcn',@ackleyout);
x0 = [2, 2];
[x,fval,eflag,output] = fminunc(fun,x0,options);
title 'Ackley path using fminunc'
Fcount = output.funcCount;
disp(['Function evaluations: ',num2str(Fcount)])
disp(['Iterations: ',num2str(output.iterations)])
disp(['Solution find: ',num2str(x)])
disp(['Solution value: ',num2str(fval)])
