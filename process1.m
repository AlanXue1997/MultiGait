function [X , x , y , z] = process1(image)

ZoneSize = [70,190];
ImageSize = [350,800];
margin = 10;%percentage

if ~((ZoneSize(1)/ImageSize(1))==(ZoneSize(2)/ImageSize(2)))
    warning('Aspect ratio of ZoneSize[%d,%d] and ImageSize[%d,%d] is not consistent, part of Image may be wasted!', ZoneSize,ImageSize);
end

%image = imread('.\DGD_database\SAIVT-DGD-depthraw-0009\DGD\depth_raw\sub0001\nw01\0045.png');

p=depth2cloud4dgd( image );

p=depth2cloud4dgd( image );

x=p(:,:,1);
y=p(:,:,2);
z=p(:,:,3);

a = [94,184];
b = [94,284];
r = b-a;

%segment
q0 = ( (x-a(1))*r(2)-(z-a(2))*r(1) )<0;
q = find((x>-100)+q0+(y>-50)+(y<80)+(z<680)+(z>100)==6);

%convert to vector
x = x(q);
y = y(q);
z = z(q);

% figure(3);
% scatter3(x,y,z,'.');
% axis equal

%translation
avgx = mean(x);
avgy = mean(y);
avgz = mean(z);
x = (x - avgx);
y = (y - avgy);
z = (z - avgz);

% figure(3);
% scatter3(x,y,z,'.');
% axis equal

height = ZoneSize(2);
width = ZoneSize(1);%It may be width rather than weight, which is an unit to measure mass

% i = 1;
% j = 1;
% lenx = length(x);
% leny = length(y);

%delete exceeding points
p = find((abs(x)<height/2) .* (abs(z)<width/2)==1);
x = x(p);
y = y(p);
z = z(p);

if ZoneSize(1)/ImageSize(1)>ZoneSize(2)/ImageSize(2)
    Isize = [ImageSize(1), round(ImageSize(1)/ZoneSize(1)*ZoneSize(2))];
else
    Isize = [round(ImageSize(2)/ZoneSize(2)*ZoneSize(1)), ImageSize(2)];
end

%preserve for margin aera
Isize = round(Isize*(100-margin)/100);

%convert coordinates to integer
x = int16((x+0.5*height)/height*Isize(2)+1)+(ImageSize(2)-Isize(2))/2;
z = int16((z+0.5*width)/width*Isize(1)+1)+(ImageSize(1)-Isize(1))/2;

%convert to an 0-1 image
X = zeros(ImageSize(2),ImageSize(1));
for i=1:length(x)
    X(x(i),z(i))=1;
end
% figure(1);
% subplot(1,2,1);
% imshow(X);

%Fill back
% for i=2:ImageSize(1)
%     X(:,i) = X(:,i-1)+X(:,i)>0;
% end
X = X*triu(ones(ImageSize(1)))>0;
X=1-X;
% subplot(1,2,2);
% imshow(X);
w=fspecial('gaussian',[15 5],3);
% w=fspecial('disk',10);
X=imfilter(X,w);
X = X>0.9;