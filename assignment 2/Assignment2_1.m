% TASK 1
[im1, ] = imread('./images/wall/im1.pgm');
[height, width, ] = size(im1);

g_filter = fspecial('gaussian', 5, 0.5);
x_filter = fspecial('sobel');
y_filter = x_filter';

% Making smooth im1 to reduce noise
smooth_im1 = filter2(g_filter, im1);
% subplot(1,2,1); imshow(im1);
% subplot(1,2,2); imshow(uint8(smooth_im1));

% Compute image gradient using sobel filter
gx = filter2(x_filter, smooth_im1);
gy = filter2(y_filter, smooth_im1);
% subplot(1,2,1); imshow(gx);
% subplot(1,2,2); imshow(gy);

gxgx = gx.*gx;
gxgy = gx.*gy;
gygy = gy.*gy;

% Compute H matrix and harris operator
H = zeros(2, 2, height, width);
f_harris = zeros(height, width);
gxgx_filtered = filter2(ones(21), gxgx);
gxgy_filtered = filter2(ones(21), gxgy);
gygy_filtered = filter2(ones(21), gygy);

for y = 1:height
    for x = 1:width
        H(1,1,y,x) = gxgx_filtered(y, x);
        H(1,2,y,x) = gxgy_filtered(y, x);
        H(2,1,y,x) = gxgy_filtered(y, x);
        H(2,2,y,x) = gygy_filtered(y, x);
        f_harris(y,x) = det(H(:,:,y,x)) - 0.04 * trace(H(:,:,y,x)).^2;
    end
end

% Plotting img with result
[~, idx] = sort(f_harris(:), 'descend');
[row, col] = ind2sub([height, width], idx(1:1000));
subplot(1, 3, 1); imshow(im1, []); hold on;
plot(col, row, '+', 'MarkerEdgeColor', 'green');

% TASK 2
filtered_f_harris = Non_maximum_suppression(f_harris);
[~, idx] = sort(filtered_f_harris(:), 'descend');
[row, col] = ind2sub([height, width], idx(1:100));
subplot(1, 3, 2); imshow(im1, []); hold on;
plot(col, row, '+', 'MarkerEdgeColor', 'green');

% For testing built-in harris corner detection
corners = detectHarrisFeatures(im1);
subplot(1, 3, 3); imshow(im1, []); hold on;
plot(corners.selectStrongest(100));