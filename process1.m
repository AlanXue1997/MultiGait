function [X , x , y , z] = process1(image)

ZoneSize = [0.44,1.6];
ImageSize = [350,800];
margin = 10;%percentage

if ~((ZoneSize(1)/ImageSize(1))==(ZoneSize(2)/ImageSize(2)))
    warning('Aspect ratio of ZoneSize[%d,%d] and ImageSize[%d,%d] is not consistent, part of Image may be wasted!', ZoneSize,ImageSize);
end

p=depthToCloud( image );
x=p(:,:,1);
y=p(:,:,2);
z=p(:,:,3);
figure(3);

x=x(:);
y=y(:);
z=z(:);

%右边墙面
a1 = [0.7,4];
b1 = [0.6,5];
r1 = b1-a1;
q1 = ( (x-a1(1))*r1(2)-(z-a1(2))*r1(1) )<0;
q = find(q1);
x = x(q);
y = y(q);
z = z(q);

%左边墙面
a2 = [-1,6];
b2 = [-1.5,4];
r2 = b2-a2;
q2 = ( (x-a2(1))*r2(2)-(z-a2(2))*r2(1) )<0;
q = find(q2);
x = x(q);
y = y(q);
z = z(q);

%上边墙面
q = find(y>-1.38);
x = x(q);
y = y(q);
z = z(q);

%最后边的斜着的面
a3 = [-0.18,6.95];
b3 = [0.13,6.65];
r3 = b3-a3;
q3 = ( (x-a3(1))*r3(2)-(z-a3(2))*r3(1) )>0;
q = find(q3);
x = x(q);
y = y(q);
z = z(q);


%地面
a = [0.04,3.2];
b = [0,3.6];
r = b-a;

%segment
q0 = ( (y-a(1))*r(2)-(z-a(2))*r(1) )<0;
%q = find((x>-100)+q0+(y>-50)+(y<80)+(z<700)+(z>100)==6);

q = find((x<0.5)+(x>-0.7)+(z<7)+(z>1.4)+q0+(y>-1)==6);

%convert to vector
x = x(q);
y = y(q);
z = z(q);
scatter3(x,y,z,'.');
axis equal

%translation
avgx = mean(x);
avgy = mean(y);
avgz = mean(z);
x = (x - avgx);
y = (y - avgy);
z = (z - avgz);


height = ZoneSize(2);
width = ZoneSize(1);%It may be width rather than weight, which is an unit to measure mass

i = 1;
j = 1;
lenx = length(x);
leny = length(y);

%delete exceeding points
p = find((abs(y)<height/2) .* (abs(z)<width/2)==1);
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
y = int16((y+0.5*height)/height*Isize(2)+1)+(ImageSize(2)-Isize(2))/2;
z = int16((z+0.5*width)/width*Isize(1)+1)+(ImageSize(1)-Isize(1))/2;

%convert to an 0-1 image
X = zeros(ImageSize(2),ImageSize(1));
for i=1:length(y)
    X(y(i),z(i))=1;
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