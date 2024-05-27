load('filtr_dielektryczny.mat');

% solve direct
tic;
x_direct = A\b;
time_direct = toc;
err_norm_direct = norm(A*x_direct - b);

fprintf("Time direct: %.6f\n", time_direct);
fprintf("Error direct: %.13f\n", err_norm_direct);

% solve Jacobi
x_jacobi = ones(size(b));
U = triu(A, 1);
L = tril(A, -1);
D = diag(diag(A));

M = -(D)\(L+U);
bm = D\b;

tic;
err_norm_jacobi = 1;
err_jacobi_table = [];
iterations = 0;
while iterations < 1000 && err_norm_jacobi > 1E-5
    x_jacobi = M*x_jacobi + bm;
    err_norm_jacobi = norm(A*x_jacobi - b);
    iterations = iterations + 1;
    err_jacobi_table(iterations) = err_norm_jacobi;
end
time_jacobi = toc;

fprintf("Time Jacobi: %.6f\n", time_jacobi);
fprintf("Error Jacobi: %.6f\n", err_norm_jacobi);

% solve Gauss-Seidel
x_gauss = ones(size(b));
U = triu(A, 1);
L = tril(A, -1);
D = diag(diag(A));

M = -(D+L)\(U);
bm = (D+L)\b;

tic;
err_norm_gauss = 1;
err_gaus_table = [];
iterations = 0;
while iterations < 1000 && err_norm_gauss > 1E-5
    x_gauss = M*x_gauss + bm;
    err_norm_gauss = norm(A*x_gauss - b);
    iterations = iterations + 1;
    err_gaus_table(iterations) = err_norm_gauss;
end
time_gauss = toc;

N=1000;
plot_error(N,err_gaus_table,err_jacobi_table);

fprintf("Time Gauss-Seidel: %.6f\n", time_gauss);
fprintf("Error Gauss-Seidel: %.6f\n", err_norm_gauss);


function plot_error(N,err_gaus_table,err_jacobi_table)
    hold on;
    plot(N, err_jacobi_table, 'DisplayName', 'Jacobi');
    plot(N, err_gaus_table, 'DisplayName', 'Gauss-Seidel');
    title('Norma błędu w kolejnych iteracjach');
    xlabel('Rozmiar macierzy N');
    ylabel('Norma błędu');
    hold off;
   
    print -dpng task_6.png
end
