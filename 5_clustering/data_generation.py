import numpy as np
import pandas as pd
import os

np.random.seed(123)

output_dir = "derived_data_1"

# Create directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

# Then save your file there

def generate_hypercube_clusters(n, k, side_length, noise_sd=1.0):
    """
    Generate n clusters, each with k points, in n-dimensional space.
    Each cluster center is located at a "positive corner" of an n-dimensional hypercube.
    
    Parameters:
    - n (int): Number of dimensions and clusters
    - k (int): Number of points per cluster
    - side_length (float): Side length of the hypercube
    - noise_sd (float): Standard deviation of Gaussian noise
    
    Returns:
    - data (np.ndarray): (n * k, n) array of generated points
    - labels (np.ndarray): (n * k,) array of cluster labels
    - centers (np.ndarray): (n, n) array of cluster centers
    """
    # Each cluster center is at a corner with one axis at side_length, others at 0
    centers = np.eye(n) * side_length  # shape: (n, n)
    # Generate points around each center
    data = []
    labels = []
    for i, center in enumerate(centers):
        # Generate k points around the center with Gaussian noise
        cluster_points = center + np.random.normal(loc=0.0, scale=noise_sd, size=(k, n))
        data.append(cluster_points)
        labels.extend([i] * k)

    data = np.vstack(data)        # Shape: (n * k, n)
    labels = np.array(labels)     # Shape: (n * k,)
    
    return data

df_dict = {}

for n in range(2, 7):
    for side_length in range(1, 11):
        key = f"{n}_{side_length}"
        df_dict[key] = generate_hypercube_clusters(n=n, k=100, side_length=side_length, noise_sd=1.0)
        col_names = [f"d{i+1}" for i in range(n)]
        
        # Create DataFrame
        df = pd.DataFrame(df_dict[key], columns=col_names)

        # Save to CSV
        filename = f"{output_dir}/df_{key}.csv"
        df.to_csv(filename, index=False)
        print(f"Saved {filename}")