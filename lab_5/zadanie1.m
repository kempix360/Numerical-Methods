function [V, original_Runge, original_sine, interpolated_Runge, interpolated_sine] = zadanie1()
% Rozmiar tablic komórkowych (cell arrays) V, interpolated_Runge, interpolated_sine: [1,4].
% V{i} zawiera macierz Vandermonde wyznaczoną dla liczby węzłów interpolacji równej N(i)
% original_Runge - wektor wierszowy zawierający wartości funkcji Runge dla wektora x_fine=linspace(-1, 1, 1000)
% original_sine - wektor wierszowy zawierający wartości funkcji sinus dla wektora x_fine
% interpolated_Runge{i} stanowi wierszowy wektor wartości funkcji interpolującej 
%       wyznaczonej dla funkcji Runge (wielomian stopnia N(i)-1) w punktach x_fine
% interpolated_sine{i} stanowi wierszowy wektor wartości funkcji interpolującej
%       wyznaczonej dla funkcji sinus (wielomian stopnia N(i)-1) w punktach x_fine
N = 4:4:16;
x_fine = linspace(-1, 1, 1000);
original_Runge = runge_function(x_fine);
original_Runge = original_Runge';

subplot(2,1,1);
plot(x_fine, original_Runge, 'DisplayName', "Runge function");
xlabel('x');
ylabel('Runge(x)');
title('Interpolations in Runge function');
hold on;
for i = 1:length(N)
    V{i} = vandermonde_matrix(N(i));
    nodes = linspace(-1, 1, N(i));
    new_Runge = runge_function(nodes);
    c_runge = V{i} \ new_Runge;
    interpolated_Runge{i} = polyval(flipud(c_runge), x_fine);
    plot(x_fine, interpolated_Runge{i}, 'DisplayName', ['Interpolation for N = ', num2str(N(i))]);
end
hold off
legend;

original_sine = sin(2 * pi * x_fine);
subplot(2,1,2);
plot(x_fine, original_sine, 'DisplayName', "Sine function");
xlabel('x');
ylabel('sin(x)');
title('Interpolations in sine function');
hold on;
for i = 1:length(N)
    V{i} = vandermonde_matrix(N(i));
    nodes = linspace(-1, 1, N(i));
    new_sine = (sin(2 * pi * nodes))';
    c_sine = V{i} \ new_sine;
    interpolated_sine{i} = polyval(flipud(c_sine), x_fine);
    plot(x_fine, interpolated_sine{i}, 'DisplayName', ['Interpolation for N = ', num2str(N(i))]);
end
hold off
legend;

saveas(gcf, 'zadanie1.png');
end

function V = vandermonde_matrix(N)
    x_coarse = linspace(-1,1,N);
    V = zeros(N, N);

    for i = 1:N
        V(:, i) = x_coarse.^(i-1);
    end
end

function y = runge_function(x)
    y = (1./(1 + 25 * x.^2))';
end