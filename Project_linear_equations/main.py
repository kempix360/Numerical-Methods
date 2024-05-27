import math
import time
import matplotlib.pyplot as plt


def create_A_b(a1, a2, a3, N):
    A = [[0] * N for _ in range(N)]
    for i in range(N):
        A[i][i] = a1
    for i in range(1, N):
        A[i][i - 1] = A[i - 1][i] = a2
    for i in range(2, N):
        A[i][i - 2] = A[i - 2][i] = a3

    # creating vector b
    b = [0.0] * N
    for i in range(N):
        b[i] = math.sin((i + 1) * (9 + 1))

    return A, b


def find_err_norm(A, b, x, N):
    max_err_norm = 0
    residual = [0] * N
    for i in range(N):
        for j in range(N):
            residual[i] += A[i][j] * x[j]

    for i in range(N):
        err_norm = math.fabs(b[i] - residual[i])
        if max_err_norm < err_norm:
            max_err_norm = err_norm

    return max_err_norm


def create_LU(A, N):
    L = [[0] * N for _ in range(N)]
    U = [[0] * N for _ in range(N)]

    for i in range(N):
        L[i][i] = 1

    for j in range(N):
        for i in range(N):
            sum_ = 0
            if i <= j:
                for k in range(i):
                    sum_ += L[i][k] * U[k][j]
                U[i][j] = A[i][j] - sum_
            else:
                for k in range(j):
                    sum_ += L[i][k] * U[k][j]
                L[i][j] = (A[i][j] - sum_) / U[j][j]

    return L, U


def forward_substitution(L, b, N):
    x = [0] * N
    for i in range(N):
        sum_ = 0
        for j in range(i):
            sum_ += L[i][j] * x[j]
        x[i] = (b[i] - sum_) / L[i][i]
    return x


def back_substitution(U, b, N):
    x = [0] * N
    x[-1] = b[-1] / U[-1][-1]
    for i in range(N - 2, -1, -1):
        sum_ = 0
        for j in range(i + 1, N):
            sum_ += U[i][j] * x[j]
        x[i] = (b[i] - sum_) / U[i][i]
    return x


def solve_direct(A, b, N):

    start_time = time.time()
    L, U = create_LU(A, N)
    y = forward_substitution(L, b, N)
    x = back_substitution(U, y, N)
    err_norm = find_err_norm(A, b, x, N)
    time_elapsed = time.time() - start_time

    return x, err_norm, time_elapsed


def solve_Jacobi(A, b, N):
    x = [0] * N
    err_norm = 1
    err_norm_vector = []
    iterations_vector = []
    iterations = 0

    start_time = time.time()
    while iterations < 100 and err_norm > 1E-9:
        prev_x = x.copy()
        for i in range(N):
            sum_ = 0
            for j in range(N):
                if j != i:
                    sum_ += A[i][j] * prev_x[j]
            x[i] = (b[i] - sum_) / A[i][i]

        err_norm = find_err_norm(A, b, x, N)
        err_norm_vector.append(err_norm)
        iterations += 1
        iterations_vector.append(iterations)

    time_elapsed = time.time() - start_time

    return x, err_norm_vector, time_elapsed, iterations_vector


def solve_Gauss_Seidel(A, b, N):
    x = [0] * N
    err_norm = 1
    err_norm_vector = []
    iterations_vector = []
    iterations = 0

    start_time = time.time()
    while iterations < 100 and err_norm > 1E-9:
        for i in range(N):
            sum_ = 0
            for j in range(N):
                if j != i:
                    sum_ += A[i][j] * x[j]
            x[i] = (b[i] - sum_) / A[i][i]

        err_norm = find_err_norm(A, b, x, N)
        err_norm_vector.append(err_norm)
        iterations += 1
        iterations_vector.append(iterations)

    time_elapsed = time.time() - start_time

    return x, err_norm_vector, time_elapsed, iterations_vector


# index: 197259
a1 = 7
a2 = -1
a3 = -1
N = 959

# task A

A, b = create_A_b(a1, a2, a3, N)

# task B
x_jacobi, err_norm_vector_jacobi, time_elapsed_jacobi, iterations_jacobi = solve_Jacobi(A, b, N)
x_gauss, err_norm_vector_gauss, time_elapsed_gauss, iterations_gauss = solve_Gauss_Seidel(A, b, N)
print("Task B:\n")

print("x jacobi = ", x_jacobi)
print("time jacobi = ", time_elapsed_jacobi)
print("err norm jacobi = ", err_norm_vector_jacobi[-1])
print("iterations jacobi = ", iterations_jacobi[-1])
print("x gauss = ", x_gauss)
print("time gauss = ", time_elapsed_gauss)
print("err norm gauss = ", err_norm_vector_gauss[-1])
print("iterations gauss = ", iterations_gauss[-1])

# plot Jacobi and Gauss-Seidel
plt.figure(figsize=(10, 6))

plt.plot(iterations_jacobi, err_norm_vector_jacobi, label='Jacobi', color='blue')
plt.plot(iterations_gauss, err_norm_vector_gauss, label='Gauss-Seidel', color='red')

plt.xlabel('Numery iteracji')
plt.ylabel('Wartości residuum')
plt.title('Norma błędu rezydualnego podczas kolejnych iteracji - metoda Jacobiego i Gaussa-Seidela')
plt.yscale('log')

plt.xticks(range(1, max(len(iterations_jacobi), len(iterations_gauss)) + 1))

plt.legend()
plt.grid(True)
plt.savefig(f'plot_task_B.png', dpi=1000, bbox_inches='tight')
plt.show()
#
# task C

a1 = 3
for i in range(N):
    A[i][i] = a1

x_jacobi, err_norm_vector_jacobi, time_elapsed_jacobi, iterations_jacobi = solve_Jacobi(A, b, N)
x_gauss, err_norm_vector_gauss, time_elapsed_gauss, iterations_gauss = solve_Gauss_Seidel(A, b, N)
print("----------------------")
print("Task C:\n")
print("x jacobi = ", x_jacobi)
print("time jacobi = ", time_elapsed_jacobi)
print("err norm jacobi = ", err_norm_vector_jacobi[-1])
print("iterations jacobi = ", iterations_jacobi[-1])
print("x gauss = ", x_gauss)
print("time gauss = ", time_elapsed_gauss)
print("err norm gauss = ", err_norm_vector_gauss[-1])
print("iterations gauss = ", iterations_gauss[-1])

# plot Jacobi and Gauss-Seidel
plt.figure(figsize=(10, 6))

plt.plot(iterations_jacobi, err_norm_vector_jacobi, label='Jacobi', color='blue')
plt.plot(iterations_gauss, err_norm_vector_gauss, label='Gauss-Seidel', color='red')

plt.xlabel('Numery iteracji')
plt.ylabel('Wartości residuum')
plt.title('Norma błędu rezydualnego podczas kolejnych iteracji - metoda Jacobiego i Gaussa-Seidela')
plt.yscale('log')

max_iterations = max(len(iterations_jacobi), len(iterations_gauss))
plt.xticks(range(0, max_iterations + 1, 5))

plt.legend()
plt.grid(True)
plt.savefig(f'plot_task_C.png', dpi=1000, bbox_inches='tight')
plt.show()

# task D

x_direct, err_norm_direct, time_elapsed_direct = solve_direct(A, b, N)
print("----------------------")
print("Task D:\n")
print("x direct = ", x_direct)
print("time direct = ", time_elapsed_direct)
print("err norm direct = ", err_norm_direct)

# task E
a1 = 7
a2 = -1
a3 = -1

N_array = [100, 250, 500, 1000, 1500, 2000, 3000]
times_direct = []
times_gauss = []
times_jacobi = []

for n in N_array:
    A, b = create_A_b(a1, a2, a3, n)
    _, _, time_elapsed_jacobi, _ = solve_Jacobi(A, b, n)
    _, _, time_elapsed_gauss, _ = solve_Gauss_Seidel(A, b, n)
    _, _, time_elapsed_direct = solve_direct(A, b, n)
    times_direct.append(time_elapsed_direct)
    times_gauss.append(time_elapsed_gauss)
    times_jacobi.append(time_elapsed_jacobi)

plt.figure(figsize=(10, 6))
plt.plot(N_array, times_direct, label='Metoda faktoryzacji LU', marker='o')
plt.plot(N_array, times_gauss, label='Gauss-Seidel', marker='o')
plt.plot(N_array, times_jacobi, label='Jacobi', marker='o')
plt.xlabel('Rozmiar N')
plt.ylabel('Czas wykonania (s)')
plt.title('Zależność czasu wykonania poszczególnych metod od rozmiaru N')
plt.legend()
plt.grid(True)
plt.xticks(range(0, max(N_array)+1, 250))
plt.savefig('plot_task_E.png', dpi=1000, bbox_inches='tight')
plt.show()
