import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

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

# Generate data
points = generate_shell_clusters(n_shells=4, k_per_shell=500, max_radius=5.0, noise_sd=0.2)

# Plot
fig = plt.figure(figsize=(8, 6))
ax = fig.add_subplot(111, projection='3d')
ax.scatter(points[:, 0], points[:, 1], points[:, 2], s=2, alpha=0.6)
ax.set_title("Concentric 3D Shell Clusters")
plt.show()