function result = remove_black(img, ratio)
	[h, w] = size(img);
    
    i_w = floor(w * ratio / 100);
%     i_h = floor(h * ratio / 100);
    
    result = img(:, i_w: w-i_w);
end