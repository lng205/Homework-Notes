close all;clearvars;
img=imread('./images/beach.jpg') ;
figure, imagesc(img) ; axis image ; axis off ;
[x,y]= snakeinit;

f=double(img) ; f=-f(:,:,1)*0.5+f(:,:,2)*0.5+f(:,:,3)*1;%R:G:B=-0.5:0.5:1
f=f-min(f(:)) ; f=f/max(f(:)) ;
f=(f>0.25).*f ;
h=fspecial('gaussian',10,3) ;
f=imfilter(double(f),h,'symmetric') ;

figure, imagesc(f) ; colormap(jet) ; colorbar ;
axis image ; axis off ; 

[px,py] = gradient(-f);
kappa=1/(max(max(px(:)),max(py(:)))) ;
[x,y]=snake(x,y,0.1,0.01,0.4*kappa,0.05,px,py,0.4,1,f);

figure, imagesc(img) ;  axis image ; axis off ; hold on ;
plot([x;x(1)],[y;y(1)],'r','LineWidth',2) ; hold off ;
