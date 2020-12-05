close all;
clear all;

im = imread('Number Plate Images/image5.jpg');
subplot(3,2,1)
imshow(im);
title('INPUT IMAGE')
imgray = rgb2gray(im);

subplot(3,2,2)
imshow(imgray);
title('GRAYSCALE IMAGE')
threshold = graythresh(im);
imbin=im2bw(im,threshold);

subplot(3,2,3)
imshow(imbin);
title('BINARY IMAGE')
im = edge(imgray, 'Prewitt');

subplot(3,2,4)
imshow(im);
title('DETECTED EDGES')
%Below steps are to find location of number plate
Iprops=regionprops(im,'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    

im = imcrop(imbin, boundingBox);%crop the number plate area

subplot(3,2,5)
imshow(im);
title('LOCATED NUMBER PLATE')
im = bwareaopen(~im, 40); %remove some object if it width is too long or too small than 40

[h, w] = size(im);%get width


subplot(3,2,6)
imshow(im);
title('REMOVED OBJECTS LESS THAN 40 PIXELS') 
Iprops=regionprops(im,'BoundingBox','Area', 'Image'); %read letter
count = numel(Iprops);
NumberPlate=[]; % Initializing the variable of number plate string.

for i=1:count
   ow = length(Iprops(i).Image(1,:));
   oh = length(Iprops(i).Image(:,1));
   if ow<(h/2) & oh>(h/3)
       letter=Letter_detection(Iprops(i).Image); % Reading the letter corresponding the binary image 'N'.
       NumberPlate=[NumberPlate letter] % Appending every subsequent character in noPlate variable.
   end
end
