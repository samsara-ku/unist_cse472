[concat_img] = imread('./data_hires/01657u.tif');

[h, w] = size(concat_img);
ratio = floor(h/3);

B_img = concat_img(1:ratio, :);
G_img = concat_img(ratio+1:ratio*2, :);
R_img = concat_img(ratio*2+1:ratio*3, :);

% For checking result of naive alignment
color_img = cat(3, R_img, G_img, B_img);
% subplot(1,4,1), imshow(color_img)

% Option 2
temp = cast(concat_img/2^8, 'uint8');

concat_img_xw = remove_white(temp);
 
[r_result_xw, r_x1_xw, r_y1_xw, r_x2_xw, r_y2_xw] = align_img(concat_img_xw, "red");
[g_result_xw, g_x1_xw, g_y1_xw, g_x2_xw, g_y2_xw] = align_img(concat_img_xw, "green");
[b_result_xw, b_x1_xw, b_y1_xw, b_x2_xw, b_y2_xw] = align_img(concat_img_xw, "blue");

imwrite(r_result_xw, '01657u_red_base_xw.png')
imwrite(g_result_xw, '01657u_green_base_xw.png')
imwrite(b_result_xw, '01657u_blue_base_xw.png')

% subplot(1,4,2), imshow(r_result_xw);
% subplot(1,4,3), imshow(g_result_xw);
% subplot(1,4,4), imshow(b_result_xw);