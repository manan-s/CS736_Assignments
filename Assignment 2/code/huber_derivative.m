function d = huber_derivative(x, gamma)
    d = zeros(size(x));
    x = abs(x);
    index = x <= gamma;
    d(index) = x(index);
    d(~index) = gamma;
end