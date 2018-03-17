clear,clc;

total_num = 75;
seg_rank = 30;
path = '.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png';

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


foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
'NumTrainingFrames', 75);

for i = 1:total_num
    frame = imread(sprintf('.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png',i)); % read the next video frame
    step(foregroundDetector, frame);
end

frame = imread(sprintf('.\\CASIA_data\\DatasetA\\gaitdb\\fyc\\00_1\\fyc-00_1-0%02d.png',seg_rank)); % read the next video frame
foreground = step(foregroundDetector, frame);

se = strel('square', 3);
filteredForeground = imopen(foreground, se);

blob = vision.BlobAnalysis(...
       'CentroidOutputPort', false, 'AreaOutputPort', false, ...
       'BoundingBoxOutputPort', true, ...
       'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
shapeInserter = vision.ShapeInserter('BorderColor','White');

bbox   = blob(foreground);
out    = shapeInserter(frame,bbox);

subplot(2,2,1); imshow(frame); title('Origin Image');
subplot(2,2,2); imshow(foreground); title('Detected Foreground');
subplot(2,2,3); imshow(filteredForeground); title('Clean Foreground');
subplot(2,2,4); imshow(out); title('Blob Analysis');
