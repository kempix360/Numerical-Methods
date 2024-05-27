a = 1;
b = 50;
ytolerance = 1E-12;
max_iterations = 100;
f = @impedance_magnitude;

[omega_bisection,~,~,xtab_bisection,xdif_bisection] = bisection_method(a,b,max_iterations,ytolerance,f);
[omega_secant,~,~,xtab_secant,xdif_secant] = secant_method(a,b,max_iterations,ytolerance,f);

figure;
subplot(2, 1, 1);
plot(xtab_bisection, 'DisplayName', 'Bisection');
hold on;
plot(xtab_secant, 'DisplayName', 'Secant');
xlabel('Iterations');
ylabel('X_candidates');
title('Iterations vs X_candidates');
legend('Location', 'best');

subplot(2, 1, 2);
semilogy(xdif_bisection, 'DisplayName', 'Bisection');
hold on;
semilogy(xdif_secant, 'DisplayName', 'Secant');
xlabel('Iterations');
ylabel('Difference');
title('Iterations vs Difference');
legend('Location', 'best');
print -dpng 4_4.png
