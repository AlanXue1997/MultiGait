clear,clc;

S = [800 400];
aframeGEI = zeros(S);
bframeGEI = zeros(S);
fillback_CASIA_GEI = zeros(S);
total_num = 75;
seg_rank = 43;
kind = 'nm';
%path = '.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png';


%for  i=1:1
%    for j=1:1
        %vpath = sprintf('.\\CASIA_data\\Dataset__00\\0%02d-nm-0%d-090.avi',i,j);
        vpath = sprintf('.\\CASIA_data\\12（可用）.mp4');
        % 
        % bg = uint16(imread('.\CASIA_data\fyc\00_1\fyc-00_1-001.png'));
        % for i=2:total_num
        %     bg = bg + uint16(imread(sprintf('.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png',i)));
        % end
        % vid = uint16(imread(sprintf('.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png',seg_rank)));
        % 
        % bg = bg ./ total_num;
        % 
        % fg = sum( (vid - bg).^2, 3 ).^0.5 > 1;
        % 
        % subplot(1,2,1);
        % imshow(uint8(bg));
        % subplot(1,2,2);
        % imshow(fg);


        foregroundDetector = vision.ForegroundDetector('NumTrainingFrames', 5);

        videoSource = vision.VideoFileReader(vpath,...
            'ImageColorSpace','Intensity','VideoOutputDataType','uint8');

        % for i = 1:total_num
        %     frame = videoSource();%imread(sprintf('.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png',i)); % read the next video frame
        %     step(foregroundDetector, frame);
        % end

        videoPlayer = vision.VideoPlayer();
        bofeng = zeros(1,3);
        n = 4;%缓存帧数
        cache = zeros(480,640,n); %缓存矩阵
        flag = 1; %波峰
        temp = 1;%循环往缓存矩阵里面存入帧
        last = 0;%记录上次找到的波峰的个数
        block = 1;
        disframe = 50;%控制在figure里显示多少帧的曲线
        data = zeros(1,disframe);
        k = 1;
        %cam=webcam;
        while ~isDone(videoSource)
        %while true
            frame  = videoSource();
            %frame=snapshot(cam);
            foreground = step(foregroundDetector, frame);% origin
            se = strel('square', 3);
            filteredForeground = imopen(foreground, se);%filtered
%            if sum(filteredForeground(:)) ~= 0
                if k>disframe
                    data(1,1:disframe-1) = data(1,2:disframe);
                    data(disframe) = size(getArea(filteredForeground, [0 0], false), 2);
                    subplot(1,2,1);
                    plot(data(1,1:disframe));
                    axis([0,disframe,0,300]);
                else
                    data(k) = size(getArea(filteredForeground, [0 0], false), 2);
                    subplot(1,2,1);
                    plot(data(1,1:k));
                    axis([0,disframe,0,300]);
                end
                
                temp = mod(k,n);
                if temp == 0
                    temp=n;
                end
                cache(:,:,temp) = filteredForeground;
                if k>=3
                    [pks,locs] = findpeaks(data,'minpeakdistance',10);
                    len = size(locs,2);
                    if len~=0
                        differ = k-locs(1,len); %波峰之后过了多少帧
                        m = mod(k-differ,n);
                        if m == 0
                            m=n;
                        end
                        if len>last
                            bofeng(1,mod(flag,3)+1) = locs(1,len);
                            flag=flag+1;
                            sortbofeng = sort(bofeng,2);
                            disp(sortbofeng);
                            if len>=2
                                bframeGEI = bframeGEI./(locs(1,len)-locs(1,len-1));
                                subplot(1,2,2);
                                imshow((aframeGEI+bframeGEI)/2);
                                aframeGEI = bframeGEI;
                                bframeGEI = zeros(S);
                            end
                        end
                        area=getArea(cache(:,:,m), [0 0], false);
                        area=double(imresize(area,S));
                        area = area*triu(ones(S(2)))>0;
                        area = 1-area;
                        bframeGEI = bframeGEI + area;
                    end
                    last = len;
                end
               k = k+1;
%            end
            videoPlayer(1-filteredForeground); 
            pause(0.03);
        end

%        ave = zeros(S);
        
%         for i=left:right
%         %     g = imread(sprintf('.\\CASIA_data\\DatasetA\\silhouettes\\%s\\00_%d\\%s-00_%d-0%02d.png', name, number, name, number, i));
%             g = imgframe(:,:,i);
%             %imshow(g);
%             ave = ave + double(getArea(g, S, true));
%         end
%         ave = ave./(right-left+1);% ./ 256;
%         
%         [fillback_CASIA_GEI] = run(imgframe,S);
%         % figure(3);
%         % imshow(CASIA_GEI);
%         figure(2);
%         imshow(fillback_CASIA_GEI);
        
        %imwrite(fillback_CASIA_GEI,sprintf('.\\GEI_FromCASIA\\p (%d)\\%s-GEI-%d.jpg',i,kind,j),'jpg');
%    end
    
%end


% frame = videoSource();%imread(sprintf('.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png',seg_rank)); % read the next video frame
% foreground = step(foregroundDetector, frame);
% 
% se = strel('square', 3);
% filteredForeground = imopen(foreground, se);
% 
% blob = vision.BlobAnalysis(...
%        'CentroidOutputPort', false, 'AreaOutputPort', false, ...
%        'BoundingBoxOutputPort', true, ...
%        'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
% shapeInserter = vision.ShapeInserter('BorderColor','White');
% 
% bbox   = blob(foreground);
% out    = shapeInserter(frame,bbox);
% 
% subplot(2,2,1); imshow(frame); title('Origin Image');
% subplot(2,2,2); imshow(foreground); title('Detected Foreground');
% subplot(2,2,3); imshow(filteredForeground); title('Clean Foreground');
% subplot(2,2,4); imshow(out); title('Blob Analysis');