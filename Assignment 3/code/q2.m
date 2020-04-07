% clear all; close all; clc;

original_image = double(imread('..\data\ChestPhantom.png'));

%% HYPERPARAMETERS
img_dim = 128;
radon_dim = 185;    %number of bins in radon transform, length(radon(image, any_scalar))
theta = 0:179;
noise_level = 0.02; 
max_iters = 100;    

alpha = 70;         %for tikhonovART
gamma = 50.0;       %only used for sake of passing arguments for MRFquad
lambda = 1.0;       %for tikhonovART. Must be in (0, 1]
epsilon = 1e-7;     %for naive stopping criterion
%%
numcol = img_dim*img_dim;
numrow = length(theta)*radon_dim;

if ~isfile('AB.mat')
    formSystemMatrix(img_dim, radon_dim, theta);
end
    
matObj = matfile('AB.mat');
A = matObj.sys_mat;
image_x=original_image(:);

%radon calculated through above method
forward_radon=A*image_x;

%original radon
b = radon(original_image, theta);
IR = iradon(b, theta, 'linear', 'none');
b = b(:);

%% Gaussian corruption of forward projected radon
noise_sigma = noise_level*forward_radon;
noise = randn(length(forward_radon), 1) .* noise_sigma;
noisy_b = forward_radon + noise;

%% Reconstruction using Filtered Back-Propagation, Ram_lak Filter
R = reshape(full(noisy_b), radon_dim, length(theta));
filteredFreqImage = fft(R);
N = size(R,1);

w = 2*pi/N*(0:N-1);
w = (w-w(round(N/2)))';

L = pi*0.5;

frequencyFilterMask = abs(w);
frequencyFilterMask(abs(w)> L) = 0;

frequencyFilterMask = repmat(ifftshift(frequencyFilterMask),1,size(R,2));
filteredImage = real(ifft(filteredFreqImage.*frequencyFilterMask));

ramlak_image = 0.5*iradon(filteredImage,theta, 'linear','none',1,128);
figure('Name', 'FBP Reconstruction, Ram-Lak filter');
imshow(ramlak_image, []);
fprintf('RRMSE of FBP Reconstruction is '); 
disp(rrmse(original_image, ramlak_image));

%% For original reconstruction, replace variable 'noisy_b' by 'b' in all instances below
%% TikhonovART
ART_image_tikhonov = TikhonovART(A, noisy_b, max_iters, alpha, lambda, epsilon, img_dim, original_image);
figure('Name','TikhonovART Final Image');
imshow(ART_image_tikhonov, []);
fprintf('RRMSE of Tikhonov with optimum_alpha=%d is', alpha); 
rrmse_t = rrmse(original_image, ART_image_tikhonov);
disp(rrmse_t);

ART_image_tikhonov1 = TikhonovART(A, noisy_b, max_iters, alpha*1.2, lambda, epsilon, img_dim, original_image);
fprintf('RRMSE of Tikhonov with 1.2*optimum_alpha=%d is', alpha*1.2); 
disp(rrmse(original_image, ART_image_tikhonov1));
figure('Name','TikhonovART Image, 1.2*alpha');
imshow(ART_image_tikhonov1, []);

ART_image_tikhonov2 = TikhonovART(A, noisy_b, max_iters, alpha*0.8, lambda, epsilon, img_dim, original_image);
fprintf('RRMSE of Tikhonov with 0.8*optimum alpha=%d is', alpha*0.8); 
disp(rrmse(original_image, ART_image_tikhonov2));
figure('Name','TikhonovART Image, 0.8*alpha');
imshow(ART_image_tikhonov2, []);
 
%% MarkovART, Quadratic
ART_image_MRF_quad = MRF_ART(A, noisy_b,  max_iters*5, gamma, epsilon, img_dim, original_image, @quadratic, @quadratic_derivative);
figure('Name','MarkovART Final Image - Quadratic');
imshow(ART_image_MRF_quad, []);
fprintf('RRMSE of Quadratic is '); 
disp(rrmse(original_image, ART_image_MRF_quad));

%% MarkovART, Huber
gamma = 6.8;
ART_image_MRF_huber = MRF_ART(A, noisy_b,  max_iters*5, gamma, epsilon, img_dim, original_image, @huber, @huber_derivative);
figure('Name','MarkovART Final Image - Huber');
imshow(ART_image_MRF_huber, []);
fprintf('RRMSE of Huber is '); 
disp(rrmse(original_image, ART_image_MRF_huber));

ART_image_MRF_huber1 = MRF_ART(A, noisy_b,  max_iters*5, gamma*1.2, epsilon, img_dim, original_image, @huber, @huber_derivative);
ART_image_MRF_huber2 = MRF_ART(A, noisy_b,  max_iters*5, gamma*0.8, epsilon, img_dim, original_image, @huber, @huber_derivative);
fprintf('RRMSE of Huber, 1.2*gamma is '); 
disp(rrmse(original_image, ART_image_MRF_huber1));
fprintf('RRMSE of Huber, 0.8*gamma is '); 
disp(rrmse(original_image, ART_image_MRF_huber2));

figure('Name','MarkovART Image - Huber, 1.2*gamma');
imshow(ART_image_MRF_huber1, []);
figure('Name','MarkovART Image - Huber, 0.8*gamma');
imshow(ART_image_MRF_huber2, []);

%% MarkovART, Adaptive Discontinuity
gamma = 4.0;
ART_image_MRF_adaptive = MRF_ART(A, noisy_b,  max_iters*5, gamma, epsilon, img_dim, original_image, @adaptive, @adaptive_derivative);
figure('Name','MarkovART Final Image - Adaptive');
imshow(ART_image_MRF_adaptive, []);
fprintf('RRMSE of Adaptive is '); 
disp(rrmse(original_image, ART_image_MRF_adaptive));

ART_image_MRF_adaptive1 = MRF_ART(A, noisy_b,  max_iters*5, gamma*1.2, epsilon, img_dim, original_image, @adaptive, @adaptive_derivative);
ART_image_MRF_adaptive2 = MRF_ART(A, noisy_b,  max_iters*5, gamma*0.8, epsilon, img_dim, original_image, @adaptive, @adaptive_derivative);
fprintf('RRMSE of Adaptive, 1.2*gamma is '); 
disp(rrmse(original_image, ART_image_MRF_adaptive1));
fprintf('RRMSE of Adaptive, 0.8*gamma is '); 
disp(rrmse(original_image, ART_image_MRF_adaptive2));

figure('Name','MarkovART Final Image - Adaptive Discontinuity, 1.2*gamma');
imshow(ART_image_MRF_adaptive1, []);
figure('Name','MarkovART Final Image - Adaptive Discontinuity, 0.8*gamma');
imshow(ART_image_MRF_adaptive2, []);