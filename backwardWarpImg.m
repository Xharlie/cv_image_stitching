function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
    dimension = [dest_canvas_width_height, 2];
    [dX, dY] = meshgrid(1:dest_canvas_width_height(1), 1:dest_canvas_width_height(2));
    dest_index_matrix = zeros(dest_canvas_width_height(2),dest_canvas_width_height(1),3);
    dest_index_matrix(:,:,1) = dX;
    dest_index_matrix(:,:,2) = dY;
    dest_index_matrix(:,:,3) = 1;
    dest_index_matrix = reshape(dest_index_matrix,[dest_canvas_width_height(1) ...
        .* dest_canvas_width_height(2), 3])';
    result = resultToSrc_H * dest_index_matrix;
    src_index_matrix = [result(2,:) ./ result(3,:); result(1,:) ./ result(3,:)]';
    src_index_matrix = reshape(round(src_index_matrix), [dest_canvas_width_height(2), dest_canvas_width_height(1),2]);
    result_img = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1), 3);
    mask = ones(dest_canvas_width_height(2), dest_canvas_width_height(1));
    for i=1:dest_canvas_width_height(2)
        for j = 1:dest_canvas_width_height(1)
            if src_index_matrix(i,j,1) >= 1 && src_index_matrix(i,j,1) <= size(src_img,1) ...
                && src_index_matrix(i,j,2) >= 1 && src_index_matrix(i,j,2) <= size(src_img,2)
                result_img(i,j,:) = src_img(src_index_matrix(i,j,1),src_index_matrix(i,j,2),:);
            else
                result_img(i,j,:) = [0 0 0];
                mask(i,j) = 0;
            end
        end
    end
end