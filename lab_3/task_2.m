N = 1000:1000:8000;
n = length(N);
vtime_direct = ones(1,n);
for i = 1:n
    [A,b,x,time_direct,err_norm,index_number] = solve_direct(N(i));
    vtime_direct(i) = time_direct;
end

plot_direct(N,vtime_direct);

function plot_direct(N, vtime_direct)
    plot(N, vtime_direct, '-o', 'LineWidth', 2);
    xlabel('Rozmiar macierzy A');
    ylabel('Czas wyznaczenia rozwiązania [s]');
    title('Zależność czasu wyznaczenia rozwiązania od rozmiaru problemu');
    print -dpng task_2.png
end