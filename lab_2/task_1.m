clear all
close all
format compact

% Definicja parametrów
a = 10; % długość boku kwadratu
r_max = a/2; % maksymalny promień okręgów
n_max = 200; % maksymalna liczba okręgów

% Generowanie okręgów
circles = generate_circles(a, r_max, n_max);

% Rysowanie okręgów
plot_circles(circles, a);
print -dpng task_1.png


function [circles, index_number] = generate_circles(a, r_max, n_max)
    % Pobranie ostatniej cyfry numeru indeksu
    index_number = 197259;

    circles = zeros(3, n_max);
    i = 1;
    % Generowanie okręgów
    while i <= n_max
        is_intersection = false;
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
            i=i+1;
        end
    end
end


% Funkcja rysująca okręgi
function plot_circles(circles, a)
    % Ustawienie wyrównania osi x i y
    axis equal;
    % Ograniczenie wyświetlanego obszaru
    axis([0 a 0 a]);
    % Włączenie trybu 'hold on' dla dodawania nowych okręgów bez kasowania poprzednich
    hold on;
    
    for i = 1:size(circles,2)
        R = circles(1, i);
        X = circles(2, i);
        Y = circles(3, i);
        % Rysowanie okręgu
        plot_circle(R, X, Y);
    end
end

function plot_circle(R, X, Y)
    % R - promień okręgu
    % X - współrzędna x środka okręgu
    % Y - współrzędna y środka okręgu
    theta = linspace(0,2*pi);
    x = R*cos(theta) + X;
    y = R*sin(theta) + Y;
    plot(x,y)
end

