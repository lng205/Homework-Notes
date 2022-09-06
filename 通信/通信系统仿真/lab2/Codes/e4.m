clearvars; close all;
TdExpect=1; fs=801;
[t,f,~,~]=DFTparameter(TdExpect,fs);
tiledlayout(5,1);
xdA=6*cos(2*sin(24*pi*t)); xqA=6*sin(2*sin(24*pi*t));
nexttile; plot(t,xdA); nexttile; plot(t,xqA)

f0=120;
X=6*cos(f0*2*pi*t+2*sin(24*pi*t));
F=fftshift(fft(X));
nexttile; plot(f,abs(F)/fs); title('X(f) amplitude')
nexttile; plot(f,angle(F)); title('X(f) phase')

Flp=2*fftshift(fft(X.*exp(-1i*2*pi*f0*t))).*(abs(f)<f0);
nexttile; plot(f,abs(Flp)/fs); title('Xlp(f) amplitude')

Flpd=0.5*(Flp+conj(fliplr(Flp))); Flpq=-1i*0.5*(Flp-conj(fliplr(Flp)));
xd=ifft(ifftshift(Flpd)); xq=ifft(ifftshift(Flpq),'symmetric');
nexttile(1); hold on; plot(t,xd,'.')
title('xd(t)'); legend('Analytic','Simulated')
nexttile(2); hold on; plot(t,xq,'.')
title('xq(t)'); legend('Analytic','Simulated')