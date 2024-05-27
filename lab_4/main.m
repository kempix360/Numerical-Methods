% 1
omega = 10;
impedance_delta = impedance_magnitude(omega);
disp(impedance_delta);

% 2
format long
f = @(x) x.^2 - 4.01;
a = 0;
b = 4;
max_iterations = 100;
ytolerance = 1e-12;
% [xsolution,ysolution,iterations,xtab,xdif] = bisection_method(a,b,max_iterations,ytolerance,f);

% 3
format long
f = @(x) x.^2 - 4.01;
a = 0;
b = 4;
max_iterations = 100;
ytolerance = 1e-12;
[xsolution,ysolution,iterations,xtab,xdif] = secant_method(a,b,max_iterations,ytolerance,f);

% 5
time = 10;
velocity_delta = rocket_velocity(time);

% 7
N = 40000;
time_delta = estimate_execution_time(N);