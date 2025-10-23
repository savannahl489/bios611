import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import plotly.graph_objects as go
import os
import pandas as pd

np.random.seed(123)
output_dir = "derived_data_2"

# Create directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

def generate_shell_clusters(n_shells, k_per_shell, max_radius, noise_sd=0.1):
    """
    Generate 3D points arranged in concentric spherical shells with Gaussian thickness.

    Args:
        n_shells (int): Number of concentric shells.
        k_per_shell (int): Number of points per shell.
        max_radius (float): Maximum shell radius.
        noise_sd (float): Standard deviation of Gaussian noise (thickness).

    Returns:
        np.ndarray: Array of shape (n_shells * k_per_shell, 3) with 3D coordinates.
    """
    # Ensure non-zero inner radius
    min_radius = 0.1

    # Evenly spaced shell radii
    shell_radii = np.linspace(min_radius, max_radius, n_shells)

    # Store all points here
    all_points = []

    for r in shell_radii:
        # Sample spherical angles
        theta = np.arccos(1 - 2 * np.random.rand(k_per_shell))  # Uniform on sphere
        phi = 2 * np.pi * np.random.rand(k_per_shell)

        # Add Gaussian noise to radius
        noisy_radii = r + np.random.normal(0, noise_sd, size=k_per_shell)

        # Convert spherical to Cartesian
        x = noisy_radii * np.sin(theta) * np.cos(phi)
        y = noisy_radii * np.sin(theta) * np.sin(phi)
        z = noisy_radii * np.cos(theta)

        # Stack points
        shell_points = np.vstack((x, y, z)).T
        all_points.append(shell_points)

    # Combine all shell points into a single array
    return np.vstack(all_points)

# Generate sample data
points = generate_shell_clusters(n_shells=4, k_per_shell=500, max_radius=5.0, noise_sd=0.2)

# To make sure data has correct structure, generate plot:
def save_interactive_3d_plot(points, filename="figures_2/shell_clusters.html"):
    fig = go.Figure(
        data=[
            go.Scatter3d(
                x=points[:, 0],
                y=points[:, 1],
                z=points[:, 2],
                mode='markers',
                marker=dict(
                    size=2,
                    color='blue',
                    opacity=0.6
                )
            )
        ]
    )
    fig.update_layout(
        title="Concentric 3D Shell Clusters",
        scene=dict(
            xaxis_title='X',
            yaxis_title='Y',
            zaxis_title='Z'
        ),
        margin=dict(l=0, r=0, b=0, t=40)
    )

    # Save as interactive HTML
    fig.write_html(filename)
    print(f"Interactive plot saved as '{filename}'")


save_interactive_3d_plot(points, "shell_clusters.html")

# To generate the dataset for simulation and save as CSV:
df_dict = {}

for max_radius in range(10, -1, -1):

    key = f"_{max_radius}"
    df_dict[key] = generate_shell_clusters(n_shells=4, k_per_shell=100, max_radius=max_radius, noise_sd=0.1)
    col_names = [f"d{i+1}" for i in range(3)]

    # Create DataFrame
    df = pd.DataFrame(df_dict[key], columns=col_names)

    # Save to CSV
    filename = f"{output_dir}/df_{key}.csv"
    df.to_csv(filename, index=False)
    print(f"Saved {filename}")