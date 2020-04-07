function [] = formSystemMatrix(img_dim, radon_dim, theta)
    sys_mat = zeros(length(theta)*radon_dim , img_dim*img_dim);
    zeroim = zeros(img_dim, img_dim);
    
    for j=1:img_dim
        for i=1:img_dim
            zeroim(i,j)=1;
            rad_im_vec = radon(zeroim, theta);
            sys_mat(:, i+img_dim*(j-1)) = rad_im_vec(:);
            zeroim(i,j)=0;
        end
    end
    
    sys_mat = sparse(sys_mat);
    save('AB.mat', 'sys_mat', '-v7.3');
end