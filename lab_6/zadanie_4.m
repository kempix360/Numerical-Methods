load('energy.mat');

[country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse, msek] = zadanie4(energy);

function [country, source, degrees, x_coarse, x_fine, y_original, y_yearly, y_approximation, mse, msek] = zadanie4(energy)
% Głównym celem tej funkcji jest wyznaczenie danych na potrzeby analizy dokładności aproksymacji wielomianowej.
% 
% energy - struktura danych wczytana z pliku energy.mat
% country - [String] nazwa kraju
% source  - [String] źródło energii
% x_coarse - wartości x danych aproksymowanych
% x_fine - wartości, w których wyznaczone zostaną wartości funkcji aproksymującej
% y_original - dane wejściowe, czyli pomiary produkcji energii zawarte w wektorze energy.(country).(source).EnergyProduction
% y_yearly - wektor danych rocznych
% y_approximation - tablica komórkowa przechowująca wartości nmax funkcji aproksymujących dane roczne.
%   - nmax = length(y_yearly)-1
%   - y_approximation{i} stanowi aproksymację stopnia i
%   - y_approximation{i} stanowi wartości funkcji aproksymującej w punktach x_fine
% mse - wektor mający nmax wierszy: mse(i) zawiera wartość błędu średniokwadratowego obliczonego dla aproksymacji stopnia i.
%   - mse liczony jest dla aproksymacji wyznaczonej dla wektora x_coarse
% msek - wektor mający (nmax-1) wierszy: msek zawiera wartości błędów różnicowych zdefiniowanych w treści zadania 4
%   - msek(i) porównuj aproksymacje wyznaczone dla i-tego oraz (i+1) stopnia wielomianu
%   - msek liczony jest dla aproksymacji wyznaczonych dla wektora x_fine

country = 'France';
source = 'Bioenergy';
degrees = [1,5,10,15];
x_coarse = [];
x_fine = [];
y_original = [];
y_yearly = [];
y_approximation = [];
mse = [];
msek = [];

% Sprawdzenie dostępności danych
if isfield(energy, country) && isfield(energy.(country), source)
    % Przygotowanie danych do aproksymacji
    dates = energy.(country).(source).Dates;
    y_original = energy.(country).(source).EnergyProduction;

    % Obliczenie danych rocznych
    n_years = floor(length(y_original) / 12);
    y_cut = y_original(end-12*n_years+1:end);
    y4sum = reshape(y_cut, [12 n_years]);
    y_yearly = sum(y4sum,1)';

    % degrees = 

    N = length(y_yearly);
    x_coarse = linspace(-1, 1, N)';
    x_fine = linspace(-1, 1, (N-1)*10+1)';

    % Pętla po wielomianach różnych stopni
    for i = 1:N-1
        p = my_polyfit(x_coarse, y_yearly, i);
        y_approx_coarse = polyval(p, x_coarse);
        mse(i) = mean((y_yearly - y_approx_coarse).^2);
        y_approximation{i} = polyval(p, x_fine);

        if i < N-1
            p_next = my_polyfit(x_coarse, y_yearly, i+1);
            y_approx_next = polyval(p_next, x_fine);
            msek(i) = mean((y_approximation{i} - y_approx_next).^2);
        end
    end
    
    subplot(3,1,1);
    hold on;
    plot(x_coarse, y_yearly, 'DisplayName', 'Oryginalne dane');
    for i = 1:length(degrees)
        plot(x_fine, y_approximation{degrees(i)}, 'DisplayName', ['Aproksymacja stopnia ', num2str(degrees(i))]);
    end
    hold off;
    xlabel('x');
    ylabel('Produkcja energii');
    title('Aproksymacja produkcji energii');
    legend('show', 'Location', 'eastoutside');

    % Drugi wykres
    subplot(3,1,2);
    bar(mse);
    set(gca, 'XTickLabel', 1:N-1);
    xlabel('Stopień wielomianu');
    xticks(1:N-1);
    ylabel('Błąd średniokwadratowy');
    title('Błąd średniokwadratowy dla różnych stopni aproksymacji');
    
    % Trzeci wykres
    subplot(3,1,3);
    semilogy(1:N-2, msek, '-o');
    xlabel('Stopień wielomianu');
    ylabel('Różnica błędu średniokwadratowego (MSE)');
    title('Różnica błędu średniokwadratowego dla kolejnych stopni aproksymacji');

    % Zapis wykresu do pliku
    saveas(gcf, 'zadanie4.png');

else
    disp(['Dane dla (country=', country, ') oraz (source=', source, ') nie są dostępne.']);
end

end


function p = my_polyfit(x, y, deg) 
    n = length(y);
    X = ones(n,1);
    for i = 1:deg
        X(:, i+1) = x.^i;
    end

    p = X \ y;
    p = p';
    p = flip(p);
end
