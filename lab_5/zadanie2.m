function [nodes_Chebyshev, V, V2, original_Runge, interpolated_Runge, interpolated_Runge_Chebyshev] = zadanie2()
% nodes_Chebyshev - wektor wierszowy zawierający N=16 węzłów Czebyszewa drugiego rodzaju
% V - macierz Vandermonde obliczona dla 16 węzłów interpolacji rozmieszczonych równomiernie w przedziale [-1,1]
% V2 - macierz Vandermonde obliczona dla węzłów interpolacji zdefiniowanych w wektorze nodes_Chebyshev
% original_Runge - wektor wierszowy zawierający wartości funkcji Runge dla wektora x_fine=linspace(-1, 1, 1000)
% interpolated_Runge - wektor wierszowy wartości funkcji interpolującej określonej dla równomiernie rozmieszczonych węzłów interpolacji
% interpolated_Runge_Chebyshev - wektor wierszowy wartości funkcji interpolującej wyznaczonej
%       przy zastosowaniu 16 węzłów Czebyszewa zawartych w nodes_Chebyshev 
N = 16;
x_fine = linspace(-1, 1, 1000);
nodes_Chebyshev = get_Chebyshev_nodes(N);
nodes_normal = linspace(-1,1,N);

V = vandermonde_matrix(N, nodes_normal);
V2 = vandermonde_matrix(N, nodes_Chebyshev);

original_Runge = runge_function(x_fine);
original_Runge = original_Runge';

runge_normal = runge_function(nodes_normal);
c_runge_normal = V \ runge_normal;
interpolated_Runge = polyval(flipud(c_runge_normal), x_fine);

runge_chebyshev = runge_function(nodes_Chebyshev);
c_runge_chebyshev = V2 \ runge_chebyshev;
interpolated_Runge_Chebyshev = polyval(flipud(c_runge_chebyshev), x_fine);

subplot(2,1,1);
plot(x_fine, original_Runge, 'DisplayName', 'Runge function');
hold on;
plot(nodes_normal, runge_normal, 'o', 'DisplayName', 'Runge function at nodes');
plot(x_fine, interpolated_Runge, 'DisplayName', ['Interpolation for N = ', num2str(N)]);
hold off;
xlabel('x');
ylabel('Runge(x)');
title('Interpolations in Runge function');
legend;

subplot(2,1,2);
plot(x_fine, original_Runge, 'DisplayName', 'Runge function Chebyshev');
hold on;
plot(nodes_Chebyshev, runge_chebyshev, 'o', 'DisplayName', 'Runge function at Chebyshev nodes');
plot(x_fine, interpolated_Runge_Chebyshev, 'DisplayName', ['Interpolation for N = ', num2str(N)]);
hold off;
xlabel('x');
ylabel('Runge(x)');
title('Interpolations in Runge function - Chebyshev nodes');
legend;

saveas(gcf, 'zadanie2.png');
end

function nodes = get_Chebyshev_nodes(N)
    nodes = zeros(1, N);

    for k = 1:N
        nodes(k) = cos((k-1)*pi / (N - 1));
    end
end

function V = vandermonde_matrix(N, x)
    V = zeros(N, N);

    for i = 1:N
        V(:, i) = x.^(i-1);
    end
end

function y = runge_function(x)
    y = (1./(1 + 25 * x.^2))';
end