%% lab 2 Image Segmentation using K-means clustering
clearvars;
prompt = 'K values for K-means clustering: ';
K = input(prompt);

im_RGB = imread('./images/chata.jpg');
im_HSV = rgb2hsv(im_RGB);
im_RGB = im2double(im_RGB);
HSV = reshape(im_HSV,size(im_RGB,1)*size(im_RGB,2),3);%transform into vector
RGB = reshape(im_RGB, size(im_RGB,1)*size(im_RGB,2),3);

[m,n,d] = size(im_RGB);
X = reshape(repmat((1:1:n),m,1),m*n,1)/n;%x coordinate of pixels
Y = reshape(repmat((1:1:m),1,n),m*n,1)/m;%y coordinate of pixels

im_GRAY = padarray(rgb2gray(im_RGB),[20, 20],'replicate');%expand the edge with replicate method
im_texture = colfilt(im_GRAY,[20, 20],'sliding',@std);
im_texture = im_texture(21:m+20,21:n+20);
texture = reshape(im_texture,size(X));

layers = [HSV RGB X Y texture];

[cluster_idx, cluster_center] = kmeans(layers,K);
pixel_labels = reshape(cluster_idx, size(im_texture));

figure; imagesc(pixel_labels);