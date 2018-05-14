function [ave] = run(imgframe,S)

% number = 1;
% name = 'zl';
% file=dir(sprintf('.\\CASIA_data\\DatasetA\\silhouettes\\%s\\00_%d\\*.png', name, number));
% n = length(file);
[a ,b ,n] = size(imgframe);
%S = [150 500];
%g = imread('..\silhouettes\hy\00_1\ml-00_1-001.png');

data = zeros(1,n);
for i=1:n
%     g = imread(sprintf('.\\CASIA_data\\DatasetA\\silhouettes\\%s\\00_%d\\%s-00_%d-0%02d.png', name, number, name, number, i));
%     %.\DGD_database\SAIVT-DGD-depthraw-0009\
    g = imgframe(:,:,i);
    %È¥³ýÔëÉù
%     h=im2bw(g);
%     f=bwareaopen(h,50);
%     g=imdilate(f,strel('disk',2));
    
    data(i) = size(getArea(g, [0 0], false), 2);
end

% figure(1);
% imshow(getArea(g, [0 0], false));

figure(1);
clf;
hold on
plot(data);
A=polyfit(1:n,data,30);
z=polyval(A,1:n);
plot(1:n,z)
hold off

data = z;

% left = 15;
% while data(left-1) > data(left) || data(left+1) > data(left)
%     left=left+1;
% end
% 
% right = left+1;
% while data(right-1) > data(right) || data(right+1) > data(right)
%     right=right+1;
% end
% while data(right-1) > data(right) || data(right+1) > data(right)
%     right=right+1;
% end
% right = right+1;
% while data(right-1) > data(right) || data(right+1) > data(right)
%     right=right+1;
% end

[pks,locs] = findpeaks(z);
q = find((locs(1,:)>=10) + (locs(1,:)<=65) == 2);
locs = locs(q);
left = locs(1);
right = locs(3);
disp([left right]);

ave = zeros(S);
for i=left:right
%     g = imread(sprintf('.\\CASIA_data\\DatasetA\\silhouettes\\%s\\00_%d\\%s-00_%d-0%02d.png', name, number, name, number, i));
    g = imgframe(:,:,i);
    %imshow(g);
    ave = ave + double(getArea(g, S, true));
end

ave = ave./(right-left+1);% ./ 256;

% figure(3);
% imshow(ave);