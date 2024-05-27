a = 1;
b = 60000;
ytolerance = 1e-12;
max_iterations = 100;
f = @estimate_execution_time;

[n_bisection,~,~,xtab_bisection,xdif_bisection] = bisection_method(a,b,max_iterations,ytolerance,f);
[n_secant,~,~,xtab_secant,xdif_secant] = secant_method(a,b,max_iterations,ytolerance,f);

figure;
subplot(2, 1, 1);
plot(xtab_bisection, 'DisplayName', 'Bisection');
hold on;
plot(xtab_secant, 'DisplayName', 'Secant');
xlabel('Iterations');
ylabel('N');
title('Iterations vs N');
legend('Location', 'best');

subplot(2, 1, 2);
semilogy(xdif_bisection, 'DisplayName', 'Bisection');
hold on;
semilogy(xdif_secant, 'DisplayName', 'Secant');
xlabel('Iterations');
ylabel('Difference');
title('Difference vs Iterations');
legend('Location', 'best');
print -dpng 4_8.png