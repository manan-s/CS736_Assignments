function p = adaptive_derivative(x, gamma)
    x = abs(x);
    p = gamma - gamma * ones(size(x)) ./ (1 + x/gamma);
end