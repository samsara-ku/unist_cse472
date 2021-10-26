function result = remove_white(img)

    mean_col = mean(img, 1);
    mean_row = mean(img, 2);
    col_index = find(mean_col < 170);
    row_index = find(mean_row < 170);
    
    x_min = min(col_index);
    x_max = max(col_index);
    y_min = min(row_index);
    y_max = max(row_index);
    
    result = imcrop(img, [x_min y_min x_max-x_min y_max-y_min]);
end
