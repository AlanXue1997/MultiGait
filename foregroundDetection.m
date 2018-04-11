clear,clc;

S = [170 90];
CASIA_GEI = zeros(S);
fillback_CASIA_GEI = zeros(S);
total_num = 75;
seg_rank = 43;
kind = 'nm';
%path = '.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png';
for  i=1:35
    for j=1:6
        vpath = sprintf('.\\CASIA_data\\Dataset__00\\0%02d-nm-0%d-090.avi',i,j);
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

        %videoPlayer = vision.VideoPlayer();
        k = 1;
        while ~isDone(videoSource)
            frame  = videoSource();
            foreground = step(foregroundDetector, frame);% origin
            se = strel('square', 3);
            filteredForeground = imopen(foreground, se);%filtered
            if sum(filteredForeground(:)) ~= 0
               imgframe(:,:,k) = filteredForeground;
               k = k+1;
            end
            %videoPlayer(1-filteredForeground); 
            %pause(0.03);
             
        end
        [fillback_CASIA_GEI] = run(imgframe,S);
        % figure(3);
        % imshow(CASIA_GEI);
        %figure(4);
        %imshow(fillback_CASIA_GEI);
        imwrite(fillback_CASIA_GEI,sprintf('.\\GEI_FromCASIA\\p (%d)\\%s-GEI-%d.jpg',i,kind,j),'jpg');
    end
    
end


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