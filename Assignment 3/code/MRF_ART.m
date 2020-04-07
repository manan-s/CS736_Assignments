function [rec_image, Losses] = MRF_ART(A, b, max_iters, gamma, epsilon, img_dim, original_image, MRF, MRF_derivative)

stop = 0;
num_iters = 0;
step = 1e-5;
Losses = [];

x = zeros(img_dim, img_dim);
xk = x(:);
residual = A * xk - b;              % A*x - b
image_x=original_image(:);          %for RRMSE

prev_loss = Inf;
while ~stop
    
    num_iters = num_iters+1;
    x_init = xk;
    
    temp_im = reshape(xk, img_dim, img_dim);
    MRF_val = cliques(temp_im, gamma, @(arg1, arg2)MRF(arg1, arg2));
    MRF_val = MRF_val(:);
    MRF_der = cliques(temp_im, gamma, @(arg1, arg2)MRF_derivative(arg1, arg2));
    MRF_der = MRF_der(:);
    
    loss = sum(residual.^2) + sum(sum(MRF_val));
    grad = (2.0*residual'*A)' + MRF_der;
    xk = xk - step*grad;
    residual = A * xk - b;
    
    x_final = xk;
    x_final(x_final < 0) = 0;
    diff = norm(x_final - x_init);
    %disp(rrmse(image_x, x_final));
    % imshow(reshape(x_final, img_dim, img_dim), []);
    
    if loss > prev_loss
        step = step * 0.5;
    else
        step = step * 1.1;
    end
    
    Losses = [Losses; loss];
    prev_loss = loss;
        
    
    if diff < epsilon || num_iters >= max_iters
        stop = 1;
    end
    xk(xk<0) = 0;
end

rec_image = reshape(x_final, img_dim, img_dim);
end
