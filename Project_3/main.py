from cmath import cos, pi
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
    return [(start + end) / 2 + (end - start) / 2 * cos((2 * i + 1) * pi / (2 * n)) for i in range(n)][::-1]


def get_selection_points(selected_values, nodes):
    # Find the closest nodes to correct_nodes from nodes.
    result = []
    for point in selected_values:
        closest_point = min(nodes, key=lambda node: abs(node[0] - point))
        result.append(closest_point)
            
    return result


def getdata(directory, file_name):
    nodes = []

    # Construct the full file path
    file_path = os.path.join(directory, file_name)

    # Open the file and read lines until the end
    with open(file_path, 'r') as file:
        while True:
            line = file.readline()
            if not line:
                break  # Exit loop if no more lines
            distance, height = map(float, line.strip().split(' '))
            nodes.append((distance, height))

    return nodes


def generate_interpolation_lagrange(nodes, n, title, _type):
    selected_points = []
    if _type == 'normal':
        selection = linspace(nodes[0][0], nodes[-1][0], n)
        selected_points = get_selection_points(selection, nodes)
    elif _type == 'chebyshev':
        selection = chebyshev_nodes(nodes[0][0], nodes[-1][0], n)
        selected_points = get_selection_points(selection, nodes)

    y_interpolated = lagrange_interpolation(selected_points, nodes)
    generate_lagrange_plot(nodes, selected_points, y_interpolated, title, _type)


def generate_cubic_spline_interpolation(nodes, n, title):
    selection = linspace(nodes[0][0], nodes[-1][0], n)
    selected_points = get_selection_points(selection, nodes)

    y_interpolated = cubic_spline_interpolation(selected_points, nodes)
    generate_cubic_spline_plot(nodes, selected_points, y_interpolated, title)


if __name__ == '__main__':
    nodes = getdata("data", "ulm_lugano.txt")
    # generate_original_data(nodes, 'chelm')

    generate_interpolation_lagrange(nodes, 110, 'ulm_lugano', 'normal')
    # generate_interpolation_lagrange(nodes, 10, 'chelm', 'normal')
    # generate_interpolation_lagrange(nodes, 20, 'chelm', 'normal')
    # generate_interpolation_lagrange(nodes, 120, 'chelm', 'normal')

    generate_interpolation_lagrange(nodes, 110, 'ulm_lugano', 'chebyshev')
    # generate_interpolation_lagrange(nodes, 60, 'chelm', 'chebyshev')
    # generate_interpolation_lagrange(nodes, 50, 'chelm', 'chebyshev')

    generate_cubic_spline_interpolation(nodes, 110, 'ulm_lugano')
    # generate_cubic_spline_interpolation(nodes, 40, 'chelm')
    # generate_cubic_spline_interpolation(nodes, 80, 'chelm')
    # generate_cubic_spline_interpolation(nodes, 120, 'chelm')
