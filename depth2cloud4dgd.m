function [ pcloud ] = depth2cloud4dgd( depth )
%DEPTH2CLOUD4DGD Convert depth images in dgd database to 3d point cloud
%   Method given by https://openkinect.org/wiki/Imaging_Information


[w,h] = size(depth);

x = zeros(w,h);
y = zeros(w,h);
z = zeros(w,h);

minDistance = -10;
scaleFactor = .0021;

for i=1:w
    for j=1:h
        z(i,j) = 100/(-0.00307 * double(depth(i,j)) + 3.33);
        x(i,j) = (i - w / 2) * (z(i,j) + minDistance) * scaleFactor;
        y(i,j) = (j - h / 2) * (z(i,j) + minDistance) * scaleFactor;
    end
end


pcloud(:,:,1) = x(:);
pcloud(:,:,2) = y(:);
pcloud(:,:,3) = z(:);

end

