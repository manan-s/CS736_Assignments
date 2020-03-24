image_folder = '..\data\leaf\data\data';
filenames = dir(fullfile(image_folder, '*.png'));
total_images = numel(filenames);

num = 32;

raw_point_data = zeros(total_images, num, 2);

for n = 1:total_images
    f = fullfile(image_folder, filenames(n).name);
    image = imread(f);
    image = imresize(image, [500 300]);
    BW = im2bw(image,0.8);
    imshow(BW);

    hold on;
    for i = 1:num
        [xi, yi, but] = ginput(1);      % get a point
        raw_point_data(n,i,1) = floor(xi);
        raw_point_data(n,i,2) = floor(yi);
    end
    hold off;
end

save('pointCapture_leaf', 'raw_point_data');