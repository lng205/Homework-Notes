clearvars;close all;
%% time domain method
%parameter setting
SimPeriod=2; fRes=1/SimPeriod;%SimPeriod=2s
fs=2^14; N=ceil(SimPeriod*fs);
t=(0:N-1)/fs; f=((0:N-1)-floor(N/2))*fs/N;%fs=16kHz
PathNum=1e5; PathNumPerCycle=1e3; CycleNum=PathNum/PathNumPerCycle;%multipath
fc=5e9; lambda=3e8/fc; vmax=120/3.6; fdmax=vmax/lambda;%radio wave

% calculate
thetaDist = makedist('Uniform',-pi,pi);
a=zeros(length(t),1); R=a;
BAR = waitbar(0,'calculating...');tic;
for i = 1:CycleNum
    hp = randn(1,PathNumPerCycle)+1i*randn(1,PathNumPerCycle);
    theta = random(thetaDist,1,PathNumPerCycle);
    fd = fdmax*cos(theta);
    Phase = 2*pi*t'*fd;
    a = a + exp(1i*Phase)*hp';
    R = R + exp(1i*Phase)*(hp.*conj(hp))';
    waitbar(i/CycleNum,BAR);
end
close(BAR);toc
fDoppler = fftshift(fft(R));

GraphDraw(t,a,f,fDoppler);%output
savefig('Clarke Channel.time domain method.fig');

%% frequency domain method
%calculate
hp = randn(1,N)+1i*randn(1,N);
fd = Doppler_spectrum(fdmax,f);
fDoppler = fftshift(fft(hp)).*sqrt(fd);
a = ifft(fftshift(fDoppler));

GraphDraw(t,a,f,fDoppler);%output
savefig('Clarke Channel.frequency domain method.fig');