clear;clc;clf;

image = imread('.\DGD_database\SAIVT-DGD-depthraw-0009\DGD\depth_raw\sub0001\nw01\0038.png');


p=depthToCloud(image);

x=p(:,:,1);
y=p(:,:,2);
z=p(:,:,3);

x = x(:);
y = y(:);
z = z(:);

a = [0.6,0.885];
b = [0.385,0.992];
%b = [0.6,0.89];
r = b-a;
q0 = ((y-a(1))*r(2)-(z-a(2))*r(1))<0;

q = find((z>0.6)+(z<1.03)+(y>-0.1)+(x>-0.2)+(x<0.06)+q0==6);

x = x(q);
y = y(q);
z = z(q);

avgx = mean(x);
avgy = mean(y);
avgz = mean(z);

x = (x - avgx)*1000;
y = (y - avgy)*1600;
z = (z - avgz)*1200;

height = 736;
weight = 32;

i = 1;
j = 1;
lenx = length(x);
leny = length(y);

while(i<=lenx)
    if(abs(y(i))>height/2)
        z(i)=[];
        y(i)=[];
        x(i)=[];
        i = i-1;
    end
    i = i+1;
    lenx = length(x);
end

while(j<=leny)
    if(abs(z(j))>weight/2)
        z(j)=[];
        y(j)=[];
        x(j)=[];
        j = j-1;
    end
    j = j+1;
    leny = length(y);
end

X = zeros(800,600);

for i = 1 : length(x)
    
    if(int16((z(i)+16)/32*600)==0 && int16((y(i)+368)/736*800)==0)
        
        X( int16((y(i)+368)/736*800)+1,int16((z(i)+16)/32*600)+1 )=1;
        
    elseif (int16((y(i)+368)/736*800)==0)
        
        X( int16((y(i)+368)/736*800)+1,int16((z(i)+16)/32*600) )=1;
        
    elseif(int16((z(i)+16)/32*600)==0)
        
        X( int16((y(i)+368)/736*800),int16((z(i)+16)/32*600)+1 )=1;
        
    else
        
        X( int16((y(i)+368)/736*800),int16((z(i)+16)/32*600) )=1;
        
    end
end

figure(1);
imshow(1-X);

for i=1:size(X,1)
    for j=1:size(X,2)
        if X(i,j)==1
            for k=j:600
                % plot(i,k,'.');
                X(i,k)=1;
            end
            break;
        end
    end
end

figure(2);
imshow(1-X);

% i = 1;
% j = 1;
% lenx = length(x);
% leny = length(y);
% 
% while(i<=lenx)
%     temp_z = z(i);
%     while(j<=leny)
%         if(y(i)==y(j) && i~=j)
%             disp(j);
%             if(z(j)>temp_z)
%                 z(i) = z(j);
%             end
%             x(j)=[];
%             y(j)=[];
%             z(j)=[];
%             j = j-1;
%         end
%         j = j+1;
%         leny = length(y);
%     end
%     i = i+1;
%     lenx = length(x);
% end
% 
% plot(y,z,'.');

% hold on 
% for k = 1 : length(x)
%     temp_z = z(k);
%     while (temp_z<=15)
%        scatter3(x(k),y(k),temp_z+1,'.');
%        temp_z = temp_z + 1;
%     end
% end 
% hold off

% for i = 1 : (length(x)-1)
%     disp(i);
%     temp_z = z(i);
%     for j = 1 : (length(x)-1)
%         
%         if(x(i)==x(j) && y(i)==y(j))
%             if(z(j)>temp_z)
%                 z(i) = z(j);
%             end
%             x(j)=[0];
%             y(j)=[0];
%             z(j)=[0];
%         end
%     end
% end


%plot3(avgx,avgy,avgz,'*','color',[1 0 0]);

% for i = 1 : length(x)
%     newz = z(i);
%     for j = newz : 0.009
%         scatter3(x(i),y(i),j,'.');
%     end
% end

% x = int16(x*200+100);
% y = int16(y*200+70);
% z = int16(z*800+80);
% 
% vol = zeros(140 ,160 ,110);
% for i = 1 : length(x)
%     if(x(i)<140 && y(i)<160 && z(i)<110)
%         vol(x(i), y(i), z(i)) = 1;
%     end
% end
