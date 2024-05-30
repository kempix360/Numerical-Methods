######################################
# cubic spline interpolation functions

def cubic_spline_interpolation(x_values, y_values, x_points):

    A, b = construct_tridiagonal_matrix(x_values, y_values)

    # Solve the tridiagonal system to find m (second derivatives)
    m = solve_tridiagonal(A, b)

    # Calculate differences between x values
    h = [x_values[i + 1] - x_values[i] for i in range(len(x_values) - 1)]

    # Calculate differences between y values
    delta = [y_values[i + 1] - y_values[i] for i in range(len(y_values) - 1)]

    # Number of points
    n = len(x_values)

    # Calculate coefficients of cubic polynomials
    a = y_values[:-1]
    b = [(delta[i] / h[i]) - h[i] * (2 * m[i] + m[i + 1]) / 6 for i in range(n - 1)]
    c = [m[i] / 2 for i in range(n - 1)]
    d = [(m[i + 1] - m[i]) / (6 * h[i]) for i in range(n - 1)]

    # Initialize array for interpolated y values
    y_interpolated = [0.0] * len(x_points)

    # Interpolate y values using cubic polynomials
    for i in range(len(x_values) - 1):
        for j, x in enumerate(x_points):
            if x_values[i] <= x <= x_values[i + 1]:
                y_interpolated[j] = (a[i] +
                                     b[i] * (x - x_values[i]) +
                                     c[i] * (x - x_values[i]) ** 2 +
                                     d[i] * (x - x_values[i]) ** 3)

    return y_interpolated


def solve_tridiagonal(A, B):
    n = len(B)
    for i in range(1, n):
        w = A[i][i - 1] / A[i - 1][i - 1]
        A[i][i] -= w * A[i - 1][i]
        B[i] -= w * B[i - 1]

    m = [0.0] * n
    m[-1] = B[-1] / A[-1][-1]
    for i in range(n - 2, -1, -1):
        m[i] = (B[i] - A[i][i + 1] * m[i + 1]) / A[i][i]

    return m


def construct_tridiagonal_matrix(x_values, y_values):
    # Calculate differences between x values
    h = [x_values[i + 1] - x_values[i] for i in range(len(x_values) - 1)]

    # Calculate differences between y values
    delta = [y_values[i + 1] - y_values[i] for i in range(len(y_values) - 1)]

    # Number of points
    n = len(x_values)

    # Initialize arrays for tridiagonal matrix
    A = [[0.0] * n for _ in range(n)]
    b = [0.0] * n

    # Fill the tridiagonal matrix
    for i in range(1, n - 1):
        A[i][i - 1] = h[i - 1]
        A[i][i] = 2 * (h[i - 1] + h[i])
        A[i][i + 1] = h[i]
        b[i] = 6 * ((delta[i] / h[i]) - (delta[i - 1] / h[i - 1]))

    A[0][0] = A[n - 1][n - 1] = 1  # Natural spline boundary conditions

    return A, b


#################################
# Lagrange interpolation function

def lagrange_interpolation(nodes_x, nodes_y, x_values):
    y_interpolated = []
    for x in x_values:
        y = 0.0
        for i, yi in enumerate(nodes_y):
            term = yi
            xi = nodes_x[i]
            for j, xj in enumerate(nodes_x):
                if j != i and xi != xj:
                    term *= (x - xj) / (xi - xj)
            y += term
        y_interpolated.append(y)

    return y_interpolated