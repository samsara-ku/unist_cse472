function [rotmat] = Get_rotmat(vec, val)
    if (vec(1, 1) < 0)
        vec(:, 1) = -vec(:, 1); 
    end
    
    if (vec(1, 2) < 0)
        vec(:, 2) = -vec(:, 2);
    end
    
    composed_vetor = [(vec(:,1) * sqrt(val(1)/val(2)))' 0; vec(:,2)' 0; 0 0 1];
    
    rotmat = affine2d(composed_vetor);
end