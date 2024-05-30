from cmath import cos, pi
import numpy as np
from plotting_functions import *
from interpolation_func import *


def linspace(start, end, n):
    """
    Returns a list of n evenly spaced values between start and end.
    """

    if n == 0:
        return []
    if n == 1:
        return [start]

    return [start + (end - start) * i / (n - 1) for i in range(n)]


def round_to_int(values):
    return [int(round(v)) for v in values]


def chebyshev_nodes(start, end, n):
    """
    Returns a list of n Chebyshev nodes between start and end.
    """
    nodes = []
    for k in range(n):
        cos_value = cos((2 * k + 1) * pi / (2 * n))
        node = start + 0.5 * (end - start) * (1 + cos_value)
        nodes.append(node)
    return nodes


def getdata(directory, file_name):
    x = []
    y = []

    # Construct the full file path
    file_path = os.path.join(directory, file_name)

    # Open the file and read lines until the end
    with open(file_path, 'r') as file:
        while True:
            line = file.readline()
            if not line:
                break  # Exit loop if no more lines
            distance, height = line.strip().split(' ')
            x.append(float(distance))
            y.append(float(height))

    return x, y


def generate_interpolation_lagrange(x_values, y_values, n, title, _type):
    nodes_indices = []
    if _type == 'normal':
        nodes_indices = linspace(0, len(x_values) - 1, n)
        nodes_indices = round_to_int(nodes_indices)
    elif _type == 'chebyshev':
        nodes_indices = chebyshev_nodes(0, len(x_values) - 1, n)
        nodes_indices = np.round(nodes_indices).astype(int)

    nodes_x = [x_values[i] for i in nodes_indices]
    nodes_y = [y_values[i] for i in nodes_indices]
    y_interpolated = lagrange_interpolation(nodes_x, nodes_y, x_values)
    generate_lagrange_plot(x_values, y_values, nodes_x, nodes_y, y_interpolated, title, _type)


def generate_cubic_spline_interpolation(x_values, y_values, n, title):
    nodes_indices = linspace(0, len(x_values) - 1, n)
    nodes_indices = round_to_int(nodes_indices)

    nodes_x = [x_values[i] for i in nodes_indices]
    nodes_y = [y_values[i] for i in nodes_indices]
    y_interpolated = cubic_spline_interpolation(nodes_x, nodes_y, x_values)
    generate_cubic_spline_plot(x_values, y_values, nodes_x, nodes_y, y_interpolated, title)


if __name__ == '__main__':
    x_values, y_values = getdata("data", "glebia_challengera.txt")
    generate_original_data(x_values, y_values, 'glebia_challengera')

    generate_interpolation_lagrange(x_values, y_values, 15, 'glebia_challengera', 'normal')
    generate_interpolation_lagrange(x_values, y_values, 40, 'glebia_challengera', 'normal')
    generate_interpolation_lagrange(x_values, y_values, 80, 'glebia_challengera', 'normal')
    generate_interpolation_lagrange(x_values, y_values, 120, 'glebia_challengera', 'normal')

    generate_interpolation_lagrange(x_values, y_values, 15, 'glebia_challengera', 'chebyshev')
    generate_interpolation_lagrange(x_values, y_values, 40, 'glebia_challengera', 'chebyshev')
    generate_interpolation_lagrange(x_values, y_values, 80, 'glebia_challengera', 'chebyshev')
    generate_interpolation_lagrange(x_values, y_values, 120, 'glebia_challengera', 'chebyshev')

    generate_cubic_spline_interpolation(x_values, y_values, 15, 'glebia_challengera')
    generate_cubic_spline_interpolation(x_values, y_values, 40, 'glebia_challengera')
    generate_cubic_spline_interpolation(x_values, y_values, 80, 'glebia_challengera')
    generate_cubic_spline_interpolation(x_values, y_values, 120, 'glebia_challengera')
