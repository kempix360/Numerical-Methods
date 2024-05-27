function [A, b, M, bm, x, err_norm, time, iterations, index_number] = solve_Gauss_Seidel(N)
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
    
    % Obliczenie macierzy M
    M = -(D+L)\(U);
    
    % Obliczenie wektora bm
    bm = (D+L)\b;

    % Obliczenie przybliżonego rozwiązania x metodą Jacobiego
    tic;
    err_norm = 1;
    iterations = 0;
    while iterations < 1000 && err_norm > 1E-5
        x = M*x + bm;
        err_norm = norm(A*x - b);
        iterations = iterations + 1;
    end
    time = toc;
end
