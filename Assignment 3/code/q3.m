Datasets = ["ChestCT", "SheppLogan256"];
fig_num = 1;
for i = 1:2
    dataset = Datasets(i);
    img = double(imread("../data/" + dataset + ".png"));
    min_error = Inf;
    optimal_theta = 0;
    Errors = zeros(1, 181);
    for theta=0:1:180
        T = theta:1:(theta+150);
        rdn = radon(img, T);
        invRdn = iradon(rdn, T, 'linear', 'Ram-Lak', 1, size(img, 1));
        error = rrmse(img, invRdn);
        if error < min_error
            min_error = error;
            optimal_theta = theta;
        end
        Errors(theta+1) = error;
    end

    fprintf("Optimal theta for %s = %f\n", dataset, optimal_theta);
    figure(fig_num);
    plot(Errors);
    title("RRMSE vs \theta for " + dataset);
    T = optimal_theta:1:(optimal_theta+150);
    rdn = radon(img, T);
    invRdn = iradon(rdn, T, 'linear', 'Ram-Lak');
    
    figure(fig_num+1);
    imshow(invRdn, []);
    title("Reconstructed Image with Optimal \theta for " + dataset);
    fig_num = fig_num + 2;
end