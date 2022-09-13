% MEANSHSEGM_DEMO Demo showing the usage of meanshsegm 
% 
% adapted from CMP Vision algorithms http://visionbook.felk.cvut.cz
%
% Example
%
% Mean shift segmentation is applied to an RGB color image. It is possible
% to use a different color space or a grayscale image. Small regions can be
% eliminated by post-processing.  

image_path = ['./images/8068.jpg'];
img=imread(image_path);

img=imresize(img,0.5) ; %resize or convert to grayscale if needed

figure, imagesc(img); axis image ; axis off ; 

disp('Mean shift segmentation')
disp('this procedure may take several minutes...')

l=meanshsegm(img,10,20) ;

figure, imagesc(label2rgb(l-1,'jet','w','shuffle')) ; 
axis image ; axis off ; 
