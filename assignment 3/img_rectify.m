function [l_warped_img, r_warped_img, epi] = img_rectify(num_left, num_right, data)
    % Please input larger number in num_left than num_right     
    file_list = dir('./data/images/*.jpg');
    i_param = importdata('./data/Calibration.txt');

    epi = data{num_left}(:, 4) - data{num_left}(1:3, 1:3) * data{num_right}(1:3, 1:3).' * data{num_right}(:, 4);

    r1 = epi.' / norm(epi);
    r2 = (1 / sqrt(r1(1)^2+r1(2)^2)) * [-r1(2) r1(1) 0];
    r3 = cross(r1, r2);

    R1 = [r1; r2; r3];
    R2 = R1 * data{num_left}(1:3, 1:3) * data{num_right}(1:3, 1:3).';

    img_left = rescale(imread(append('./data/images/', file_list(num_left).name)));
    img_right = rescale(imread(append('./data/images/', file_list(num_right).name)));

    l_warp = i_param * R1 * inv(i_param);
    r_warp = i_param * R2 * inv(i_param);

    l_warped_img = imwarp(img_left, projective2d(l_warp.'));
    r_warped_img = imwarp(img_right, projective2d(r_warp.'));
    
    [l_h, l_w, ~] = size(l_warped_img);
    [r_h, r_w, ~] = size(r_warped_img);
    
    figure
    imshowpair(l_warped_img, r_warped_img, 'montage'); hold on;
    
    for i=0:50:(l_h+r_h)
        plot([0 l_w+r_w], [i i],'Color','r','LineWidth', 1);
	end
end

