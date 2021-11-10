function [affinemat, x] = Get_affinemat(ori, trans)
    affinemat = zeros(6, 6);
    for idx = 1:length(ori)
        affinemat(idx*2-1, :) = [ori(1, idx) ori(2, idx) 0 0 1 0];
        affinemat(idx*2, :) = [0 0 ori(1, idx) ori(2, idx) 0 1];
    end
    
    x = affinemat \ reshape(trans, 1, 6)';
end