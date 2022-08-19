clearvars; close all;
[t,f,~,~]=DFTparameter(1,801);
X=@(f)(4*double(abs(f)>=90&abs(f)<=110));
tiledlayout(3,2);
for f0=[100 95 90]
    XLp=2*X(f+f0).*(f+f0>=0);
    XLpd=0.5*(XLp+conj(fliplr(XLp)));
    nexttile; plot(f,XLpd); grid on;
    title(sprintf('f0=%d', f0));
    xlabel('f'); ylabel('aplitude')
    nexttile; plot(t,ifft(ifftshift(XLpd)));
    title(sprintf('f0=%d', f0));
    xlabel('t'); ylabel('aplitude')
end