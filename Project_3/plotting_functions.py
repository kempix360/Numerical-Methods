import os
import matplotlib.pyplot as plt


def generate_original_data(nodes, terrain):
    x_values = [node[0] for node in nodes]
    y_values = [node[1] for node in nodes]

    plt.figure(figsize=(10, 6))
    plt.plot(x_values, y_values, label='Terrain Data')

    plt.xlabel('Distance')
    plt.ylabel('Height')
    plt.title('Original data')
    plt.legend()
    plt.grid(True)

    filename = f"original_data_{terrain}.png"
    file_path = os.path.join("generated_plots", terrain, filename)
    plt.savefig(file_path)
    plt.show()


def generate_lagrange_plot(nodes, selected_points, y_interpolated, terrain, _type):
    x = [node[0] for node in nodes]
    y = [node[1] for node in nodes]

    n = len(selected_points)
    plt.figure(figsize=(10, 6))
    # Plot the original function
    plt.plot(x, y, label='Original data', zorder=1)

    # Plot the interpolated function
    plt.plot(x, y_interpolated, label='Lagrange interpolation', color='green', zorder=1)

    points_x = [point[0] for point in selected_points]
    points_y = [point[1] for point in selected_points]
    # plot the selected nodes
    plt.scatter(points_x, points_y, label='selected nodes', color='red', s=10, zorder=2)

    plt.legend()
    plt.xlabel('Distance')
    plt.ylabel('Height')
    if _type == 'chebyshev':
        plt.title(f'Lagrange interpolation for {n} Chebyshev nodes')
    else:
        plt.title(f'Lagrange interpolation for {n} evenly spaced nodes')
    plt.grid(True)
    plt.subplots_adjust(left=0.1, right=0.95, top=0.90, bottom=0.1)

    filename = f"lagrange_interpolation_{_type}_{n}_{terrain}.png"
    file_path = os.path.join("generated_plots", terrain, filename)
    plt.savefig(file_path)
    plt.show()


def generate_cubic_spline_plot(nodes, selected_points, y_interpolated, terrain):
    x = [node[0] for node in nodes]
    y = [node[1] for node in nodes]

    n = len(selected_points)
    plt.figure(figsize=(10, 6))
    # Plot the original function
    plt.plot(x, y, label='Original data', zorder=1)

    # Plot the interpolated function
    plt.plot(x, y_interpolated, label='Cubic spline interpolation', color='green', zorder=1)

    points_x = [point[0] for point in selected_points]
    points_y = [point[1] for point in selected_points]
    # plot the selected nodes
    plt.scatter(points_x, points_y, label='selected nodes', color='red', s=10, zorder=2)

    plt.legend()
    plt.xlabel('Distance')
    plt.ylabel('Height')
    plt.title(f'Cubic spline interpolation for {n} evenly spaced nodes')
    plt.grid(True)
    plt.subplots_adjust(left=0.1, right=0.95, top=0.90, bottom=0.1)

    filename = f"cubic_spline_interpolation_{n}_{terrain}.png"
    file_path = os.path.join("generated_plots", terrain, filename)
    plt.savefig(file_path)
    plt.show()
