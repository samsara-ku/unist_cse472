%% TASK 1
[im1, harris_im1, im1_H]= Get_harris('./images/wall/im1.pgm');
target_point = 15000;

% Plotting img with result
[~, idx] = sort(harris_im1(:), 'descend');
[row, col] = ind2sub(size(harris_im1), idx(1:target_point));
% imshow(im1, []); hold on;
% plot(col, row, '+', 'MarkerEdgeColor', 'green');
%% TASK 2
im1_filtered_harris = zeros(640, 800);
for idx = 1:target_point
    im1_filtered_harris(row(idx), col(idx)) = harris_im1(row(idx), col(idx));
end
im1_nms_filtered_harris = Non_maximum_suppression(im1_filtered_harris, 10);

% Plotting img with result
[im1_row, im1_col] = find(im1_nms_filtered_harris);
% imshow(im1, []); hold on;
% plot(im1_col, im1_row, '+', 'MarkerEdgeColor', 'green'); hold on;
% for temp = 1:length(im1_col)
%     text(im1_col(temp)-10, im1_row(temp)-10, num2str(temp), 'color', 'red', 'fontsize', 10)
% end

[im2, harris_im2, im2_H] = Get_harris('./images/wall/im2.pgm');

[~, idx2] = sort(harris_im2(:), 'descend');
[row2, col2] = ind2sub(size(harris_im2), idx2(1:target_point));

im2_filtered_harris = zeros(640, 800);
for idx = 1:target_point
    im2_filtered_harris(row2(idx), col2(idx)) = harris_im2(row2(idx), col2(idx));
end
im2_nms_filtered_harris = Non_maximum_suppression(im2_filtered_harris, 10);

[im2_row, im2_col] = find(im2_nms_filtered_harris);
% imshow(im2, []); hold on;
% plot(im2_col, im2_row, '+', 'MarkerEdgeColor', 'green'); hold on;
% for temp = 1:length(im2_col)
%     text(im2_col(temp)-10, im2_row(temp)-10, num2str(temp), 'color', 'red', 'fontsize', 10)
% end
%% TASK 3
[im1_eigen_vec, im1_eigen_val] = Get_eigen(im1_H);
[im2_eigen_vec, im2_eigen_val] = Get_eigen(im2_H);

result = Get_distance(im1, im2, im1_eigen_vec, im1_eigen_val, im2_eigen_vec, im2_eigen_val, im1_row, im1_col, im2_row, im2_col, "ssd");
result2 = Get_distance(im1, im2, im1_eigen_vec, im1_eigen_val, im2_eigen_vec, im2_eigen_val, im1_row, im1_col, im2_row, im2_col, "ncc");

% To draw heatmap
% colormap('hot')
% imagesc(result2)
% colorbar
%% TASK 4-1
[inlier, homography_matrix, feat_idx] = RANSAC_homo(result, im1_row, im1_col, im2_row, im2_col, 1000000, 21);
tform = projective2d(homography_matrix');
homo_img = imwarp(im1, tform);
[t_row, t_col] = size(homo_img);
 
im1_trans_pos = homography_matrix * [im1_col(feat_idx(1,:))'; im1_row(feat_idx(1,:))'; 1 1 1 1];
im1_trans_pos = im1_trans_pos(1:3, :)./im1_trans_pos(3,:);

temp = zeros(640, 800);
temp(im1_row(feat_idx(1,1)), im1_col(feat_idx(1,1))) = 255;
temp_warped = imwarp(temp, tform);
[target_y, target_x] = find(temp_warped);

dis_x = target_x(1) - im2_col(feat_idx(2, 1));
dis_y = target_y(1) - im2_row(feat_idx(2, 1));

start = 50;
canvas = zeros(1000, 1000, 3);
canvas(start:start+t_row-1, start:start+t_col-1, 1) = cast(homo_img, 'double');
canvas(start+dis_y:start+dis_y+639, start+dis_x:start+dis_x+799, 2) = im2(1:640, 1:800);
imshow(rescale(canvas), []);
%% TASK 4-2
[inlier2, affine_matrix, feat_idx2] = RANSAC_affine(result, im1_row, im1_col, im2_row, im2_col, 1000000, 11);
tform2 = affine2d(affine_matrix');
affine_img = imwarp(im1, tform2);
[a_row, a_col] = size(affine_img);

subplot(1,3,1); imshow(im2, []); hold on;
plot(im2_col(feat_idx2(2,:)), im2_row(feat_idx2(2,:)), '+', 'MarkerEdgeColor', 'green'); hold on;

subplot(1,3,2); imshow(im1, []); hold on;
plot(im1_col(feat_idx2(1,:)), im1_row(feat_idx2(1,:)), '+', 'MarkerEdgeColor', 'green'); hold on;

temp2 = zeros(640, 800);
temp2(im1_row(feat_idx(1,1)), im1_col(feat_idx(1,1))) = 255;
temp_warped2 = imwarp(temp2, tform2);
[target_y2, target_x2] = find(temp_warped2);

dis_x2 = target_x2(1) - im2_col(feat_idx2(2, 1));
dis_y2 = target_y2(1) - im2_row(feat_idx2(2, 1));

start2 = 50;
canvas2 = zeros(1000, 1000, 3);
canvas2(start2:start2+a_row-1, start2:start2+a_col-1, 1) = cast(affine_img, 'double');
canvas2(start2+dis_y2:start2+dis_y2+639, start2+dis_x2:start2+dis_x2+799, 2) = im2(1:640, 1:800);
subplot(1,3,3); imshow(rescale(canvas2), []);
%% TASK 5-1
target_point = 30000;
[im_left, harris_im_left, im_left_H]= Get_harris('./images/panorama/uttower_left.jpg');
[~, idx] = sort(harris_im_left(:), 'descend');
[row, col] = ind2sub(size(harris_im_left), idx(1:target_point));

im_left_filtered_harris = zeros(683, 1024);
for idx = 1:target_point
    im_left_filtered_harris(row(idx), col(idx)) = harris_im_left(row(idx), col(idx));
end
im_left_nms_filtered_harris = Non_maximum_suppression(im_left_filtered_harris, 30);

[im_left_row, im_left_col] = find(im_left_nms_filtered_harris);
subplot(1, 4, 1); imshow(im_left, []); hold on;
plot(im_left_col, im_left_row, '+', 'MarkerEdgeColor', 'green'); hold on;
for temp = 1:length(im_left_col)
    text(im_left_col(temp)-10, im_left_row(temp)-10, num2str(temp), 'color', 'red', 'fontsize', 10)
end

[im_right, harris_im_right, im_right_H] = Get_harris('./images/panorama/uttower_right.jpg');
[~, idx2] = sort(harris_im_right(:), 'descend');
[row2, col2] = ind2sub(size(harris_im_right), idx2(1:target_point));

im_right_filtered_harris = zeros(683, 1024);
for idx = 1:target_point
    im_right_filtered_harris(row2(idx), col2(idx)) = harris_im_right(row2(idx), col2(idx));
end
im_right_nms_filtered_harris = Non_maximum_suppression(im_right_filtered_harris, 30);

[im_right_row, im_right_col] = find(im_right_nms_filtered_harris);
subplot(1, 4, 2); imshow(im_right, []); hold on;
plot(im_right_col, im_right_row, '+', 'MarkerEdgeColor', 'green'); hold on;
for temp = 1:length(im_right_col)
    text(im_right_col(temp)-10, im_right_row(temp)-10, num2str(temp), 'color', 'red', 'fontsize', 10)
end

im_left_filtered_row = [];
im_left_filtered_col = [];
im_right_filtered_row = [];
im_right_filtered_col = [];

for i = 1:length(im_left_col)
    if (im_left_col(i) > 1024*2/3)
        im_left_filtered_row = [im_left_filtered_row; im_left_row(i)];
        im_left_filtered_col = [im_left_filtered_col; im_left_col(i)];
    end
end

for i = 1:length(im_right_col)
    if (im_right_col(i) < 1024/2)
        im_right_filtered_row = [im_right_filtered_row; im_right_row(i)];
        im_right_filtered_col = [im_right_filtered_col; im_right_col(i)];
    end
end

subplot(1, 4, 3); imshow(im_left, []); hold on;
plot(im_left_filtered_col, im_left_filtered_row, '+', 'MarkerEdgeColor', 'green'); hold on;
for temp = 1:length(im_left_filtered_row)
    text(im_left_filtered_col(temp)-10, im_left_filtered_row(temp)-10, num2str(temp), 'color', 'red', 'fontsize', 10)
end

subplot(1, 4, 4); imshow(im_right, []); hold on;
plot(im_right_filtered_col, im_right_filtered_row, '+', 'MarkerEdgeColor', 'green'); hold on;
for temp = 1:length(im_right_filtered_col)
    text(im_right_filtered_col(temp)-10, im_right_filtered_row(temp)-10, num2str(temp), 'color', 'red', 'fontsize', 10)
end
%% TASK 5-2
[im_left_eigen_vec, im_left_eigen_val] = Get_eigen(im_left_H);
[im_right_eigen_vec, im_right_eigen_val] = Get_eigen(im_right_H);

result3 = Get_distance(im_left, im_right, im_left_eigen_vec, im_left_eigen_val, im_right_eigen_vec, im_right_eigen_val, im_left_filtered_row, im_left_filtered_col, im_right_filtered_row, im_right_filtered_col, "ssd");
%% TASK 5-3
[inlier, homography_matrix, feat_idx] = RANSAC_homo(result3, im_left_filtered_row, im_left_filtered_col, im_right_filtered_row, im_right_filtered_col, 500000, 11);
tform = projective2d(homography_matrix');
homo_img = imwarp(im_left, tform);
[t_row, t_col] = size(homo_img);

subplot(1,2,1); imshow(im_right, []); hold on;
plot(im_right_filtered_col(feat_idx(2,:)), im_right_filtered_row(feat_idx(2,:)), '+', 'MarkerEdgeColor', 'green'); hold on;
 
im_left_trans_pos = homography_matrix * [im_left_col(feat_idx(1,:))'; im_left_row(feat_idx(1,:))'; 1 1 1 1];
im_left_trans_pos = im_left_trans_pos(1:3, :)./im_left_trans_pos(3,:);
 
subplot(1,2,2); imshow(im_left, []); hold on;
plot(im_left_filtered_col(feat_idx(1,:)), im_left_filtered_row(feat_idx(1,:)), '+', 'MarkerEdgeColor', 'green'); hold on;

temp = zeros(683, 1024);
temp(im_left_row(feat_idx(1,1)), im_left_row(feat_idx(1,1))) = 255;
temp_warped = imwarp(temp, tform);
[target_y, target_x] = find(temp_warped);

dis_x = target_x(1) - im_right_col(feat_idx(2, 1));
dis_y = target_y(1) - im_right_row(feat_idx(2, 1));

start = 300;
canvas = zeros(2000, 2000, 3);
canvas(start:start+t_row-1, start:start+t_col-1, 1) = cast(homo_img, 'double');
canvas(start+dis_y:start+dis_y+639, start+dis_x:start+dis_x+799, 2) = im_right(1:640, 1:800);
% imshow(rescale(canvas), []);
hold off;
%%
points1 = detectHarrisFeatures(im_left);
points2 = detectHarrisFeatures(im_right);

[features1,valid_points1] = extractFeatures(im_left,points1);
[features2,valid_points2] = extractFeatures(im_right,points2);

indexPairs = matchFeatures(features1, features2) ;
matchedPoints1 = valid_points1(indexPairs(1:20, 1));
matchedPoints2 = valid_points2(indexPairs(1:20, 2));

figure; ax = axes;
showMatchedFeatures(im_left,im_right,matchedPoints1,matchedPoints2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');