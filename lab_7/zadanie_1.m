[integration_error, Nt, ft_5, integral_1000] = zadanie1();

function [integration_error, Nt, ft_5, integral_1000] = zadanie1()
    % Numeryczne całkowanie metodą prostokątów.
    % Nt - wektor zawierający liczby podprzedziałów całkowania
    % integration_error - integration_error(1,i) zawiera błąd całkowania wyznaczony
    %   dla liczby podprzedziałów równej Nt(i). Zakładając, że obliczona wartość całki
    %   dla Nt(i) liczby podprzedziałów całkowania wyniosła integration_result,
    %   to integration_error(1,i) = abs(integration_result - reference_value),
    %   gdzie reference_value jest wartością referencyjną całki.
    % ft_5 - gęstość funkcji prawdopodobieństwa dla n=5
    % integral_1000 - całka od 0 do 5 funkcji gęstości prawdopodobieństwa
    %   dla 1000 podprzedziałów całkowania

    reference_value = 0.0473612919396179; % wartość referencyjna całki

    Nt = 5:50:10^4;
    integration_error = [];

    ft_5 = f(5);
    integral_1000 = rectangular_integration(@f, 1000);

    for i = 1:length(Nt)
        integration_result = rectangular_integration(@f, Nt(i));
        integration_error(i) = abs(integration_result - reference_value);
    end
    
    figure;
    loglog(Nt, integration_error);
    xlabel('Liczba podprzedziałów (N)');
    ylabel('Błąd całkowania');
    title('Błąd całkowania metodą prostokątów');
    grid on;
    
    saveas(gcf, 'zadanie1.png');
end

function y = f(t)
    % Parametry rozkładu normalnego
    mu = 10; % średnia
    sigma = 3; % odchylenie standardowe
    
    % Obliczanie wartości funkcji gęstości prawdopodobieństwa
    y = (1 / (sigma * sqrt(2 * pi))) * exp(-((t - mu).^2) / (2 * sigma^2));
end

function integral = rectangular_integration(f, k)
    % Zakres całkowania
    a = 0;
    b = 5;
    
    % Długość podprzedziału
    dx = (b - a) / k;
    
    x = [];
    for i = 1:k+1
        x(i) = a + (i-1)*dx;
    end
    
    sum_y = 0;
    for i = 1:k
        sum_y = sum_y + f((x(i)+x(i+1)) / 2);
    end

    integral = sum_y * dx;
end