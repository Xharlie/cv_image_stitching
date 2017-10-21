function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
%     bug existed
    overlay_mask = ((masks>0) + (maskd>0) > 1);
    s_mask = uint8((uint8(masks >0) + uint8(overlay_mask)) == 1);
    d_mask = uint8((uint8(maskd >0) + uint8(overlay_mask)) == 1);

    if strcmp(mode,'overlay')
        out_img = wrapped_imgd;
        out_img(:,:,1) = wrapped_imgs(:,:,1) .* s_mask ...
            + wrapped_imgd(:,:,1) .* (maskd ./ 255);
        out_img(:,:,2) = wrapped_imgs(:,:,2) .* s_mask ...
            + wrapped_imgd(:,:,2) .* (maskd ./ 255);
        out_img(:,:,3) = wrapped_imgs(:,:,3) .* s_mask ...
            + wrapped_imgd(:,:,3) .* (maskd ./ 255);
        imshow(out_img);
        hold on;
    end
end