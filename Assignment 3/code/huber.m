function h = huber(x, gamma)
    h = zeros(size(x));
    x = abs(x);
    
    index = (x <= gamma);
    h(index) = 0.5 * x(index).^2;
    h(~index) = gamma*x(~index) - 0.5*gamma^2;
    
end