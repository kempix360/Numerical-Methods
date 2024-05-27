clear all
close all
format compact

% Definicja parametrów
a = 10; % długość boku kwadratu
r_max = a/2; % maksymalny promień okręgów
n_max = 200; % maksymalna liczba okręgów

[circles, index_number, circle_areas, rand_counts, counts_mean] = generate_circles(a, r_max, n_max);

% Rysowanie okręgów
plot_counts_mean(circle_areas);

function plot_counts_mean(counts_mean)

    % Wygenerowanie wykresu
    plot(counts_mean);

    % Dodanie tytułu i opisów osi
    title('Wykres counts_mean');
    xlabel('Indices');
    ylabel('counts_mean');

    print -dpng task_5.png 
end
function [circles, index_number, circle_areas, rand_counts, counts_mean] = generate_circles(a, r_max, n_max)
    % Pobranie ostatniej cyfry numeru indeksu
    index_number = 197259;
    L1 = mod(index_number, 10);

    % Inicjalizacja zmiennej circles
    circles = zeros(3, n_max);
    circle_areas = zeros(n_max, 1);
    rand_counts = zeros(n_max, 1);
    counts_mean = zeros(n_max, 1);

    i = 1;
    number_of_rands = 0;
    % Generowanie okręgów
    while i <= n_max
        is_intersection = false;
        number_of_rands = number_of_rands + 1;
        % Wygenerowanie losowej pozycji i promienia
       
        % Liczba nieparzysta - kolumny
        X = rand() * a;
        Y = rand() * a;
        R = rand() * r_max;
        if (X + R > a || X - R < 0 || Y + R > a || Y - R < 0)
            continue;
        end
        circle = [R; X; Y];
        for j = 1:i-1
            if (sqrt((X - circles(2,j))^2 + (Y - circles(3,j))^2) <= R+circles(1,j))
               is_intersection = true;
               break;
            end
        end
        if (~is_intersection)
            circles(:, i) = circle;
            if (i==1)
                circle_areas(i) = pi * R^2;
            else
                circle_areas(i) = pi * R^2 + circle_areas(i-1);
            end
            rand_counts(i) = number_of_rands;
            counts_mean(i) = mean(rand_counts(1:i));
            number_of_rands = 0;
            i=i+1;
        end
    end
end
