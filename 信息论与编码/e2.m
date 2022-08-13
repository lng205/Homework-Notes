clearvars; close all;
C=@(p)1+p.*log2(p)+(1-p).*log2(1-p);
p=0:0.01:1;
figure; plot(p,C(p)); title('C of binary channel')