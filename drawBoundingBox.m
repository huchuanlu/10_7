function drawBoundingBox(rmin,rmax,cmin,cmax,color)
%% function drawBoundingBox(rmin,rmax,cmin,cmax,color)
corners = [ cmin,rmin; cmin,rmax; cmax,rmax; cmax,rmin; cmin,rmin ]';
hold on; line(corners(1,:), corners(2,:), 'Color', color, 'LineWidth',2.5); hold off;
drawnow; 