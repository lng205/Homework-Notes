%% Tutorial Activity 1: Image Noise and Filtering
im = imread('./images/mountain.png');%读取

im_gauss = imnoise(im,'gaussian',0,0.01); %添加噪声
im_sp1 = imnoise(im,'salt & pepper',0.05); 
im_sp2 = imnoise(im,'salt & pepper',0.2);

im2 = colfilt(im_gauss,[3, 3],'sliding',@median);%通过指针调用均值函数对像素进行3×3滑动平均滤波
im3 = colfilt(im_sp1,[3, 3],'sliding',@median);
im4 = colfilt(im_sp2,[3, 3],'sliding',@median);

h = fspecial('gaussian',3);%生成高斯矩阵
im5 = imfilter(im_gauss,h,'replicate');%高斯滤波，设置边界选项取界外点的值为最接近的界内点的值
im6 = imfilter(im_sp1,h,'replicate');
im7 = imfilter(im_sp2,h,'replicate');
figure
montage({im_gauss,im_sp1,im_sp2;im2,im3,im4;im5,im6,im7},'size',[3 3])

%% Tutorial Activity 2: Image sharpening
im_eye = imread('./images/eye.jpg');
im_moon = imread('./images/moon1.jpg');

h = fspecial('gaussian',6,1);
im_fil = imfilter(im_eye,h,'replicate');

im_array_fil = im2double(im_fil);
im_array_ori = im2double(im_eye);
diff = im_array_fil - im_array_ori; 

gama = 2;
diff = gama*diff;
im_array_sharpen = im_array_ori + diff;
figure
montage({im_eye,im_array_sharpen},'size',[1 2]);

im_lab = rgb2lab(im_eye);
l_band = im_lab(:,:,1);
l_array = im2double(l_band);

h = fspecial('gaussian',6,1);
l_fil = imfilter(l_band,h,'replicate');
l_array_fil = im2double(l_fil);
diff = l_array_fil - l_array; 

gama = 2;
diff = gama*diff;
l_array_sharpen = l_array + diff;
im_lab(:,:,1) = l_array_sharpen;
im_sharpen = lab2rgb(im_lab);
figure
montage({im_eye,im_sharpen},'size',[1 2]);

%% Tutorial Activity 3: Simple texture clustering
im = imread('./images/dog.png');
im = rgb2gray(im2double(im));
im_fil = colfilt(im,[20, 20],'sliding',@std);

BW = imbinarize(im);
figure
montage({im,BW},'size',[1 2]);


%% Tutorial Activity 4: Detecting Edges
im_fig = imread('./images/figures.jpg');

im_chess = imread('./images/chess.png');
im_chess = rgb2gray(im2double(im_chess));

im_coins1 = imread('./images/coins001.png');
im_coins1 = rgb2gray(im2double(im_coins1));

im_coins2 = imread('./images/coins002.png');
im_coins2 = rgb2gray(im2double(im_coins2));

canny_thresh = [0.1 0.2];
canny_sigma = 2;

BW1 = edge(im_chess,'Canny',canny_thresh, canny_sigma);
BW2 = edge(im_chess,'Sobel');
figure
montage({im_chess,BW1,BW2},'size',[1 3]);

