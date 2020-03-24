clear all; close all; clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUESTION 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('__________QUESTION 1_________\n\n');
true_image = double(imread('..\data\mri_image_noiseless.png'));
noise_high_image = double(imread('..\data\mri_image_noise_level_high.png'));
noise_medium_image = double(imread('..\data\mri_image_noise_level_medium.png'));
noise_low_image = double(imread('..\data\mri_image_noise_level_low.png'));

fprintf('RRMSE b/w high noise and true image: %f\n', rrmse(true_image, noise_high_image));
fprintf('RRMSE b/w medium noise and true image: %f\n', rrmse(true_image, noise_medium_image));
fprintf('RRMSE b/w low noise and true image: %f\n\n', rrmse(true_image, noise_low_image));

sigma = 1;
gamma = 1; %used only for quadratic prior, since it doesn't play a role there


%%Code for obtaining optimal parameters for quadratic prior
%{
%alphas to be tested
alphaRange=[0.01:0.01:0.99];
minRRMSE = Inf;
bestAlpha = -1;
rrmseSTR = zeros(length(alphaRange), 1);
gamma =1;
for i = 1:length(alphaRange)
    alpha = alphaRange(i);
    [x, ~] = gradient_descent(noisy_image1, noise_high_image, sigma, alpha, 1, gamma, @quadratic, @quadratic_derivative);
    rrmseTemp = rrmse(x, true_image1);
    rrmseSTR(i) = rrmseTemp;
    display(rrmseTemp);
    
    if rrmseTemp<minRRMSE
        minRRMSE = rrmseTemp;
        bestAlpha = alpha;
    end
end
quad_alpha1 = bestAlpha;
%}
%optimal alphas obtained from above code


% Quadratic Prior
%Tune parameters here
alpha1 = 0.34;
alpha2 = 0.25;
alpha3 = 0.12;

%multiply each alpha with 1.2 or 0.8 to see the desired results
[q_denoised_image1, losses] = gradient_descent(noise_high_image, noise_high_image, sigma, alpha1, 0.001, gamma, @quadratic, @quadratic_derivative);
[q_denoised_image2, ~] = gradient_descent(noise_medium_image, noise_medium_image, sigma, alpha2, 0.001, gamma, @quadratic, @quadratic_derivative);
[q_denoised_image3, ~] = gradient_descent(noise_low_image, noise_low_image, sigma, alpha3, 0.001, gamma, @quadratic, @quadratic_derivative);

fprintf('High Noise: Quadratic prior: Optimal alpha: %f, RRMSE: %f\n', alpha1, rrmse(true_image, q_denoised_image1));
fprintf('Medium Noise: Quadratic prior: Optimal alpha: %f, RRMSE: %f\n', alpha2, rrmse(true_image, q_denoised_image2));
fprintf('Low Noise: Quadratic prior: Optimal alpha: %f, RRMSE: %f\n\n', alpha3, rrmse(true_image, q_denoised_image3));

figure(1);
imshow(mat2gray(q_denoised_image1));
title("High noise image denoised using quadratic prior");
figure(2);
imshow(mat2gray(q_denoised_image2));
title("Medium noise image denoised using quadratic prior");
figure(3);
imshow(mat2gray(q_denoised_image3));
title("Low noise image denoised using quadratic prior");
figure(4);
imshow(mat2gray(true_image));
title("True Image");
figure(5);
plot(losses);
title("Loss vs Itertation for quadratic prior");

% Huber Prior
%Tune parameters here
alpha1 = 0.34;
alpha2 = 0.34;
alpha3 = 0.45;

gamma1 = 15;
gamma2 = 5;
gamma3 = 5;

[h_denoised_image1, losses] = gradient_descent(noise_high_image, noise_high_image, sigma, alpha1, 0.001, gamma1, @huber, @huber_derivative);
[h_denoised_image2, ~] = gradient_descent(noise_medium_image, noise_medium_image, sigma, alpha2, 0.001, gamma2, @huber, @huber_derivative);
[h_denoised_image3, ~] = gradient_descent(noise_low_image, noise_low_image, sigma, alpha3, 0.001, gamma3, @huber, @huber_derivative);

fprintf('High Noise: Huber prior: Optimal alpha: %f, RRMSE: %f\n', alpha1, rrmse(true_image, h_denoised_image1));
fprintf('Medium Noise: Huber prior: Optimal alpha: %f, RRMSE: %f\n', alpha2, rrmse(true_image, h_denoised_image2));
fprintf('Low Noise: Huber prior: Optimal alpha: %f, RRMSE: %f\n\n', alpha3, rrmse(true_image, h_denoised_image3));

figure(6);
imshow(mat2gray(h_denoised_image1));
title("High noise image denoised using Huber prior");
figure(7);
imshow(mat2gray(h_denoised_image2));
title("Medium noise image denoised using Huber prior");
figure(8);
imshow(mat2gray(h_denoised_image3));
title("Low noise image denoised using Huber prior");
figure(9);
imshow(mat2gray(true_image));
title("True Image");
figure(10);
plot(losses);
title("Loss vs Itertation for Huber prior");

% Adaptive Prior
%Tune parameters here
alpha1 = 0.50;
alpha2 = 0.20;
alpha3 = 0.50;

gamma1 = 12;
gamma2 = 11;
gamma3 = 8;

[a_denoised_image1, losses] = gradient_descent(noise_high_image, noise_high_image, sigma, alpha1, 0.001, gamma1, @adaptive, @adaptive_derivative);
[a_denoised_image2, ~] = gradient_descent(noise_medium_image, noise_medium_image, sigma, alpha2, 0.001, gamma2, @adaptive, @adaptive_derivative);
[a_denoised_image3, ~] = gradient_descent(noise_low_image, noise_low_image, sigma, alpha3, 0.001, gamma3, @adaptive, @adaptive_derivative);

fprintf('High Noise: Adaptive prior: Optimal alpha: %f, RRMSE: %f\n', alpha1, rrmse(true_image, a_denoised_image1));
fprintf('Medium Noise: Adaptive prior: Optimal alpha: %f, RRMSE: %f\n', alpha2, rrmse(true_image, a_denoised_image2));
fprintf('Low Noise: Adaptive prior: Optimal alpha: %f, RRMSE: %f\n\n', alpha3, rrmse(true_image, a_denoised_image3));


figure(11);
imshow(mat2gray(a_denoised_image1));
title("High noise image denoised using adaptive prior");
figure(12);
imshow(mat2gray(a_denoised_image2));
title("Medium noise image denoised using adaptive prior");
figure(13);
imshow(mat2gray(a_denoised_image3));
title("Low noise image denoised using adaptive prior");
figure(14);
imshow(mat2gray(true_image));
title("True Image");
figure(15);
plot(losses);
title("Loss vs Itertation for adaptive prior");

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% QUESTION 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n\n__________QUESTION 2_________\n\n');
true_image = imread('..\data\histology_noiseless.png');
noisy_image = imread('..\data\histology_noisy.png');

true_image1 = double(true_image(:,:,1));
noisy_image1 = double(noisy_image(:,:,1));
true_image2 = double(true_image(:,:,2));
noisy_image2 = double(noisy_image(:,:,2));
true_image3 = double(true_image(:,:,3));
noisy_image3 = double(noisy_image(:,:,3));
%{
true_image = imread('C:\Users\manan\Downloads\assignmentDenoising\data\mri_image_noiseless.png');
noisy_image = imread('C:\Users\manan\Downloads\assignmentDenoising\data\mri_image_noise_level_high.png');
%}

fprintf('RRMSE b/w channel 1 of noisy and true image: %f\n', rrmse(true_image1, noisy_image1));
fprintf('RRMSE b/w channel 2 of noisy and true image: %f\n', rrmse(true_image2, noisy_image2));
fprintf('RRMSE b/w channel 3 of noisy and true image: %f\n\n', rrmse(true_image3, noisy_image3));

sigma = 1;
gamma = 1; %used only for quadratic prior, since it doesn't play a role there
%%Code for obtaining optimal parameters for quadratic prior


%{
%alphas to be tested
alphaRange=[0.01:0.01:0.99];
minRRMSE = Inf;
bestAlpha = -1;
rrmseSTR = zeros(length(alphaRange), 1);
gamma =1;
for i = 1:length(alphaRange)
    alpha = alphaRange(i);
    [x, ~] = gradient_descent(noisy_image1, noisy_image1, sigma, alpha, 1, gamma, @quadratic, @quadratic_derivative);
    rrmseTemp = rrmse(x, true_image1);
    rrmseSTR(i) = rrmseTemp;
    display(rrmseTemp);
    
    if rrmseTemp<minRRMSE
        minRRMSE = rrmseTemp;
        bestAlpha = alpha;
    end
end
quad_alpha1 = bestAlpha;
%}
%optimal alphas obtained from above code
%Tune parameters here
quad_alpha1 = 0.84;
quad_alpha2 = 0.8784;
quad_alpha3 = 0.84;

[q_denoised_image1, qlosses1] = gradient_descent(noisy_image1, noisy_image1, sigma, quad_alpha1, 0.01, gamma, @quadratic, @quadratic_derivative);
[q_denoised_image2, qlosses2] = gradient_descent(noisy_image2, noisy_image2, sigma, quad_alpha2, 0.01, gamma, @quadratic, @quadratic_derivative);
[q_denoised_image3, qlosses3] = gradient_descent(noisy_image3, noisy_image3, sigma, quad_alpha3, 0.01, gamma, @quadratic, @quadratic_derivative);

fprintf('Channel 1: Quadratic prior: Optimal alpha: %f, RRMSE: %f\n', quad_alpha1, rrmse(true_image1, q_denoised_image1));
fprintf('Channel 2: Quadratic prior: Optimal alpha: %f, RRMSE: %f\n', quad_alpha2, rrmse(true_image2, q_denoised_image2));
fprintf('Channel 3: Quadratic prior: Optimal alpha: %f, RRMSE: %f\n\n', quad_alpha3, rrmse(true_image3, q_denoised_image3));

q_denoised_image = zeros(size(true_image));
q_denoised_image(:,:,1)=q_denoised_image1;
q_denoised_image(:,:,2)=q_denoised_image2;
q_denoised_image(:,:,3)=q_denoised_image3;
q_denoised_image = uint8(q_denoised_image);

figure(17);
imshow(q_denoised_image);
title("Denoised using Quadratic Prior");
figure(18);
imshow(true_image);
title("True Image");
figure(19);
plot(qlosses1);
title("Loss vs Iteration for quadratic prior");

%Code for getting optimal values of alpha and gamma for Huber and Adaptive
%Discontinuity function
%{
best_alpha = 0;
best_gamma = 0;
best_error = Inf;

for gamma = 40:42
    for alpha = 0.25:0.01: 0.35
        [denoised_image1, ~] = gradient_descent(noisy_image1, noisy_image1, sigma, alpha, 0.001, gamma, @huber, @huber_derivative);
        error = rrmse(denoised_image1, true_image1);
        display(error);
        if error < best_error
            best_error = error;
            best_alpha = alpha;
            best_gamma = gamma;
        end
    end
end
h_alpha1 = best_alpha;
h_gamma1 = best_gamma;
%}

% Huber Prior
%Tune parameters here
alpha1 = 0.216;
alpha2 = 0.24;
alpha3 = 0.20;

gamma1 = 82.94;
gamma2 = 99.5328;
gamma3 = 80;

[h_denoised_image1, losses] = gradient_descent(noisy_image1, noisy_image1, sigma, alpha1, 0.01, gamma1, @huber, @huber_derivative);
[h_denoised_image2, ~] = gradient_descent(noisy_image2, noisy_image2, sigma, alpha2, 0.01, gamma2, @huber, @huber_derivative);
[h_denoised_image3, ~] = gradient_descent(noisy_image3, noisy_image3, sigma, alpha3, 0.01, gamma3, @huber, @huber_derivative);

fprintf('Channel 1: Huber prior: Optimal alpha: %f, RRMSE: %f\n', alpha1, rrmse(true_image1, h_denoised_image1));
fprintf('Channel 2: Huber prior: Optimal alpha: %f, RRMSE: %f\n', alpha2, rrmse(true_image2, h_denoised_image2));
fprintf('Channel 3: Huber prior: Optimal alpha: %f, RRMSE: %f\n\n', alpha3, rrmse(true_image3, h_denoised_image3));

h_denoised_image = zeros(size(true_image));
h_denoised_image(:,:,1)=h_denoised_image1;
h_denoised_image(:,:,2)=h_denoised_image2;
h_denoised_image(:,:,3)=h_denoised_image3;
h_denoised_image = uint8(h_denoised_image);

figure(20);
imshow(h_denoised_image);
title("Denoised using Huber Prior");
figure(21);
plot(losses);
title("Loss vs Iteration for Huber prior");

% Adaptive Prior
%Tune parameters here
alpha1 = 0.5;
alpha2 = 0.5;
alpha3 = 0.5;
gamma1 = 20;
gamma2 = 20;
gamma3 = 24;

[a_denoised_image1, losses] = gradient_descent(noisy_image1, noisy_image1, sigma, alpha1, 0.01, gamma1, @adaptive, @adaptive_derivative);
[a_denoised_image2, ~] = gradient_descent(noisy_image2, noisy_image2, sigma, alpha2, 0.01, gamma2, @adaptive, @adaptive_derivative);
[a_denoised_image3, ~] = gradient_descent(noisy_image3, noisy_image3, sigma, alpha3, 0.01, gamma3, @adaptive, @adaptive_derivative);

fprintf('Channel 1: Adaptive prior: Optimal alpha: %f, RRMSE: %f\n', alpha1, rrmse(true_image1, a_denoised_image1));
fprintf('Channel 2: Adaptive prior: Optimal alpha: %f, RRMSE: %f\n', alpha2, rrmse(true_image2, a_denoised_image2));
fprintf('Channel 3: Adaptive prior: Optimal alpha: %f, RRMSE: %f\n\n', alpha3, rrmse(true_image3, a_denoised_image3));

a_denoised_image = zeros(size(true_image));
a_denoised_image(:,:,1)=a_denoised_image1;
a_denoised_image(:,:,2)=a_denoised_image2;
a_denoised_image(:,:,3)=a_denoised_image3;
a_denoised_image = uint8(a_denoised_image);

figure(22);
imshow(a_denoised_image);
title("Denoised using Adaptive Prior");
figure(23);
imshow(true_image);
title("True Image");
figure(24);
plot(losses);
title("Loss vs Iteration for Adaptive prior");
figure(25);
imshow(noisy_image);
title("Noisy image");

fprintf('\nRRMSE VALUES CORRESPONDING TO "0.8/1.2 * alpha/gamma" ARE PRESENT IN REPORT\n');
fprintf('PLEASE TUNE PARAMETERS IN CODE FOR VIEWING THESE RESULTS\n');

