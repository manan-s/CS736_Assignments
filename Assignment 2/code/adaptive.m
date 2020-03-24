function p = adaptive(x, gamma)
    x = abs(x);
    p = gamma*x - gamma^2 * log(1 + x/gamma);
end