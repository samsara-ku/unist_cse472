function [result, x1_diff, y1_diff, x2_diff, y2_diff] = align_img(img, criteria)
    [h, w] = size(img);
    ratio = floor(h/3);
    
    B_img = img(1:ratio, :);
    G_img = img(ratio+1:ratio*2, :);
    R_img = img(ratio*2+1:ratio*3, :);
    
    if criteria == "red"
        c = normxcorr2(G_img, R_img);
        d = normxcorr2(B_img, R_img);
        [c_peak_y, c_peak_x] = find(c==max(c(:)));
        [d_peak_y, d_peak_x] = find(d==max(d(:)));
        
    elseif criteria == "green"
        c = normxcorr2(R_img, G_img);
        d = normxcorr2(B_img, G_img);
        [c_peak_y, c_peak_x] = find(c==max(c(:)));
        [d_peak_y, d_peak_x] = find(d==max(d(:)));
        
    elseif criteria == "blue"
        c = normxcorr2(R_img, B_img);
        d = normxcorr2(G_img, B_img);
        [c_peak_y, c_peak_x] = find(c==max(c(:)));
        [d_peak_y, d_peak_x] = find(d==max(d(:)));
        
    end
    
    c_diff_y = c_peak_y - ratio;
    c_diff_x = c_peak_x - w;

    d_diff_y = d_peak_y - ratio;
    d_diff_x = d_peak_x - w;
    
    if criteria == "red"
        shifted_G_img = circshift(G_img, [c_diff_y, c_diff_x]);
        shifted_B_img = circshift(B_img, [d_diff_y, d_diff_x]);
        
        x1_diff = c_diff_x;
        y1_diff = c_diff_y;
        x2_diff = d_diff_x;
        y2_diff = d_diff_y;
        result = cat(3, R_img, shifted_G_img, shifted_B_img);
        
    elseif criteria == "green"
        shifted_R_img = circshift(R_img, [c_diff_y, c_diff_x]);
        shifted_B_img = circshift(B_img, [d_diff_y, d_diff_x]);
        
        x1_diff = c_diff_x;
        y1_diff = c_diff_y;
        x2_diff = d_diff_x;
        y2_diff = d_diff_y;
        result = cat(3, shifted_R_img, G_img, shifted_B_img);
        
    elseif criteria == "blue"
        shifted_R_img = circshift(R_img, [c_diff_y, c_diff_x]);
        shifted_G_img = circshift(G_img, [d_diff_y, d_diff_x]);
        
        x1_diff = c_diff_x;
        y1_diff = c_diff_y;
        x2_diff = d_diff_x;
        y2_diff = d_diff_y;
        result = cat(3, shifted_R_img, shifted_G_img, B_img);
        
    end
end