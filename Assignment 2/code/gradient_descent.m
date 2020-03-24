function [x, losses] = gradient_descent(true_image, initial_guess, sigma, beta, step, gamma, MRF, MRF_derivative)
    x = initial_guess;
    [rows, columns] = size(x);
    max_iter = 200;
    losses = zeros(1, max_iter);
    step = step*ones(rows, columns);
    for i = 1:max_iter
        loss = (1-beta)*(true_image - x).^2 / sigma^2 + beta*cliques(x, gamma, @(arg1, arg2)MRF(arg1, arg2));
        grad = -2 * (1-beta) / sigma^2 * (true_image - x) + beta*cliques(x, gamma, @(arg1, arg2)MRF_derivative(arg1, arg2));
        
        x = x - grad .* step;
        new_loss = (1-beta)*(true_image - x).^2 / sigma^2 + beta*cliques(x, gamma, @(arg1, arg2)MRF(arg1, arg2));
        
        loss_dec_index = (new_loss < loss);
        step(loss_dec_index) = 1.1 * step(loss_dec_index);
        step(~loss_dec_index) = 0.5 * step(~loss_dec_index);
        
        losses(i) = sum(sum(loss));
    end
end