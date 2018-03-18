clear,clc;

cam = webcam;
cam.Resolution = '640x480';%'320x240';% '640x480';

foregroundDetector = vision.ForegroundDetector('NumGaussians', 3, ...
'NumTrainingFrames', 75);

for i=1:20
    img = snapshot(cam);
    frame = step(foregroundDetector, img);
    frame = uint8(frame);
    subplot(1,2,1);
    imshow(img);
    img(:,:,1) = img(:,:,1).*frame;
    img(:,:,2) = img(:,:,2).*frame;
    img(:,:,3) = img(:,:,3).*frame;
    subplot(1,2,2);
    imshow(img);
    pause(0.3);
end

clear('cam');