function [result] = Non_maximum_suppression(harris, window)
    [height, width] = size(harris);
    result = zeros(height, width);

    for y = 1:height
        for x = 1:width
            x_start = x - window;
            x_end = x + window;
            y_start = y - window;
            y_end = y + window;

            if x_start < 1
                x_start = 1;
            elseif x_end > width
                x_end = width;
            end

            if y_start < 1
                y_start = 1;
            elseif y_end > height
                y_end = height;
            end

            if max(harris(y_start:y_end, x_start:x_end), [], 'all') == harris(y, x)
                result(y, x) = harris(y, x);
            end
        end
    end
end