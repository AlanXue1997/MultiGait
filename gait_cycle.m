% I=cell(1,4);
% for i=8:11
%     if(i<10)
%         I{i} = imread(['.\DGD_database\SAIVT-DGD-depthraw-0009\DGD\depth_raw\sub0001\nw01\000',int2str(i),'.png']);
%     else
%         I{i} = imread(['.\DGD_database\SAIVT-DGD-depthraw-0009\DGD\depth_raw\sub0001\nw01\00',int2str(i),'.png']);
%     end
% end
function [ cycle ] = gait_cycle()
clear;

GEI = zeros(800,600);

file=dir('.\DGD_database\SAIVT-DGD-depthraw-0009\DGD\depth_raw\sub0001\nw01\*.png');
%cycle = zeros(length(file),1);
for n=1:length(file)
    image = imread(['.\DGD_database\SAIVT-DGD-depthraw-0009\DGD\depth_raw\sub0001\nw01\',file(n).name]);
    p=depth2cloud4dgd( image );
    
    x=p(:,:,1);
    y=p(:,:,2);
    z=p(:,:,3);
    
    a = [97,184];
    b = [101,284];
    r = b-a;
    q0 = ( (x-a(1))*r(2)-(z-a(2))*r(1) )<0;
    
    q = find((x>-70)+q0+(y>-15)+(y<60)+(z<600)+(z>0)==6);
    
    x = x(q);
    y = y(q);
    z = z(q);
    
    avgx = mean(x);
    avgy = mean(y);
    avgz = mean(z);
    
    x = (x - avgx);
    y = (y - avgy);
    z = (z - avgz);
    
    height = 170;
    weight = 70;

    i = 1;
    j = 1;
    lenx = length(x);
    leny = length(y);

    while(i<=lenx)
        if(abs(x(i))>height/2)
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

        if(int16((z(i)+0.5*weight)/weight*600)==0 && int16((x(i)+0.5*height)/height*800)==0)

            X( int16((x(i)+0.5*height)/height*800)+1,int16((z(i)+0.5*weight)/weight*600)+1 )=1;

        elseif (int16((x(i)+0.5*height)/height*800)==0)

            X( int16((x(i)+0.5*height)/height*800)+1,int16((z(i)+0.5*weight)/weight*600) )=1;

        elseif(int16((z(i)+0.5*weight)/weight*600)==0)

            X( int16((x(i)+0.5*height)/height*800),int16((z(i)+0.5*weight)/weight*600)+1 )=1;

        else

            X( int16((x(i)+0.5*height)/height*800),int16((z(i)+0.5*weight)/weight*600) )=1;

        end
    end

    q = find(x>60==1);
    
    x = x(q);
    y = y(q);
    z = z(q);
    
    cycle(n) = max(z)-min(z);
    
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
    
    
    GEI = GEI + X;
end

m = length(file);
GEI = GEI / m;

figure(1);
clf;
hold on
plot(cycle);
A=polyfit(1:m,cycle,20);
z=polyval(A,1:0.1:m);
plot(1:0.1:m,z)
hold off

figure(2);
imshow(GEI);

