function [img, f_harris, H] = Get_harris(image)
    img = imread(image);
    img = rescale(img);
    [height, width, dim] = size(img);
    
    if dim == 3
        img = rgb2gray(img);
    end

    g_filter = fspecial('gaussian', 5, 0.5);
    x_filter = [-1 0 1; -1 0 1; -1 0 1;];
    y_filter = x_filter';

    % Making smooth im1 to reduce noise
    smooth_img = filter2(g_filter, img);

    % Compute image gradient using sobel filter
    gx = filter2(x_filter, smooth_img);
    gy = filter2(y_filter, smooth_img);

    gxgx = gx.*gx;
    gxgy = gx.*gy;
    gygy = gy.*gy;

    % Compute H matrix and harris operator
    H = zeros(2, 2, height, width);
    f_harris = zeros(height, width);
    gxgx_filtered = filter2(ones(11), gxgx);
    gxgy_filtered = filter2(ones(11), gxgy);
    gygy_filtered = filter2(ones(11), gygy);

    for y = 1:height
        for x = 1:width
            H(1, 1, y, x) = gxgx_filtered(y, x);
            H(1, 2, y, x) = gxgy_filtered(y, x);
            H(2, 1, y, x) = gxgy_filtered(y, x);
            H(2, 2, y, x) = gygy_filtered(y, x);
            f_harris(y, x) = det(H(:, :, y, x)) - 0.04 * trace(H(:, :, y, x)).^2;
        end
    end
end