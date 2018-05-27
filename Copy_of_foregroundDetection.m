clear,clc;

S = [100 50];
aframeGEI = zeros(S);
bframeGEI = zeros(S);
GEI = zeros(S);
fillback_CASIA_GEI = zeros(S);
total_num = 75;
seg_rank = 43;
kind = 'nm';
%path = '.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png';


%for  i=1:1
%    for j=1:1
        %vpath = sprintf('.\\CASIA_data\\Dataset__00\\0%02d-nm-0%d-090.avi',i,j);
        vpath = sprintf('.\\CASIA_data\\13.mp4');
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
        n = 4;%����֡��
        cache = zeros(480,640,n); %�������
        flag = 1; %����
        temp = 1;%ѭ������������������֡
        last = 0;%��¼�ϴ��ҵ��Ĳ���ĸ���
        block = 1;
        disframe = 50;%������figure����ʾ����֡������
        adistance=0; %������ڵ�֡��
        bdistance=0; %������ڵ�֡��
        distance=0;
        data = zeros(1,disframe);
        k = 1;
        %cam=webcam(1); %ѡ��ڼ�����Ƶ�豸
        %cam.Resolution = '640x480';  %������Ƶ�豸�ķֱ�����640*480
        imgGEInum=0;  %��¼��ǰ��õ�GEIͼƬ���
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
                    %[pks,locs] = findpeaks(data,'minpeakdistance',10);
                    [pks,locs] = findpeaks(data);
                    len = size(locs,2);
                    if len~=0
                        differ = k-locs(1,len); %����֮����˶���֡
                        m = mod(k-differ,n);
                        if m == 0
                            m=n;
                        end
                        if len>last
%                             bofeng(1,mod(flag,3)+1) = locs(1,len);
%                             flag=flag+1;
%                             sortbofeng = sort(bofeng,2);
                            %disp(sortbofeng);
                            if len>=2
                                %bframeGEI = bframeGEI./(locs(1,len)-locs(1,len-1));
                                %��ʾʵʱ��ȡGEI�����洢���ļ�����
                                subplot(1,2,2);
                                GEI = (aframeGEI+bframeGEI)/(adistance+bdistance);
                                imshow(GEI);
                                if k<60
                                    title('û��ƥ��ɹ�');
                                else
                                    title('�ɹ�ƥ�䵽����µĲ�̬');
                                end
                                imgGEInum = imgGEInum+1;
                                if imgGEInum>100
                                    break;
                                end
                                
                                %ѡȡGEI��ǰ20��������������
%                                 x = [1:20];
%                                 y = ones(20,1);
%                                 GEImessage = GEI(x+(y-1)*size(GEI,1));
%                                 URL = 'http://172.20.14.90:8000/control/doorquery/2/';
%                                 if mod(k,10)
%                                     str = urlread(URL,'Post',{'st1','true','st2','1 2 3 4 5 6 7 8 9 10'});
%                                 else
%                                     str = urlread(URL,'Post',{'st1','flase','st2','1 2 3 4 5 6 7 8 9 10'});
%                                 end
%                                 if str == 'true'
%                                     disp('����');
%                                 else
%                                     disp('����');
%                                 end

                                %imwrite(GEI,sprintf('.\\GEI2Dlive_data\\person1\\%d.jpg',imgGEInum),'jpg');
                                aframeGEI = bframeGEI;
                                adistance = bdistance;
                                bdistance = 0;
                                distance=0;
                                bframeGEI = zeros(S);
                            end
                        end
                        area=getArea(cache(:,:,m), S, false);
%                         area = area*triu(ones(S(2)))>0;
%                         area = 1-area;
                        bdistance=bdistance+1;
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