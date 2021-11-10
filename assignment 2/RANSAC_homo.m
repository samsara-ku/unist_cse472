function [inlier, H, feat_idx] = RANSAC_homo(dismat, row1, col1, row2, col2, threshold, num_inlier)
    [v, d] = min(dismat, [], 2);
    inlier = 0;
    H = [];
    feat_idx = [];
    ratio = num_inlier / length(v);
    N = log(1-0.99) / log(1-ratio^4);
    
    for i = 1:N
        temp_inlier = 0;
        im1_min_idx = randsample(find(v(:) < threshold), 4)';
        im2_min_idx = d(im1_min_idx)';

        im1_min_coord = [col1(im1_min_idx)'; row1(im1_min_idx)'];
        im2_min_coord = [col2(im2_min_idx)'; row2(im2_min_idx)'];

        [~, H_matrix] = Get_homomat(im1_min_coord, im2_min_coord);
        H_matrix = reshape([H_matrix; 1], 3, 3)';
        
        for j = 1:length(row1)
            ori_homo = H_matrix * [col1(j); row1(j); 1];
            ori_homo = ori_homo / ori_homo(3);
            
            if find(im1_min_idx(:) ~= j)
                trans = [col2(d(j)); row2(d(j)); 1];
                
                if sum((ori_homo - trans).^2) < 4
                    temp_inlier = temp_inlier + 1;
                end
            end
        end
        
        if temp_inlier > inlier
            inlier = temp_inlier;
            H = H_matrix;
            feat_idx = [im1_min_idx; im2_min_idx];
        end
    end
end