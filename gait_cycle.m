clear;
filename = 'nw';
ImageSize = [350,800];
for k=1:1
    for j=1:5
        file=dir(sprintf('.\\DGD_database\\SAIVT-DGD-depthraw-0009\\DGD\\depth_raw\\sub00%02d\\%s0%d\\*.png',k,filename,j));
        len = length(file);
        GEI = zeros(ImageSize(2),ImageSize(1));
        cycle=zeros(ImageSize(2),ImageSize(1),len);
        distance = zeros(1,len);

        for n=1:len
            image = imread(sprintf('.\\DGD_database\\SAIVT-DGD-depthraw-0009\\DGD\\depth_raw\\sub00%02d\\%s0%d\\%s',k,filename,j,file(n).name));
            [X , x , y , z] = process1(image);
        %     figure(1);
        %     scatter3(x,y,z,'.');
            q = find( x > 80 );

            x = x(q);
            y = y(q);
            z = z(q);

            distance(n) = double(min(z));
            cycle(:,:,n) = X;
        end

%          %»­²½Ì¬ÖÜÆÚ
%         figure(j);
%         clf;
%         hold on
%         plot(distance);
          A=polyfit(1:len,distance,20);
          z=polyval(A,1:len);
%         plot(1:len,z)
%         hold off
        
        [pks,locs] = findpeaks(z,'minpeakdistance',5);
        [row, column] = size(locs);
        
        m = locs(column) - locs(column-2);

        for i = locs(column-2) : locs(column)
            GEI = GEI + cycle(:,:,i);
        end
        %disp(locs(size(locs)-1),locs(size(locs)-3));
        GEI = GEI / m;

    %     figure(j);
        imwrite(GEI,sprintf('.\\GEI_FromDGD\\p%d\\%s-GEI-%d.jpg',k,filename,j),'jpg');
    end
end