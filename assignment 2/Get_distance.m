function [dis] = Get_distance(img1, img2, eig_vec1, eig_val1, eig_vec2, eig_val2, row1, col1, row2, col2, type)
    dis = zeros(length(row1), length(row2));
    p_size = 21;
    
    for idx1 = 1:length(row1)
        patch1 = zeros(p_size);
        tform1 = Get_rotmat(eig_vec1(:, :, row1(idx1), col1(idx1)), eig_val1);
        rotated_img1 = imwarp(img1, tform1);
        [height1, width1] = size(rotated_img1);
        
        temp1 = zeros(640, 800);
        temp1(row1(idx1), col1(idx1)) = 255;
        rotated_temp1 = imwarp(temp1, tform1);
        [y1_start, x1_start] = find(rotated_temp1);
        y1_start = y1_start(1) - 10;
        x1_start = x1_start(1) - 10;

        for y1 = 1:p_size
            cur_y1 = y1_start + y1 - 1;

            for x1 = 1:p_size
                cur_x1 = x1_start + x1 - 1;

                if (1 <= cur_x1 && cur_x1 <= width1) && (1 <= cur_y1 && cur_y1 <= height1)
                    patch1(y1, x1) = rotated_img1(cur_y1, cur_x1);
                end
            end
        end
        
        for idx2 = 1:length(row2)
            patch2 = zeros(p_size);
            tform2 = Get_rotmat(eig_vec2(:, :, row2(idx2), col2(idx2)), eig_val2);
            rotated_img2 = imwarp(img2, tform2);
            [height2, width2] = size(rotated_img2);
            
            temp2 = zeros(640, 800);
            temp2(row2(idx2), col2(idx2)) = 255;
            rotated_temp2 = imwarp(temp2, tform2);
            [y2_start, x2_start] = find(rotated_temp2);
            y2_start = y2_start(1) - 10;
            x2_start = x2_start(1) - 10;

            for y2 = 1:p_size
                cur_y2 = y2_start + y2 - 1;

                for x2 = 1:p_size
                    cur_x2 = x2_start + x2 - 1;

                    if (1 <= cur_x2 && cur_x2 <= width2) && (1 <= cur_y2 && cur_y2 <= height2)
                        patch2(y2, x2) = rotated_img2(cur_y2, cur_x2);
                    end
                end
            end
            
            if type == "ssd"
                dis(idx1, idx2) = sum((patch1 - patch2).^2, 'all');
            elseif type == "ncc"
                dis(idx1, idx2) = sum((patch1 - mean(patch1, 'all')).*(patch2 - mean(patch2, 'all')), 'all') / (std(patch1, 0, 'all') * std(patch2, 0, 'all') * p_size * p_size);
            end
        end
    end
end