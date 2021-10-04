[mosiac_img, map] = imread('./mosaic/crayons_mosaic.bmp');
ground_truth = imread('./mosaic/crayons.jpg');
[row, col, ] = size(mosiac_img);

result_img = zeros(row, col, 3, 'uint8');

% TASK 1
for y=1:row
    for x=1:col
       if mod(y, 2) ~= 0 && mod(x, 2) ~= 0
           result_img(y, x, 1) = mosiac_img(y, x);
       elseif (mod(y, 2) == 0 && mod(x, 2) ~= 0) || (mod(y, 2) ~= 0 && mod(x, 2) == 0)
           result_img(y, x, 2) = mosiac_img(y, x);
       elseif mod(y, 2) == 0 && mod(x, 2) == 0
           result_img(y, x, 3) = mosiac_img(y, x);
       end
    end
end

% Just for checking RGB value
red_img = result_img(:,:,1);
green_img = result_img(:,:,2);
blue_img = result_img(:,:,3);

% TASK 2
r_filter = [1/4,1/2,1/4; 1/2,1,1/2; 1/4,1/2,1/4];
g_filter = [0,0,0; 0,1,1/2; 0,1/2,0];
b_filter = [1/4,1/2,1/4; 1/2,1,1/2; 1/4,1/2,1/4];

bilinear_r = filter2(r_filter, red_img);
bilinear_g = filter2(g_filter, green_img);
bilinear_b = filter2(b_filter, blue_img);

result_img(:,:,1) = bilinear_r;
result_img(:,:,2) = bilinear_g;
result_img(:,:,3) = bilinear_b;

% For checking difference between gt and interpolated result
subplot(1,4,1), imshow(imcrop(ground_truth, [290 250 100 100]));
subplot(1,4,2), imshow(imcrop(result_img, [290 250 100 100]));

% TASK 3
r_err = (ground_truth(:,:,1) - result_img(:,:,1));
g_err = (ground_truth(:,:,2) - result_img(:,:,2));
b_err = (ground_truth(:,:,3) - result_img(:,:,3));
squr_err = r_err.^2 + g_err.^2 + b_err.^2;

avg_err = mean(squr_err, 'all');
max_err = max(squr_err, [], 'all');

% For checking squr err
subplot(1,4,3), imshow(squr_err);
subplot(1,4,4), imshow(squr_err, [0, avg_err]);