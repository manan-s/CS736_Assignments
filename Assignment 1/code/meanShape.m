function avg = meanShape(pointsets)
    n = size(pointsets, 3);
    avg = pointsets(:, :, 1);
    tot_dist = 1;
    prev_dist = 0;
    while abs(tot_dist - prev_dist) > 0.0001
        prev_dist = tot_dist;
        tot_dist = 0;
        z = avg;
        for i = 1:n
            [z_align, dist] = align(avg, pointsets(:, :, i));
            z = z + z_align;
            tot_dist = tot_dist + dist;
        end
        avg = z / n;
        avg = avg / norm(avg(:));
    end
end
