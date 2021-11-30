%% TASK 1
f_list = dir('./data/cam-poses/*.txt');
data = cell(1, length(f_list));
cam_center = cell(1, length(f_list));

for k = 1:length(f_list)
    data{k} = importdata(append('./data/cam-poses/', f_list(k).name));
    cam_center{k} = -data{k}(1:3, 1:3).' * data{k}(:, 4);
end
%% TASK 2
[warped_left_img, warped_right_img, e] = img_rectify(12, 11, data);
%% TASK 3
w_size = 25;
crop_size = [25 50 999 699];

cropped_left = imcrop(warped_left_img, crop_size);
cropped_right = imcrop(warped_right_img, crop_size);
%% TASK 3
disparity = find_disparity(cropped_left, cropped_right,  25, 'normal');
disparity2 = find_disparity(cropped_left, cropped_right,  13, 'normal');
disparity3 = find_disparity(cropped_left, cropped_right,  5, 'normal');
%% TASK 4
f = importdata('./data/Calibration.txt');
f_avg = (f(1,1)+f(2,2))/2;
points = zeros(700, 1000, 3);

for i=1:700
    for j=1:1000
        z = f_avg * norm(e) / disparity(i, j);
        x = i * z / f_avg;
        y = j * z / f_avg;
        points(i, j, :) = [x y z];
    end
end
%% TASK 5
ply_file = fopen('result.ply','w');
count = 0;

for i=1:700
    for j=1:1000
        if points(i, j, 3) ~= Inf
            count = count + 1;
            form = [points(i, j, 1) points(i, j, 2) points(i, j, 3) round(cropped_left(i, j, 1) * 255) round(cropped_left(i, j, 2) * 255) round(cropped_left(i, j, 3) * 255)];
            fprintf(ply_file, '%f %f %f %d %d %d\n', form);
        end
    end
end

fclose(ply_file);
%% TASK OPTION1-1(Calculate disparity map, too long task)
disparity4 = find_disparity(cropped_left, cropped_right,  25, 'interpolation');
%% TASK OPTION1-2
points2 = zeros(700, 1000, 3);

for i=1:700
    for j=1:1000
        z = f_avg * norm(e) / disparity4(i, j);
        x = i * z / f_avg;
        y = j * z / f_avg;
        points2(i, j, :) = [x y z];
    end
end

ply_file2 = fopen('result2.ply','w');
count2 = 0;

for i=1:700
    for j=1:1000
        if points2(i, j, 3) ~= Inf
            count2 = count2 + 1;
            form = [points2(i, j, 1) points2(i, j, 2) points2(i, j, 3) round(cropped_left(i, j, 1) * 255) round(cropped_left(i, j, 2) * 255) round(cropped_left(i, j, 3) * 255)];
            fprintf(ply_file2, '%f %f %f %d %d %d\n', form);
        end
    end
end

fclose(ply_file2);