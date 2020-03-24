function pointset = getPointset(image, num_points, threshold, invert)
    bw = im2bw(image, threshold);
    if invert
        bw = ~bw;
    end
    B = bwboundaries(bw);
    boundary = B{1};

    coeff = polyfit(boundary(:, 1), boundary(:, 2), 1);
    min_dist = Inf;
    start_index = 1;
    for i=1:size(boundary, 1)
        dist = abs(coeff(1)*boundary(i, 1)-boundary(i, 2)+coeff(2))/sqrt(coeff(1)^2 + 1);
        if dist < min_dist
            min_dist = dist;
            start_index = i;
        end
    end
    boundary = circshift(boundary, -(start_index-1));
    
    pointset = zeros(num_points, 2);
    step = floor(size(boundary, 1)/num_points);
    for i = 1:num_points
        pointset(i, :) = boundary(1+(i-1)*step, :);
    end

    pointset = pointset - mean(pointset);
    pointset = pointset./sqrt(sum(pointset(:).^2));
end

