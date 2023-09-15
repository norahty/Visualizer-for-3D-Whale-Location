# Visualizer for Whale Location in 3D

## Overview

<img width="551" alt="Screen Shot 2022-08-28 at 2 01 12 PM" src="https://github.com/norahty/Visualizer-for-3D-Whale-Location/assets/94091909/967d7843-42bb-47cf-bece-e2e14b40fb45">


This MATLAB code serves as a visualizer for whale location in 3D, taking input from the Locator program (previously developed). It uses the 2D rectangles of the estimated whale positions, color-coded if a whale was detected, to create 3D visualizations using the Julia Plotly package. The program consists of two main parts:

1. **Finding Perimeters**: The program identifies the 2D perimeter of the whale's estimated position and stores it. This perimeter is represented by a sequence of points, outlining the boundary of the detected area.

2. **Plotting in 3D**: Using the stored perimeters, the program leverages the Julia Plotly package to create 3D plots. Each connected component of the perimeter is plotted as a distinct shape in 3D space.

### MATLAB Code (search_cc_hole_no_separate_storage.m)

#### Inputs

- `param`: A 1x6 matrix describing the grid parameters.
  - `param(1, 1)`: x-coordinate of the lower-left corner of the grid.
  - `param(1, 2)`: y-coordinate of the lower-left corner of the grid.
  - `param(1, 3)`: Length of each horizontal edge.
  - `param(1, 4)`: Length of each vertical edge.
  - `param(1, 5)`: Number of edges horizontally.
  - `param(1, 6)`: Number of edges vertically.
- `occ`: A 1xN matrix representing the number of occupied bins in the region.

#### Outputs

- `all_ordered_vertex`: A cell array containing the ordered vertices of each connected component. Each cell represents one connected component and contains an array with each row representing a point [x, y].

## Visualizing in Julia

The provided Julia code allows you to visualize the detected whale positions in 3D. It reads data from a binary file (plt_data.bin) containing information about the coordinates of the detected positions. The data includes x, y, and z coordinates, as well as information about triangles (i, j, k) forming the surfaces.

### Setting Up the Visualization

- Azimuth (`azim`) and Elevation (`elev`) angles control the view in the x-y plane and the angle between the z-axis and the x-y plane, respectively.
- Three subplots are created, each with different views:
  1. The first subplot (`p1`) provides an angled view.
  2. The second subplot (`p2`) provides an overhead view from an alternate angle.
  3. The third subplot (`p3`) is a top-down view.

### Saving and Displaying

- The `size` function sets the size of the plots.
- The `figpath` variable specifies the path for saving the figure.

## Usage

1. Ensure you have MATLAB and Julia with the Plotly package installed.
2. Run the MATLAB code (search_cc_hole_no_separate_storage.m) to preprocess the data.
3. Place the resulting binary file (plt_data.bin) in the same directory as the Julia code.
4. Run the Julia code to generate 3D visualizations of whale positions.

Enjoy exploring whale locations in 3D!
