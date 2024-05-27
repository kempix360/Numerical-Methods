function [A, b, M, bm, x, err_norm, time, iterations, index_number] = solve_Jacobi(N)
    % A - macierz z równania macierzowego A * x = b
    % b - wektor prawej strony równania macierzowego A * x = b
    % M - macierz pomocnicza opisana w instrukcji do Laboratorium 3
    % bm - wektor pomocniczy opisany w instrukcji do Laboratorium 3
    % x - rozwiązanie równania macierzowego
    % err_norm - norma błędu rezydualnego rozwiązania x; err_norm = norm(A*x-b)
    % time - czas wyznaczenia rozwiązania x
    % iterations - liczba iteracji wykonana w procesie iteracyjnym metody Jacobiego
    % index_number - Twój numer indeksu
    
    index_number = 197259;
    L1 = mod(index_number, 10);
    
    % Wygenerowanie macierzy A i wektora b
    [A, b] = generate_matrix(N, L1);
    
    % Inicjalizacja wektora x oraz macierzy M
    x = ones(N, 1);
    M = zeros(N, N);
    
    % Obliczenie macierzy trójkątnej górnej (U), trójkątnej dolnej (L) i diagonalnej (D) z macierzy A
    U = triu(A, 1);
    L = tril(A, -1);
    D = diag(diag(A));
    
    % Obliczenie macierzy odwrotnej D^-1 oraz macierzy iteracyjnej M
    D_inv = diag(1 ./ diag(D));
    M = D_inv * (L + U);
    
    % Obliczenie wektora bm
    bm = D_inv * b;
    
    % Obliczenie przybliżonego rozwiązania x metodą Jacobiego
    tic;
    err_norm = inf;
    iterations = 0;
    while err_norm > 1E-12 && iterations < 1000
        x_new = M * x + bm;
        err_norm = norm(A * x_new - b);
        x = x_new;
        iterations = iterations + 1;
    end
    time = toc;
end
