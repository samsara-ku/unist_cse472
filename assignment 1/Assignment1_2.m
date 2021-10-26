file_name = '00398v';
[concat_img] = imread(strcat('./data/', file_name, '.jpg'));

[h, w] = size(concat_img);
ratio = floor(h/3);

% TASK 4
B_img = concat_img(1:ratio, :);
G_img = concat_img(ratio+1:ratio*2, :);
R_img = concat_img(ratio*2+1:ratio*3, :);

% For checking result of naive alignment
color_img = cat(3, R_img, G_img, B_img);

imwrite(color_img, strcat(file_name, '.png'));


% TASK 5
[r_result, r_x1, r_y1, r_x2, r_y2] = align_img(concat_img, "red");
[g_result, g_x1, g_y1, g_x2, g_y2] = align_img(concat_img, "green");
[b_result, b_x1, b_y1, b_x2, b_y2] = align_img(concat_img, "blue");

subplot(3,3,1), imshow(r_result);
subplot(3,3,2), imshow(g_result);
subplot(3,3,3), imshow(b_result);

% Option 2 with remove white border
concat_img_xw = remove_white(concat_img);

[r_result_xw, r_x1_xw, r_y1_xw, r_x2_xw, r_y2_xw] = align_img(concat_img_xw, "red");
[g_result_xw, g_x1_xw, g_y1_xw, g_x2_xw, g_y2_xw] = align_img(concat_img_xw, "green");
[b_result_xw, b_x1_xw, b_y1_xw, b_x2_xw, b_y2_xw] = align_img(concat_img_xw, "blue");

subplot(3,3,4), imshow(r_result_xw);
subplot(3,3,5), imshow(g_result_xw);
subplot(3,3,6), imshow(b_result_xw);

% Option 2 with remove black border
concat_img_xw_xb = remove_black(remove_white(concat_img), 5);

[r_result_xw_xb, r_x1_xw_xb, r_y1_xw_xb, r_x2_xw_xb, r_y2_xw_xb] = align_img(concat_img_xw_xb, "red");
[g_result_xw_xb, g_x1_xw_xb, g_y1_xw_xb, g_x2_xw_xb, g_y2_xw_xb] = align_img(concat_img_xw_xb, "green");
[b_result_xw_xb, b_x1_xw_xb, b_y1_xw_xb, b_x2_xw_xb, b_y2_xw_xb] = align_img(concat_img_xw_xb, "blue");

subplot(3,3,7), imshow(r_result_xw_xb);
subplot(3,3,8), imshow(g_result_xw_xb);
subplot(3,3,9), imshow(b_result_xw_xb);