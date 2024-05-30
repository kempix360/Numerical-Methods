import os
import matplotlib.pyplot as plt


def generate_original_data(x_values, y_values, terrain):
    plt.figure(figsize=(10, 6))
    plt.plot(x_values, y_values, label='Terrain Data')

    plt.xlabel('Distance')
    plt.ylabel('Height')
    plt.title('Original data')
    plt.legend()
    plt.grid(True)

    filename = "original_data.png"
    file_path = os.path.join("generated_plots", terrain, filename)
    plt.savefig(file_path)
    plt.show()


def generate_lagrange_plot(x, y, nodes_x, nodes_y, y_interpolated, terrain, _type):
    n = len(nodes_x)
    plt.figure(figsize=(10, 6))
    # Plot the original function
    plt.plot(x, y, label='Original data', zorder=1)

    # Plot the interpolated function
    plt.plot(x, y_interpolated, label='Lagrange interpolation', color='green', zorder=1)

    # plot the selected nodes
    plt.scatter(nodes_x, nodes_y, label='selected nodes', color='red', s=10, zorder=2)

    plt.yscale('log')
    plt.legend()
    plt.xlabel('Distance')
    plt.ylabel('Height')
    if _type == 'chebyshev':
        plt.title(f'Lagrange interpolation for {n} Chebyshev nodes using Chebyshev nodes')
    else:
        plt.title(f'Lagrange interpolation for {n} evenly spaced nodes')
    plt.grid(True)

    filename = f"lagrange_interpolation_{_type}_{n}.png"
    file_path = os.path.join("generated_plots", terrain, filename)
    plt.savefig(file_path)
    plt.show()


def generate_cubic_spline_plot(x, y, nodes_x, nodes_y, y_interpolated, terrain):
    n = len(nodes_x)
    plt.figure(figsize=(10, 6))
    # Plot the original function
    plt.plot(x, y, label='Original data', zorder=1)

    # Plot the interpolated function
    plt.plot(x, y_interpolated, label='Cubic spline interpolation', color='green', zorder=1)

    # plot the selected nodes
    plt.scatter(nodes_x, nodes_y, label='selected nodes', color='red', s=10, zorder=2)

    plt.yscale('log')
    plt.legend()
    plt.xlabel('Distance')
    plt.ylabel('Height')
    plt.title(f':Cubic spline interpolation for {n} evenly spaced nodes')
    plt.grid(True)

    filename = f"cubic_spline_interpolation_{n}.png"
    file_path = os.path.join("generated_plots", terrain, filename)
    plt.savefig(file_path)
    plt.show()
