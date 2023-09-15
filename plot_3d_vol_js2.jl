# Tianyang Han attempt at 3D plots
#specify package
# using PlotlyJS, DataFrames
using Plots

#read data from binary file into data
data = Array{Float32}(undef, 1572, 6)
io = open("plt_data.bin", "r")
read!(io, data);
close(io)

# Extract x, y, z,  i, j, k and convert to  needed types
x = convert(Vector{Float64}, data[:, 1]);
y = convert(Vector{Float64}, data[:, 2]);
z = convert(Vector{Float64}, data[:, 3]);
i = convert(Vector{Int64}, data[:, 4]);
j = convert(Vector{Int64}, data[:, 5]);
k = convert(Vector{Int64}, data[:, 6]);


#= test case
x = [0., 1., 2., 0.];
y = [0., 0., 1., 2.];
z = [0., 2., 0., 1.];
i = [0, 0, 0, 1]
j = [1, 2, 3, 2]
k = [2, 3, 1, 3]

x = convert(Vector{Float64},[0., 1., 2., 0.]);
y = convert(Vector{Float64},[0., 0., 1., 2.]);
z = convert(Vector{Float64},[0., 2., 0., 1.]);
i = convert(Vector{Int64},[0, 0, 0, 1]);
j = convert(Vector{Int64},[1, 2, 3, 2]);
k = convert(Vector{Int64},[2, 3, 1, 3]);

=#

# Set plot layout
l = @layout [a; b; c];

#-------------------------------------------------------------------------------------------------
# Make first subplot
#-------------------------------------------------------------------------------------------------
# Set  azimuth in degrees (angle in x-y plane  from x axis)
azim = 15;
# Set elevation in degrees (angle between z axis and x-y plane). 90 is top view
elev = 20;


p1 = Plots.mesh3d(x, y, z,
  connections=(i, j, k),
  title="triangles",
  xlabel="x", ylabel="y", zlabel="z", opacity=0.6,
  label="view1",
  camera=(azim, elev))

#-------------------------------------------------------------------------------------------------
# Plot receivers and target
#-------------------------------------------------------------------------------------------------

# p1= Plots.scatter!([xtgt], [ytgt], [ztgt],
# markersize = 7,
# camera=(azim , elev),
# color = "blue")

#-------------------------------------------------------------------------------------------------
# Make second subplot
#-------------------------------------------------------------------------------------------------
# Set  azimuth in degrees (angle in x-y plane  from x axis)
azim = 80;
# Set elevation in degrees (angle between z axis and x-y plane). 90 is top view
elev = 20;
p2 = Plots.mesh3d(x, y, z;
  label="view2",
  connections=(i, j, k), title="triangles", xlabel="x", ylabel="y", zlabel="z", dpi=600, opacity=1, camera=(azim, elev))

#-------------------------------------------------------------------------------------------------
# Make third subplot
#-------------------------------------------------------------------------------------------------
# Set  azimuth in degrees (angle in x-y plane  from x axis)
azim = 0;
# Set elevation in degrees (angle between z axis and x-y plane). 90 is top view
elev = 90;
p3 = Plots.mesh3d(x, y, z;
  label="view3",
  connections=(i, j, k), title="triangles", xlabel="x", ylabel="y", zlabel="z", dpi=600, opacity=1, camera=(azim, elev))


#-------------------------------------------------------------------------------------------------
# Plot figure to screen
#-------------------------------------------------------------------------------------------------
figg = Plots.plot(p1, p2, p3, layout=l);
Plots.plot!(size=(2000, 2000))


#-------------------------------------------------------------------------------------------------
# Plot figure to screen
#-------------------------------------------------------------------------------------------------



# Save figure
# store figure. Specify the path on different computers when calling
figpath = "/Users/hantao/bin/"
png(figg, figpath * "fig1")
