function [eigen_vec, eigen_val] = Get_eigen(H)
    [~, ~, height, width] = size(H);
    eigen_vec = zeros(2, 2, height, width);
    eigen_val = zeros(2, height, width);

    for y = 1:height
        for x = 1:width
            [V, D] = eig(H(:, :, y, x));
            [d, ind] = sort(diag(D), 'descend');
            Ds = D(ind, ind);
            Vs = V(:, ind);
            eigen_vec(:, :, y, x) = Vs;
            eigen_val(:, y, x) = d;
        end
    end
end