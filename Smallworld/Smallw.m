clc; 
clear; 
close all;

% Watts-Strogatz graph parameters
N = 500;       % Number of nodes
K = 4;         % Average node degree
beta = 0.1;   % Rewiring probability

% Generate Watts-Strogatz graph
G = WattsStrogatz(N, K, beta);

% Compute distances between all node
distance_matrix = distances(G);

% Find the pair of nodes with maximum distance
[max_distance, idx] = max(distance_matrix(:));
[start_node, end_node] = ind2sub(size(distance_matrix), idx);

% Plot the graph
h = plot(G );
title(sprintf('Farthest Nodes - Distance %d Start node %d End Node %d', ...
    max_distance, start_node, end_node));

% Compute the shortest path between the farthest nodes
shortest_path = shortestpath(G, start_node, end_node);

hold on;

% Highlight the shortest path
highlight(h, shortest_path, 'NodeColor', 'g', 'EdgeColor', 'm', 'LineWidth', 3, 'MarkerSize', 5);

% Highlight the two farthest nodes
highlight(h, start_node, 'NodeColor', 'y', 'Marker', 'pentagram', 'MarkerSize', 8);
highlight(h, end_node, 'NodeColor', 'y', 'Marker', 'pentagram', 'MarkerSize', 8);

% Find neighbors of the first farthest node and highlight them
neighbors_start = neighbors(G, start_node);
highlight(h, neighbors_start, 'NodeColor', 'r', 'Marker', 'd');
highlight(h, start_node, neighbors_start, 'EdgeColor', 'r', 'LineWidth', 1.5);

hold off;

% Display information
disp(['Farthest nodes: ', num2str(start_node), ' - ', num2str(end_node)]);
disp(['Maximum distance: ', num2str(max_distance)]);
disp(['Highlighted path length: ', num2str(length(shortest_path))]);
