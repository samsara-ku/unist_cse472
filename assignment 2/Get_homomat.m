function [promat, x] = Get_homomat(ori, trans)
    promat = zeros(8, 8);
    for idx = 1:length(ori)
        promat(idx*2-1, :) = [ori(1, idx) ori(2, idx) 1 0 0 0 -ori(1, idx)*trans(1, idx) -ori(2, idx)*trans(1, idx)];
        promat(idx*2, :) = [0 0 0 ori(1, idx) ori(2, idx) 1 -ori(1, idx)*trans(2, idx) -ori(2, idx)*trans(2, idx)];
    end
    
    x = promat \ reshape(trans, 1, 8)';
end