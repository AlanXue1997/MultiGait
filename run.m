clear;clc;clf;

number = 1;
name = 'ljg';
n = 60;
S = [140 90];
%g = imread('..\silhouettes\hy\00_1\ml-00_1-001.png');

data = zeros(1,n);
for i=1:n
    g = imread(sprintf('.\\CASIA_data\\DatasetA\\silhouettes\\%s\\00_%d\\%s-00_%d-0%02d.png', name, number, name, number, i));
    %.\DGD_database\SAIVT-DGD-depthraw-0009\
    data(i) = size(getArea(g, [0 0], false), 2);
end

figure(1);
imshow(getArea(g, [0 0], false));

figure(2);
clf;
hold on
plot(data);
A=polyfit(1:n,data,15);
z=polyval(A,1:0.1:n);
plot(1:0.1:n,z)
hold off

data = z;

left = 15;
while data(left-1) > data(left) || data(left+1) > data(left)
    left=left+1;
end

right = left+1;
while data(right-1) > data(right) || data(right+1) > data(right)
    right=right+1;
end
while data(right-1) > data(right) || data(right+1) > data(right)
    right=right+1;
end
right = right+1;
while data(right-1) > data(right) || data(right+1) > data(right)
    right=right+1;
end

disp([left right]);

ave = zeros(S);
for i=left:right
    g = imread(sprintf('.\\CASIA_data\\DatasetA\\silhouettes\\%s\\00_%d\\%s-00_%d-0%02d.png', name, number, name, number, i));
    ave = ave + double(getArea(g, S, true));
end

ave = ave./(right-left+1) ./ 256;

figure(3);
imshow(ave);