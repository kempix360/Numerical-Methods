function [xsolution,ysolution,iterations,xtab,xdif] = bisection_method(a,b,max_iterations,ytolerance,fun)
% a - lewa granica przedziału poszukiwań miejsca zerowego
% b - prawa granica przedziału poszukiwań miejsca zerowego
% max_iterations - maksymalna liczba iteracji działania metody bisekcji
% ytolerance - wartość abs(fun(xsolution)) powinna być mniejsza niż ytolerance
% fun - nazwa funkcji, której miejsce zerowe będzie wyznaczane
%
% xsolution - obliczone miejsce zerowe
% ysolution - wartość fun(xsolution)
% iterations - liczba iteracji wykonana w celu wyznaczenia xsolution
% xtab - wektor z kolejnymi kandydatami na miejsce zerowe, począwszy od xtab(1)= (a+b)/2
% xdiff - wektor wartości bezwzględnych z różnic pomiędzy i-tym oraz (i+1)-ym elementem wektora xtab; xdiff(1) = abs(xtab(2)-xtab(1));

iterations = 0;
xtab = zeros(max_iterations);
xdif = zeros(max_iterations);

while iterations < max_iterations
    iterations = iterations + 1;
    c = (a+b)/2;
    xtab(iterations) = c;
    if (iterations > 1)
        xdif(iterations - 1) = abs(xtab(iterations)-xtab(iterations - 1));
    end

    if abs(fun(c)) < ytolerance
        break;
    elseif fun(a)*fun(c) < 0
        b = c;
    else
        a = c;
    end
end

xsolution = c;
ysolution = fun(xsolution);
xtab = xtab(1:iterations)';
xdif = xdif(1:iterations-1)';
end