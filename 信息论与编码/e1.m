clearvars; close all;
%1
H2=@(p)-p.*log2(p)-(1-p).*log2(1-p);
p=0:0.01:1;
plot(p,H2(p)); title('H of binary variable')

%2
figure; tiledlayout(2,2);
PIC = {'airplane_768KB_512x512.bmp','lena_768KB_512x512.bmp','fruits_461KB_512x512.png','fruits_461KB_512x512.png'};
for i=1:4
    I=rgb2gray(imread(PIC{i}));
    nexttile;imshow(I);
    E=entropy(I);
    print(sprintf('entropy=%.4f',E))
end

%3
C=@(p)1+p.*log2(p)+(1-p).*log2(1-p);
p=0:0.01:1;
figure; plot(p,C(p)); title('C of binary channel')