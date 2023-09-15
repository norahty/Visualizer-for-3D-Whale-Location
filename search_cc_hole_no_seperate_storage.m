% Finds all the connected components of the graph and output the vertices of each connected component in counter
% clockwise order.
% 
% Author: Tianyang(Nora) Han
%
% INPUTS
% param                 1 x 6 matrix. Is params as define_rect_regions.m. Summarizing:
%
%                       param(1, 1) x_min the lower left corner of x axis of the cartesian coordinate of the grid
%                       param(1, 2) y_min the lower left corner of the grid
%                       param(1, 3) dx    the length of each horizontal edge
%                       param(1, 4) dy    the length of each vertical edge
%                       param(1, 5) nx    the number of edges horizontally
%                       param(1, 6) ny    the number of edges vertically
%
% occ                   1 x nocc. # of occupied bins in the region. See defined_rect_regions.m
%         
%       
% OUTPUTS
%
% all_ordered_vertex    1 x nconn. nconn is the # of connected components. 
%                       cell array with each cell being one array(# points x 2) representing a connected component, 
%                       each row represents a point [x, y];
%                       and each array start from the upper right corner and goes counter clockwise around the connected
%                       component without repeating any point.
%
%                       Some connected components can be inside other connected components. For example, one connected
%                       component could be the periphery and another connected component could be an interior border of
%                       a hole.
%
function [all_ordered_vertex] = search_cc_hole_no_seperate_storage(param, occ)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preliminary Steps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
progname = 'search_cc_hole_no_seperate_storage.m';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test Case
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dotest = 0;
if dotest == 1
    fprintf(1, '%s: Test case. Press enter to continue \n', progname); pause
    occ = [1, 2, 3, 4, 6, 7, 8, 9];
    param = [1, 1, 1, 1, 3, 3];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unpack param
x_min = param(1, 1);
y_min = param(1, 2);
dx = param(1, 3);
dy = param(1, 4);
nx = param(1, 5);
ny = param(1, 6);

% initializing discovered list, adjacency list, and parent list for BFS(Breadth First Search).
% A discovered list is a list containing all the points in the graph that have been visited(searched).
% The points in the discovered list may belong to the same or different connected components.
% Here we treat each bin as a point in the graph we are doing BFS on.
disc = NaN(1, nx*ny);

adj = NaN(nx*ny, 4);

parent = NaN(nx*ny, 1);


% store information from param to adjacency list. See detailed Perimeter Notes(PN) 1.1
for v = occ
    if mod(v, nx) ~= 0 && ismember(v+1, occ)
        adj(v, 1) = v+1;
    end
    if mod(v, nx) ~= 1 && ismember(v-1, occ)
        adj(v, 2) = v-1;
    end
    if ismember(v+nx, occ)
        adj(v, 3) = v+nx;
    end
    if ismember(v-nx, occ)
        adj(v, 4) = v-nx;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BFS  This part of code has refereced CIS 1210 class note at the University of Pennsylvania
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% import java data structures to save runtime
import java.util.LinkedList;
import java.util.ArrayList;

% initialize an array list to store all the connected component. See detailed PN 1.2.1
all_cc = ArrayList();

% initialize a linked list to store all the starting vertex of each connected component.
cc_start = LinkedList();

% initialize a linked list to store if a vertex has been discovered
for v = occ
    disc(1, v) = 0;
end

% make copy of occ to trace bfs status
trac = occ;
while ~isempty(trac)

    % set source vertex as the first vertex of the trac
    src = trac(1, 1);
    cc_start.add(src);
    trac = trac(trac~=src);

    % start queue for pop and push
    q = LinkedList();
    q.add(src);
    k = LinkedList();
    k.add(src);

    % mark that we have discovered the source
    disc(1, src) = 1;

    % start searching
    while ~q.isEmpty()
        v = q.remove();
        for u = adj(v, :)
            if ~isnan(u) && disc(1, u) == 0
                disc(1, u) = 1;
                q.add(u);
                k.add(u);
                trac = trac(trac~=u);
                parent(u, 1) = v;
            end
        end
    end
    all_cc.add(k);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get Edges(From here on edge refers to the square's perimeter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create an arraylist to store all the edges of each cc
all_edges = ArrayList();

% find the total number of edges produced
total_edge_num = ny * (2*nx + 1) + nx;

% start updating
while ~all_cc.isEmpty()
    % check one cc at a time
    curr_cc = all_cc.remove(0);

    % initialize edge map
    curr_edge = zeros(total_edge_num, 1);

    % go through the current cc
    while ~curr_cc.isEmpty
        % get the current edge number we are looking at
        curr_num = curr_cc.remove();
        
        if mod(curr_num, nx) ~= 0 % for normal square(vertex) we convert the suqare number into edge number
            a = mod(curr_num, nx) + floor(curr_num/nx) * (2*nx +1); %see the explaination of this formula in PN 2.1
        else % special case for right most vertical bin
            a = nx + (curr_num/nx - 1) * (2*nx +1);
        end
        
        
        b = a + nx;
        c = a + nx + 1;
        d = a + 2*nx + 1;

        % if the edge is stored as not seen(0), we change it into seen(1), otherwise, we store it as not seen (0), see
        % detailed explaination in PN 2.2
        
        if curr_edge(a, 1) == 0
            curr_edge(a, 1) = 1;
        else
            curr_edge(a, 1) = 0;
        end

        if curr_edge(b, 1) == 0
            curr_edge(b, 1) = 1;
        else
            curr_edge(b, 1) = 0;
        end

        if curr_edge(c, 1) == 0
            curr_edge(c, 1) = 1;
        else
            curr_edge(c, 1) = 0;
        end

        if curr_edge(d, 1) == 0
            curr_edge(d, 1) = 1;
        else
            curr_edge(d, 1) = 0;
        end
    end
    
    % initialize a linked list to store all perimeter edges
    curr_edge_array = LinkedList();

    % store it
    for i = 1 : total_edge_num
        if curr_edge(i, 1) == 1
            curr_edge_array.add(i);
        end
    end

    %update all_edges
    all_edges.add(curr_edge_array);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sort
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%create an arraylist to store all the edges of each cc
all_ordered_edges = ArrayList();

while ~all_edges.isEmpty()
    %get first array
    curr_sort_edges = all_edges.remove(0);

    %find max
    start = 0;
    temp_edge_array = curr_sort_edges(:, :);
    

    %initialize selected edges list
    occ_edges = zeros(total_edge_num, 1);

    %initialize order arraylist
    curr_order = LinkedList();

    %find the edge with the largest edge number, we start storing the perimeter in 
    while ~temp_edge_array.isEmpty()
        temp_num = temp_edge_array.remove();
        occ_edges(temp_num, 1) = 1;
        if temp_num>start
            start = temp_num;
        end
    end

    curr_search = start;
    curr_order.add(start);
    occ_edges(start, 1) = 0;

    %start search
    while sum(occ_edges)~=0

        %horizontal
        if mod(curr_search, (2*nx+1)) > 0 && mod(curr_search, (2*nx+1)) < nx+1 && mod(curr_search, (2*nx+1)) ~= 1 && curr_search - 1 > 0 && occ_edges(curr_search - 1, 1) == 1
            curr_search = curr_search - 1;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif mod(curr_search, (2*nx+1)) > 0 && mod(curr_search, (2*nx+1)) < nx+1 && curr_search + nx <= total_edge_num && occ_edges(curr_search + nx, 1) == 1
            curr_search = curr_search + nx;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);


        elseif mod(curr_search, (2*nx+1)) > 0 && mod(curr_search, (2*nx+1)) < nx+1 && curr_search - (nx+1) > 0 && occ_edges(curr_search - (nx+1), 1) == 1
            curr_search = curr_search - (nx+1);
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif mod(curr_search, (2*nx+1)) > 0 && mod(curr_search, (2*nx+1)) < nx+1 && curr_search + 1 <= total_edge_num && occ_edges(curr_search + 1, 1) == 1
            curr_search = curr_search + 1;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif mod(curr_search, (2*nx+1)) > 0 && mod(curr_search, (2*nx+1)) < nx+1 && curr_search + nx + 1 <= total_edge_num && occ_edges(curr_search + nx + 1, 1) == 1
            curr_search = curr_search + nx + 1;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif mod(curr_search, (2*nx+1)) > 0 && mod(curr_search, (2*nx+1)) < nx+1 && curr_search -nx > 0 && occ_edges(curr_search - nx, 1) == 1
            curr_search = curr_search - nx;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

            % vertical

        elseif mod(curr_search, 2*nx+1) ~= 0 && curr_search - nx > 0 && occ_edges((curr_search - nx), 1) == 1
            curr_search = curr_search - nx;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif mod(curr_search, 2*nx+1) ~= (nx+1) && curr_search - nx - 1 > 0 && occ_edges((curr_search - nx - 1), 1) == 1
            curr_search = curr_search - nx - 1;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif curr_search - 2*nx - 1 > 0 && occ_edges((curr_search - 2*nx - 1), 1) == 1
            curr_search = curr_search - 2*nx - 1;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif mod(curr_search, 2*nx+1) ~= (nx+1) && curr_search + nx > 0 && occ_edges((curr_search + nx), 1) == 1
            curr_search = curr_search + nx;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif mod(curr_search, 2*nx+1) ~= 0 && curr_search + nx + 1 <= total_edge_num && occ_edges((curr_search + nx + 1), 1) == 1
            curr_search = curr_search + nx + 1;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif curr_search + 2*nx + 1 <= total_edge_num && occ_edges((curr_search + 2*nx + 1), 1) == 1
            curr_search = curr_search + 2*nx + 1;
            occ_edges(curr_search, 1) = 0;
            curr_order.add(curr_search);

        elseif curr_search + nx == start
            start = find(occ_edges, 1, "last");
            curr_search = start;
            curr_order.add(curr_search);
            occ_edges(curr_search, 1) = 0;
        end
    end

    all_ordered_edges.add(curr_order);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_ordered_vertex = {all_ordered_edges.size()};
%
j = 0;
while ~all_ordered_edges.isEmpty()
    trans_cc_edges = all_ordered_edges.remove(0);
    trans_cc_vertices = zeros(trans_cc_edges.size(), 2);

    first_trans_edge = trans_cc_edges.remove();

    num = mod(first_trans_edge, 2*nx+1);
    x_f = x_min + (num-1)*dx;
    x_s = x_min + (num)*dx;

    num_y = floor(first_trans_edge/(2*nx+1));
    y = y_min + num_y*dy;

    trans_cc_vertices(1, :) = [x_s, y];
    trans_cc_vertices(2, :) =[x_f, y];
    curr_start = 1;

    i = 2;
    while ~trans_cc_edges.isEmpty()
        curr_trans_edge = trans_cc_edges.remove();
        %horizontal
        if mod(curr_trans_edge, (2*nx+1)) > 0 && mod(curr_trans_edge, (2*nx+1)) < nx+1

            num = mod(curr_trans_edge, 2*nx+1);
            x_f = x_min + (num-1)*dx;
            x_s = x_min + (num)*dx;

            num_y = floor(curr_trans_edge/(2*nx+1));
            y = y_min + num_y*dy;

            if trans_cc_vertices(i, 1) ~= x_s
                trans_cc_vertices(i+1, :) = [x_s, y];
            end

            if trans_cc_vertices(i, 1) ~= x_f
                trans_cc_vertices(i+1, :) =[x_f, y];

            end
            i = i + 1;
        %vertical
        else
            if mod(curr_trans_edge, 2*nx+1) == 0
                num = nx;
            else
                num = mod(curr_trans_edge, 2*nx+1) - (nx+1);
            end

            x = x_min + num * dx;

            if mod(curr_trans_edge, 2*nx+1) == 0
                num_y = curr_trans_edge/(2*nx+1) - 1;
            else
                num_y = floor(curr_trans_edge/(2*nx+1));
            end

            y_f = y_min + (num_y)*dy;
            y_s = y_min + (num_y+1)*dy;

            if trans_cc_vertices(i, 2) ~= y_s
                trans_cc_vertices(i+1, :) = [x, y_s];
            end

            if trans_cc_vertices(i, 2) ~= y_f
                trans_cc_vertices(i+1, :) =[x, y_f];

            end
            i = i + 1;
        end
        if all(trans_cc_vertices(i, :) == trans_cc_vertices(curr_start, :)) && ~trans_cc_edges.isEmpty()
            curr_start = i;
            start_trans_edge = trans_cc_edges.remove();

            num = mod(start_trans_edge, 2*nx+1);
            x_f = x_min + (num-1)*dx;
            x_s = x_min + (num)*dx;

            num_y = floor(start_trans_edge/(2*nx+1));
            y = y_min + num_y*dy;

            trans_cc_vertices(curr_start, :) = [x_s, y];
            trans_cc_vertices(curr_start+1, :) =[x_f, y];
            i = i + 1;
            
        end

    end
    j = j + 1;
    trans_cc_vertices(end, :) = [];
    all_ordered_vertex{j} = trans_cc_vertices;
end


