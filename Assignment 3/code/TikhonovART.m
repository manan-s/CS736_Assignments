function [rec_image] = TikhonovART(A, b, max_iters, alpha, lambda, epsilon, img_dim, original_image)

% A modified Kagzmarz update scheme under Tikhonov Regularization, very slow due to individual pixel updates
% For batchwise update (much faster), replace second term of 'grad' variable assignment in MRF_ART.m file from 
% MRF_der to alpha*xk after choosing a suitable value of alpha.

stop = 0;
num_iters = 0;

x = zeros(img_dim, img_dim);
xk = x(:);
residual = b - A * xk;              % b - A*x
norm_ai = full(abs(sum(A.*A,1)));   %||ai||
col_indices = find(norm_ai>0);
image_x=original_image(:);          %for RRMSE
figure('Name', 'Tikhonov Animation');

while ~stop
    
    num_iters = num_iters+1;
    x_init = xk;
    
    for i = col_indices
        ai = A(:,i)';
        update = (ai*residual - alpha*xk(i))/(norm_ai(i) + alpha);
        residual = residual - update*ai';
        xk(i) = xk(i) + lambda*update;
        %{
        if xk(i) < 0
            xk(i) = 0;
        end
        %}
    end
    
    x_final = xk;
    x_final(x_final < 0) = 0;
    diff = norm(x_final - x_init);
    disp(rrmse(image_x, x_final));
    imshow(reshape(x_final, img_dim, img_dim), []);
    if diff < epsilon || num_iters >= max_iters
        stop = 1;
    end
end

close;
rec_image = reshape(x_final, img_dim, img_dim);
end
