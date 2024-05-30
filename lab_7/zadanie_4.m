[integration_error, Nt, ft_5, xr, yr, yrmax] = zadanie4();

function [integration_error, Nt, ft_5, xr, yr, yrmax] = zadanie4()
    % Numeryczne całkowanie metodą Monte Carlo.
    %
    %   integration_error - wektor wierszowy. Każdy element integration_error(1,i)
    %       zawiera błąd całkowania obliczony dla liczby losowań równej Nt(1,i).
    %       Zakładając, że obliczona wartość całki dla Nt(1,i) próbek wynosi
    %       integration_result, błąd jest definiowany jako:
    %       integration_error(1,i) = abs(integration_result - reference_value),
    %       gdzie reference_value to wartość referencyjna całki.
    %
    %   Nt - wektor wierszowy zawierający liczby losowań, dla których obliczano
    %       wektor błędów całkowania integration_error.
    %
    %   ft_5 - gęstość funkcji prawdopodobieństwa dla n=5
    %
    %   [xr, yr] - tablice komórkowe zawierające informacje o wylosowanych punktach.
    %       Tablice te mają rozmiar [1, length(Nt)]. W komórkach xr{1,i} oraz yr{1,i}
    %       zawarte są współrzędne x oraz y wszystkich punktów zastosowanych
    %       do obliczenia całki przy losowaniu Nt(1,i) punktów.
    %
    %   yrmax - maksymalna dopuszczalna wartość współrzędnej y losowanych punktów

    reference_value = 0.0473612919396179; % wartość referencyjna całki

    Nt = 5:50:10000;
    integration_error = zeros(1, length(Nt));
    xr = cell(1, length(Nt));
    yr = cell(1, length(Nt));
    ft_5 = f(5);
    yrmax = max(arrayfun(@(t) f(t), linspace(0, 5, 1000)));

    for i = 1:length(Nt)
        n = Nt(i);
        x_rand = 5 * rand(1, n); % losowe x w przedziale [0, 5]
        y_rand = yrmax * rand(1, n); % losowe y w przedziale [0, yrmax]

        xr{i} = x_rand;
        yr{i} = y_rand;

        % Punkty poniżej krzywej f(x)
        below_curve = y_rand <= f(x_rand);
        integration_result = (5 * yrmax) * (sum(below_curve) / n);
        integration_error(i) = abs(integration_result - reference_value);
    end
    
    figure;
    loglog(Nt, integration_error);
    xlabel('Liczba losowań (N)');
    ylabel('Błąd całkowania');
    title('Błąd całkowania metodą Monte Carlo');
    grid on;
    
    saveas(gcf, 'zadanie4.png');
end

function y = f(t)
    % Parametry rozkładu normalnego
    mu = 10; % średnia
    sigma = 3; % odchylenie standardowe
    
    % Obliczanie wartości funkcji gęstości prawdopodobieństwa
    y = (1 / (sigma * sqrt(2 * pi))) * exp(-((t - mu).^2) / (2 * sigma^2));
end
