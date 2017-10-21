function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)
    fh = figure();
    imshow([orig_img, warped_img], 'InitialMagnification', 50);
    hold on;
    xs = src_pts_nx2(:,1) ;
    ys = src_pts_nx2(:,2) ;
    xd = size(orig_img,2) + dest_pts_nx2(:,1) ;
    yd = dest_pts_nx2(:,2) ;
    for k = 1:size(src_pts_nx2,1)
       plot([xs(k) xd(k)],[ys(k) yd(k)],'color','r'); 
       hold on;
    end
end
