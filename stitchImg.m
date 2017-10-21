function stitched_img = stitchImg(varargin)
    ransac_n = 1000; % Max number of iteractions
    ransac_eps = 5; % Acceptable alignment error 
    stitched_img = uint8(varargin{1} * 255);
    stitched_mask = ones(size(varargin{1},1),size(varargin{1},2));
    for i=2:size(varargin,2)
        src_img = varargin{i};
        [xs, xd] = genSIFTMatches(uint8(varargin{i} * 255), stitched_img);
        [inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
        [stitched_img, stitched_mask, H_3x3] ...
            = calucate_boudingbox(src_img, stitched_img, stitched_mask, H_3x3);
        dest_canvas_width_height = [size(stitched_img, 2), size(stitched_img, 1)];
        [src_mask, src_t_img] ...
            = backwardWarpImg(src_img, inv(H_3x3), dest_canvas_width_height);
        stitched_img = blendImagePair(uint8(src_t_img*255), src_mask, stitched_img, stitched_mask, 'blend');
        stitched_mask = uint8(uint8(src_mask) + uint8(stitched_mask) > 0);
    end
end

function [stitched_img, stitched_mask, H_3x3] ...
    = calucate_boudingbox(src_img, stitched_img, stitched_mask, H_3x3)
    x_min = 1; x_max = size(stitched_img,2);
    y_min = 1; y_max = size(stitched_img,1);
    [x_min, x_max, y_min, y_max] ...
        = cal_xy(1, 1, H_3x3, x_min, x_max, y_min, y_max) ;
    [x_min, x_max, y_min, y_max] ...
        = cal_xy(1, size(src_img,1), H_3x3, x_min, x_max, y_min, y_max);
    [x_min, x_max, y_min, y_max] ...
        = cal_xy(size(src_img,2), 1, H_3x3, x_min, x_max, y_min, y_max);
    [x_min, x_max, y_min, y_max] ...
        = cal_xy(size(src_img,2), size(src_img,1), ...
                H_3x3, x_min, x_max, y_min, y_max);
    x_min = floor(x_min);x_max = ceil(x_max);
    y_min = floor(y_min);y_max = ceil(y_max);
    stitched_img = [stitched_img, zeros(size(stitched_img,1), x_max - size(stitched_img,2), 3)];
    stitched_img = [stitched_img; zeros(y_max - size(stitched_img,1), size(stitched_img,2), 3)];
    stitched_img = [zeros(size(stitched_img,1), 1-x_min, 3), stitched_img];
    stitched_img = [zeros(1-y_min, size(stitched_img,2), 3); stitched_img];
    stitched_mask = [stitched_mask, zeros(size(stitched_mask,1), x_max - size(stitched_mask,2))];
    stitched_mask = [stitched_mask; zeros(y_max - size(stitched_mask,1), size(stitched_mask,2))];
    stitched_mask = [zeros(size(stitched_mask,1), 1-x_min), stitched_mask];
    stitched_mask = [zeros(1-y_min, size(stitched_mask,2)); stitched_mask];
    I = eye(3);
    I(1,3) = (1-x_min);
    I(2,3) = (1-y_min);
    H_3x3 = I * H_3x3;
end

function [xmin, xmax, ymin, ymax] = cal_xy(x,y,H_3x3, x_min, x_max, y_min, y_max) 
    result = H_3x3 * [x;y;1];
    x = result(1)./result(3);
    y = result(2)./result(3);
    xmin = min(x, x_min);
    xmax = max(x, x_max);
    ymin = min(y, y_min);
    ymax = max(y, y_max);
end