%% Activity 1: Basic Image Operations
im_board = board_position(0,0);

%% Activity 2: Histograms and Contrast Adjustment
im_fish1 = imread('images/fish001.jpg');
im_fish2 = imread('images/fish002.png');
im_water = imread('images/underwater001.png');

figure(1)
im_fish1_gray = rgb2gray(im_fish1);%转灰度图
imhist(im_fish1_gray)%获取灰度直方图
im_adjusted_fish1 = imadjust(im_fish1, [0; 0.58], [0; 1]);%将0到0.58的灰度范围拉伸至0到1
imshowpair(im_fish1,im_adjusted_fish1,'montage');%对比显示处理前后的图像

figure(2)
im_fish2_gray = rgb2gray(im_fish1);
imhist(im_fish2_gray)
im_adjusted_fish2 = imadjust(im_fish2, [0.18; 0.68], [0; 1]);
imshowpair(im_fish2,im_adjusted_fish2,'montage');

figure(3)
im_water_gray = rgb2gray(im_water);
imhist(im_water_gray)
im_adjusted_water = imadjust(im_water, [0.18; 0.88], [0; 1]);
imshowpair(im_water,im_adjusted_water,'montage');

figure(4)
im_adjusted_fish1 = histeq(im_fish1);%均衡
imshowpair(im_fish1,im_adjusted_fish1,'montage');

figure(5)
im_adjusted_fish2 = histeq(im_fish2);
imshowpair(im_fish2,im_adjusted_fish2,'montage');

figure(6)
im_adjusted_water = histeq(im_water);
imshowpair(im_water,im_adjusted_water,'montage');

%不同于可接受三维数组的histeq和imadjust
%adapthisteq需将图像转至Lab空间，取明度(L)轴均衡处理后再转回RGB空间
figure(7)
im_fish1_lab = rgb2lab(im_fish1);
L = im_fish1_lab(:,:,1)/100;
L = adapthisteq(L);
im_fish1_lab(:,:,1) = L*100;
im_adjusted_fish1 = lab2rgb(im_fish1_lab);
imshowpair(im_fish1,im_adjusted_fish1,'montage');

figure(8)
im_fish2_lab = rgb2lab(im_fish2);
L = im_fish2_lab(:,:,1)/100;
L = adapthisteq(L);
im_fish2_lab(:,:,1) = L*100;
im_adjusted_fish2 = lab2rgb(im_fish2_lab);
imshowpair(im_fish2,im_adjusted_fish2,'montage');

figure(9)
im_water_lab = rgb2lab(im_water);
L = im_water_lab(:,:,1)/100;
L = adapthisteq(L);
im_water_lab(:,:,1) = L*100;
im_adjusted_water = lab2rgb(im_water_lab);
imshowpair(im_water,im_adjusted_water,'montage');

%% Activity 3: Image Thresholding
im_apple = imread('./images/apples.jpg');%读取
im_apple_gray = rgb2gray(im_apple);%转灰度图

level = multithresh(im_apple_gray,2);%用大津法找两个分割线
seg_I = imquantize(im_apple_gray,level);%根据分割线将图像像素分入三个灰度区

figure(1)
RGB = label2rgb(seg_I,[1 0 0;0 1 0;1 1 1]);%将三个区域依次标记为红绿白
imshowpair(im_apple,RGB,'montage');%对比显示处理前后的图像

figure(2)
imhist(im_apple_gray)%显示灰度直方图
hold on 
plot([level(1) level(1)],ylim,'r')%标出分割线
plot([level(2) level(2)],ylim,'r')

%% Activity 4: Spot the Difference 
im = imread('./images/spot_the_difference.png');%读取图像内容
im_info = imfinfo('./images/spot_the_difference.png');%读取图像参数信息

im1 = im(:,1:350,:);%分离左右图像
im2 = im(:,351:700,:);

im_diff=int16(im1)-int16(im2);%计算左右图像差值图，转为有符号整数使差值可为负数。
im_diff=uint8(abs(im_diff));%差值转绝对值转8位无符号整数
im_diff=rgb2gray(im_diff);%转灰度图
im_diff=im_diff>40;%基于阈值判断得二值图

%二值图转RGB图，红色(R)层为基于差值判断的二值图，灰度值差值大于40为红色(255)，
%小于为黑色(0)。另外两层为纯黑层
im_diff=cat(3,im_diff*255,zeros(size(im_diff)),zeros(size(im_diff)));

im_diff=uint8(im_diff);%转整数

%与左侧原图线性组合，输出=原图值*0.4+红色标记图值*10。测试可知Matlab变量运算溢出时，
%会保持在该数据类型最大值。故此处第三个参数大于等于1即可。
im_diff = imlincomb(0.4,im2,10,im_diff,'uint8');

figure;%绘制输出
subplot(1,3,1);imshow(im1);
subplot(1,3,2);imshow(im2);
subplot(1,3,3);imshow(im_diff)