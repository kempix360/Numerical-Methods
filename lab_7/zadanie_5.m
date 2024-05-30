[lake_volume, x, y, z, zmin] = zadanie5();

function [lake_volume, x, y, z, zmin] = zadanie5()
    % Funkcja zadanie5 wyznacza objętość jeziora metodą Monte Carlo.
    %
    %   lake_volume - objętość jeziora wyznaczona metodą Monte Carlo
    %
    %   x - wektor wierszowy, który zawiera współrzędne x wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   y - wektor wierszowy, który zawiera współrzędne y wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   z - wektor wierszowy, który zawiera współrzędne z wszystkich punktów
    %       wylosowanych w tej funkcji w celu wyznaczenia obliczanej całki.
    %
    %   zmin - minimalna dopuszczalna wartość współrzędnej z losowanych punktów
    N = 1e6;
    x = 100*rand(1,N); % [m]
    y = 100*rand(1,N); % [m]
    zmin = -45 - (55 * rand());
    z = zmin + (0 - zmin) * rand(1, N);

    % Sprawdź, które punkty znajdują się w jeziorze
    N_inside = 0;
    for i = 1:N
        lake_depth = get_lake_depth(x(i), y(i));
        if z(i) > lake_depth
            N_inside = N_inside + 1;
        end
    end

    % Objętość bryły otaczającej
    V = 100 * 100 * (0 - zmin);

    % Oblicz objętość jeziora
    lake_volume = (N_inside / N) * V;
end

function f = get_lake_depth(x, y)
    x = x/100;
    y = y/100;

    w1=5; a1=30; x1=0.2; y1=0.3;
    w2=6; a2=40; x2=0.6; y2=1.0;
    w3=7; a3=50; x3=0.9; y3=0.5;
    w4=6; a4=40; x4=0.6; y4=0.1;
    w5=7; a5=70; x5=0.1; y5=0.95;
    w6=-5; a6=10; x6=0.5; y6=0.5;
    f=10 + w1*exp(-a1*((x-x1).^2+(y-y1).^2))+w2*exp(-a2*((x-x2).^2+(y-y2).^2))+w3*exp(-a3*((x-x3).^2+(y-y3).^2))+w4*exp(-a4*((x-x4).^2+(y-y4).^2))+w5*exp(-a5*((x-x5).^2+(y-y5).^2))+w6*exp(-a6*((x-x6).^2+(y-y6).^2));
    f = f - 9.5;
    f = f * 10;
    f(f>0) = 0;
end