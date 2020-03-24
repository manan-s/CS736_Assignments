%%
%
% Problem 1: Shape Analysis on Simulated Ellipse Shapes
%

% SHOW_FIGURES = true;

image_folder = '../data/ellipse/data/data/';
filenames = dir(fullfile(image_folder, '*.jpg'));
num_images = numel(filenames);

num_points = 16; % No. of points in each pointset
shapes = zeros(2, num_points, num_images);
for i = 1:num_images
    f = fullfile(image_folder, filenames(i).name);
    image = imread(f);
    shapes(:, :, i) = getPointset(image, num_points, 0.1, false)';
end

%% Plot of initail pointsets

ellipse_pointsets_fig = figure('visible', SHOW_FIGURES);
hold on;
for i = 1:num_images
    x = [shapes(1, :, i) shapes(1, 1, i)]; % append the first point to complete the figure
    y = [shapes(2, :, i) shapes(2, 1, i)];
    plot(x, y, 'color', rand(1, 3), 'LineWidth', 0.5);
    title('Initial Shape-set - Ellipse (Translated and Scaled)');
end

%% Mean Shape

mean_shape = meanShape(shapes);
aligned_shapes = zeros(size(shapes));

ellipse_meanshape_fig = figure('visible', SHOW_FIGURES);
hold on;
for i = 1:num_images
    [aligned_shapes(:, :, i), ~] = align(mean_shape, shapes(:, :, i));
    scatter(aligned_shapes(1, :, i), aligned_shapes(2, :, i), 1, rand(1, 3)); 
end
plot([mean_shape(1, :) mean_shape(1, 1)], [mean_shape(2, :) mean_shape(2, 1)], 'LineWidth', 2);
title('Mean Shape - Ellipse');

%% Covariance Matrix

[V, L] = computeModesOfVariation(aligned_shapes, mean_shape);

z_mean = mean_shape(:);
ellipse_variance_fig = figure('visible', SHOW_FIGURES);
variances = diag(L);
plot(variances(1:3));
title('Eigenvalues plot - Ellipse');


% Mode 1
z1 = z_mean + 3*sqrt(L(1)) * V(:,1);
z2 = z_mean - 3*sqrt(L(1)) * V(:,1);
z1 = z1 / norm(z1);
z2 = z2 / norm(z2);

ellipse_mode1_fig = figure('visible', SHOW_FIGURES);
hold on;
for i = 1:num_images
    scatter(aligned_shapes(1, :, i), aligned_shapes(2, :, i), 1, rand(1, 3)); 
end
p1 = plot([mean_shape(1, :) mean_shape(1, 1)], [mean_shape(2, :) mean_shape(2, 1)], 'color', [0 0 0], 'LineWidth', 2.0, 'DisplayName','Mean');
p2 = plot([z1(1:2:size(z1, 1), 1)' z1(1, 1)], [z1(2:2:size(z1, 1), 1)' z1(2, 1)], 'DisplayName','+3 SD from mean');
p3 = plot([z2(1:2:size(z1, 1), 1)' z2(1, 1)], [z2(2:2:size(z2, 1), 1)' z2(2, 1)], 'DisplayName','-3 SD from mean');
title('First mode of Variation - Ellipse');
legend([p1, p2, p3]);

% Mode 2
z1 = z_mean + 3*sqrt(L(2)) * V(:, 2);
z2 = z_mean - 3*sqrt(L(2)) * V(:, 2);
z1 = z1 / norm(z1);
z2 = z2 / norm(z2);

ellipse_mode2_fig = figure('visible', SHOW_FIGURES);
hold on;
for i = 1:num_images
    scatter(aligned_shapes(1, :, i), aligned_shapes(2, :, i), 1, rand(1, 3)); 
end
p1 = plot([mean_shape(1, :) mean_shape(1, 1)], [mean_shape(2, :) mean_shape(2, 1)], 'color', [0 0 0], 'LineWidth', 2.0, 'DisplayName','Mean');
p2 = plot([z1(1:2:size(z1, 1), 1)' z1(1, 1)], [z1(2:2:size(z1, 1), 1)' z1(2, 1)], 'DisplayName','+3 SD from mean');
p3 = plot([z2(1:2:size(z1, 1), 1)' z2(1, 1)], [z2(2:2:size(z2, 1), 1)' z2(2, 1)], 'DisplayName','-3 SD from mean');
title('Second mode of Variation - Ellipse');
legend([p1, p2, p3]);

% Mode 3
z1 = z_mean + 3*sqrt(L(3)) * V(:, 3);
z2 = z_mean - 3*sqrt(L(3)) * V(:, 3);
z1 = z1 / norm(z1);
z2 = z2 / norm(z2);

ellipse_mode3_fig = figure('visible', SHOW_FIGURES);
hold on;
for i = 1:num_images
    scatter(aligned_shapes(1, :, i), aligned_shapes(2, :, i), 1, rand(1, 3)); 
end
p1 = plot([mean_shape(1, :) mean_shape(1, 1)], [mean_shape(2, :) mean_shape(2, 1)], 'color', [0 0 0], 'LineWidth', 2.0, 'DisplayName','Mean');
p2 = plot([z1(1:2:size(z1, 1), 1)' z1(1, 1)], [z1(2:2:size(z1, 1), 1)' z1(2, 1)], 'DisplayName','+3 SD from mean');
p3 = plot([z2(1:2:size(z1, 1), 1)' z2(1, 1)], [z2(2:2:size(z2, 1), 1)' z2(2, 1)], 'DisplayName','-3 SD from mean');
title('Third mode of Variation - Ellipse');
legend([p1, p2, p3]);

%% Most Similar
ellipse_closesttomean_fig = figure('visible', SHOW_FIGURES);
min_dist = Inf;
for i = 1:num_images
    mean_dist = sum(sqrt(sum((aligned_shapes(:, :, i) - mean_shape).^2)));
    if mean_dist < min_dist
        min_dist = mean_dist;
        image_index = i;
    end
end

hold on
plot([mean_shape(1, :) mean_shape(1, 1)], [mean_shape(2, :) mean_shape(2, 1)], 'LineWidth', 2, 'color', [0 0 0]);
plot([aligned_shapes(1, :, image_index) aligned_shapes(1, 1, image_index)], [aligned_shapes(2, :, image_index) aligned_shapes(2, 1, image_index)], 'LineWidth', 1.5);
title('Closest to Mean Shape - Ellipse');

z1 = z_mean + 3*sqrt(L(1)) * V(:,1);
z2 = z_mean - 3*sqrt(L(1)) * V(:,1);
z1 = z1 / norm(z1);
z2 = z2 / norm(z2);

plus3_shape = zeros(size(mean_shape));
plus3_shape(1,:) = z1(1:2:size(z1, 1), 1);
plus3_shape(2,:) = z1(2:2:size(z1, 1), 1);

min_dist = Inf;
for i = 1:num_images
    mean_dist = sum(sqrt(sum((aligned_shapes(:, :, i) - mean_shape).^2)));
    if mean_dist < min_dist
        min_dist = mean_dist;
        image_index = i;
    end
end

ellipse_closesttoplus3_fig = figure('visible', SHOW_FIGURES);
hold on
plot([z1(1:2:size(z1, 1), 1)' z1(1, 1)], [z1(2:2:size(z1, 1), 1)' z1(2, 1)], 'DisplayName','+3 SD from mean', 'LineWidth', 2, 'color', [0 0 0]);
plot([aligned_shapes(1, :, image_index) aligned_shapes(1, 1, image_index)], [aligned_shapes(2, :, image_index) aligned_shapes(2, 1, image_index)], 'LineWidth', 1.5);
title('Closest to +3 SD Shape - Ellipse');

minus3_shape = zeros(size(mean_shape));
minus3_shape(1,:) = z2(1:2:size(z1, 1), 1);
minus3_shape(2,:) = z2(2:2:size(z1, 1), 1);
min_dist = Inf;
for i = 1:num_images
    mean_dist = sum(sqrt(sum((aligned_shapes(:, :, i) - mean_shape).^2)));
    if mean_dist < min_dist
        min_dist = mean_dist;
        image_index = i;
    end
end

ellipse_closesttominus3_fig = figure('visible', SHOW_FIGURES);
hold on
plot([z2(1:2:size(z1, 1), 1)' z2(1, 1)], [z2(2:2:size(z2, 1), 1)' z2(2, 1)], 'DisplayName','-3 SD from mean', 'DisplayName','+3 SD from mean', 'LineWidth', 2, 'color', [0 0 0]);
plot([aligned_shapes(1, :, image_index) aligned_shapes(1, 1, image_index)], [aligned_shapes(2, :, image_index) aligned_shapes(2, 1, image_index)], 'LineWidth', 1.5);
title('Closest to -3 SD Shape - Ellipse');