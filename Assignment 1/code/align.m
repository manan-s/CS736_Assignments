function [z_align, distance] = align(z1, z2)
    n = size(z1, 2);
    z_align = zeros(2, n);
    distance = Inf;
    z = zeros(n, 1);
    for theta = 0:360
        ang = theta * pi / 180;
        M = [cos(ang) -sin(ang); sin(ang) cos(ang)];
        z = M * z2;
        curr_dist = sqrt(sum((z(:) - z1(:)).^2));
        if curr_dist <= distance
            distance = curr_dist;
            z_align = z;
        end
    end
end