N = 1000:1000:8000;
n = length(N);
time_Jacobi = ones(1,n);
time_Gauss_Seidel = 2*ones(1,n);
iterations_Jacobi = 40*ones(1,n);
iterations_Gauss_Seidel = 40*ones(1,n);
for i = 1:n
    [~,~,~,~,~,~,time,iterations,~] = solve_Gauss_Seidel(N(i));
    time_Gauss_Seidel(i) = time;
    iterations_Gauss_Seidel(i) = iterations;
    [~,~,~,~,~,~,time_2,iterations_2,~] = solve_Jacobi(N(i));
    iterations_Jacobi(i) = iterations_2;
    time_Jacobi(i) = time_2;
end

plot_problem_5(N,time_Jacobi,time_Gauss_Seidel,iterations_Jacobi,iterations_Gauss_Seidel);

function plot_problem_5(N,time_Jacobi,time_Gauss_Seidel,iterations_Jacobi,iterations_Gauss_Seidel)
    subplot(2, 1, 1);
    plot(N, time_Jacobi, '-o', 'DisplayName', 'Jacobi');
    hold on;
    plot(N, time_Gauss_Seidel, '-o', 'DisplayName', 'Gauss-Seidel');
    hold off;
    title('Czas obliczeń w zależności od rozmiaru macierzy');
    xlabel('Rozmiar macierzy N');
    ylabel('Czas obliczeń [s]');
    legend('Location', 'eastoutside');
    
    subplot(2, 1, 2);
    bar_data = [iterations_Jacobi; iterations_Gauss_Seidel]';
    bar(N, bar_data);
    title('Liczba iteracji w zależności od rozmiaru macierzy');
    xlabel('Rozmiar macierzy N');
    ylabel('Liczba iteracji');
    legend('Jacobi', 'Gauss-Seidel', 'Location', 'eastoutside');

    print -dpng task_5.png
end