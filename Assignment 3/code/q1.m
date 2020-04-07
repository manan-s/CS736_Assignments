img = double(imread("../data/SheppLogan256.png"));
theta = 0:5:179;
[rdn, xp] = radon(img, theta);

%%
figure(1);
subplot(1, 2, 1);
imshow(img, []);
title("Original Image");
subplot(1,2,2);
imshow(rdn, [], 'Xdata', theta, 'Ydata', xp, 'InitialMagnification', 'fit');
title("Radon Transform");
colormap(gca, hot);
colorbar;

%%
figure(2);
filteredImg = iradon(rdn, theta, 'linear', 'none');
imshow(filteredImg, []);
title("Backprojection");

%%
figure(3);
sgtitle("Filtered Backprojection");
L = 0.5*pi;

subplot(2,3,1);
filteredImg = myFilter(rdn, L, "Ram-Lak");
InvRdn = 0.5*iradon(filteredImg, theta, 'linear', 'none', 1, 256);
imshow(InvRdn, []);
title("Ram-Lak");
ylabel("L = 0.5*w_{max}");
xlabel(sprintf("RRMSE %f", rrmse(img, InvRdn)));

subplot(2,3,2);
filteredImg = myFilter(rdn, L, "Shepp-Logan");
InvRdn = 0.5*iradon(filteredImg, theta, 'linear', 'none', 1, 256);
imshow(InvRdn, []);
title("Shepp-Logan");
xlabel(sprintf("%f", rrmse(img, InvRdn)));

subplot(2,3,3);
filteredImg = myFilter(rdn, L, "Cosine");
InvRdn = 0.5*iradon(filteredImg, theta, 'linear', 'none', 1, 256);
imshow(InvRdn, []);
title("Cosine");
xlabel(sprintf("%f", rrmse(img, InvRdn)));

L = pi;

subplot(2,3,4);
filteredImg = myFilter(rdn, L, "Ram-Lak");
InvRdn = 0.5*iradon(filteredImg, theta, 'linear', 'none', 1, 256);
imshow(InvRdn, []);
title("Ram-Lak");
ylabel("L = w_{max}");
xlabel(sprintf("RRMSE %f", rrmse(img, InvRdn)));

subplot(2,3,5);
filteredImg = myFilter(rdn, L, "Shepp-Logan");
InvRdn = 0.5*iradon(filteredImg, theta, 'linear', 'none', 1, 256);
imshow(InvRdn, []);
title("Shepp-Logan");
xlabel(sprintf("%f", rrmse(img, InvRdn)));

subplot(2,3,6);
filteredImg = myFilter(rdn, L, "Cosine");
InvRdn = 0.5*iradon(filteredImg, theta, 'linear', 'none', 1, 256);
imshow(InvRdn, []);
title("Cosine");
xlabel(sprintf("%f", rrmse(img, InvRdn)));

%% ==================== 1 (b) =============================
S0 = double(img);
S1 = imgaussfilt(S0, 1);
S5 = imgaussfilt(S0, 5);

figure(4);
sgtitle("Gaussian Filtered SheppLogan Images");
subplot(1,3,1);
imshow(S0, []);
title("S_0");

subplot(1,3,2);
imshow(S1, []);
title("S_1");

subplot(1,3,3);
imshow(S5, []);
title("S_5");

%%
figure(6);
sgtitle("Backprojections of Gaussian Filtered SheppLogan Image");

Rdn0 = radon(S0, theta);
Rdn1 = radon(S1, theta);
Rdn5 = radon(S5, theta);

L = pi;

subplot(1,3,1);
F0 = myFilter(Rdn0, L, "Ram-Lak");
R0 = 0.5*iradon(F0, theta, 'linear', 'none', 1, 256);
imshow(R0, []);
title("R_0");

subplot(1, 3, 2);
F1 = myFilter(Rdn1, L, "Ram-Lak");
R1 = 0.5*iradon(F1, theta, 'linear', 'none', 1, 256);
imshow(R1, []);
title("R_1");

subplot(1,3,3);
F5 = myFilter(Rdn5, L, "Ram-Lak");
R5 = 0.5*iradon(F5, theta, 'linear', 'none', 1, 256);
imshow(R5, []);
title("R_5");

% RRMSE
rrmse0 = rrmse(S0, R0);
rrmse1 = rrmse(S1, R1);
rrmse5 = rrmse(S5, R5);

fprintf("============== 1 (b) ================");
fprintf("\nRRMSE(S0, R0) = %f", rrmse0);
fprintf("\nRRMSE(S1, R1) = %f", rrmse1);
fprintf("\nRRMSE(S5, R5) = %f\n", rrmse5);

%% ===================== 1 (c) ====================
N = size(Rdn0, 1);
Errors0 = zeros(N, 1);
Errors1 = zeros(N, 1);
Errors5 = zeros(N, 1);

for i = 1:N
    L = i*pi/N;
    f0 = myFilter(Rdn0, L, "Ram-Lak");
    f1 = myFilter(Rdn1, L, "Ram-Lak");
    f5 = myFilter(Rdn5, L, "Ram-Lak");
    
    r0 = 0.5*iradon(f0, theta, 'linear', 'none', 1, 256);
    r1 = 0.5*iradon(f1, theta, 'linear', 'none', 1, 256);
    r5 = 0.5*iradon(f5, theta, 'linear', 'none', 1, 256);
    
    Errors0(i) = rrmse(S0, r0);
    Errors1(i) = rrmse(S1, r1);
    Errors5(i) = rrmse(S5, r5);
end

L_range = pi/N*(1:N);
figure(7);
plot(L_range, Errors0);
title("RRMSE(S0, R0) vs L");

figure(8);
plot(L_range, Errors1);
title("RRMSE(S1, R1) vs L");

figure(9);
plot(L_range, Errors5);
title("RRMSE(S5, R5) vs L");


