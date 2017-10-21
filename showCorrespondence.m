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
    result_img = saveAnnotatedImg(fh);
    delete(fh)
end

function annotated_img = saveAnnotatedImg(fh)
    figure(fh); % Shift the focus back to the figure fh

    % The figure needs to be undocked
    set(fh, 'WindowStyle', 'normal');

    % The following two lines just to make the figure true size to the
    % displayed image. The reason will become clear later.
    img = getimage(fh);
    truesize(fh, [size(img, 1), size(img, 2)]);

    % getframe does a screen capture of the figure window, as a result, the
    % displayed figure has to be in true size. 
    frame = getframe(fh);
    frame = getframe(fh);
    pause(0.5); 
    % Because getframe tries to perform a screen capture. it somehow 
    % has some platform depend issues. we should calling
    % getframe twice in a row and adding a pause afterwards make getframe work
    % as expected. This is just a walkaround. 
    annotated_img = frame.cdata;
end