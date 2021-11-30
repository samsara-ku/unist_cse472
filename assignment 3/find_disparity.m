function disparity = find_disparity(img_left, img_right, w_size, option)
    half_w = (w_size-1)/2;
    disparity = zeros(700, 1000);
    
    c_pad = zeros(700, half_w, 3);
    img_left = [c_pad img_left c_pad];
    img_right = [c_pad img_right c_pad];
    
    r_pad = zeros(half_w, size(img_left, 2), 3);
    img_left = [r_pad; img_left; r_pad];
    img_right = [r_pad; img_right; r_pad];

    if strcmp(option, 'normal')
        for l_row=1:700
            for l_col=1:1000
                min_val = inf;
                for r_col=1:l_col
                    ssd = sum((img_left(l_row:l_row+w_size-1, l_col:l_col+w_size-1)-img_right(l_row:l_row+w_size-1, r_col:r_col+w_size-1)).^2, 'all');

                    if ssd < min_val
                        min_val = ssd;
                        disparity(l_row, l_col) = r_col - l_col;
                    end
                end
            end
        end    
    elseif strcmp(option, 'interpolation')
        for l_row=1:700
            for l_col=1:1000
                min_val = inf;
                min_loc = 0;
                ssd_box = zeros(1, l_col);
                for r_col=1:l_col
                    ssd = sum((img_left(l_row:l_row+w_size-1, l_col:l_col+w_size-1)-img_right(l_row:l_row+w_size-1, r_col:r_col+w_size-1)).^2, 'all');
                    ssd_box(1, r_col) = ssd;
                    if ssd < min_val
                        min_val = ssd;
                        min_loc = r_col;
                    end
                end
                
                ssd_box_extended = [ssd_box(1) ssd_box ssd_box(l_col)];
                c_left = -ssd_box_extended(min_loc);
                c_center = -ssd_box_extended(min_loc+1);
                c_right = -ssd_box_extended(min_loc+2);
                if (c_center ~= min(c_left, c_right))
                    disparity(l_row, min_loc) = (min_loc - l_col) + (c_right-c_left)/(2*(c_center - min(c_left, c_right)));
                else
                    disparity(l_row, l_col) = min_loc - l_col;
                end
            end
        end
    end
end
