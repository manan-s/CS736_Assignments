function [V, L] = computeModesOfVariation(shapes, mean_shape)
    num_images = size(shapes, 3);
    
    
    X = zeros(num_images, 2*size(shapes, 2));
    for i=1:num_images
        x = shapes(:, :, i) - mean_shape;
        X(i, :) = x(:)';
    end
    covx = cov(X);
    [V, L] = pcacov(covx);
end