function res = cliques(x, gamma, func)
    [rows, cols] = size(x);
    res = zeros(rows, cols);
    
    mask = conv2(eye(cols), [-1, 1, 0], 'same');
    mask(1, cols) = -1;
    res = res + func(x*mask, gamma);
    
    mask = conv2(eye(cols), [0, 1, -1], 'same');
    mask(cols, 1) = -1;
    res = res + func(x*mask, gamma);
    
    mask = conv2(eye(rows), [0, 1, -1], 'same');
    mask(rows, 1) = -1;
    res = res + func(mask*x, gamma);
    
    mask = conv2(eye(rows), [-1, 1, 0], 'same');
    mask(1, rows) = -1;
    res = res + func(mask*x, gamma);
end