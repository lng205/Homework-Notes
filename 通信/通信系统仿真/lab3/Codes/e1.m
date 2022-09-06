clc; close all; clearvars;
% Set default parameters
bdoppler = 64;				% default doppler sampling
fs = 8192; 					% default sampling frequency
tduration = 1;				% default duration
%
ts = 1.0/fs;				% sampling period
n = tduration*fs;			% number of samples
t = ts*(0:n-1);			    % time vector
ndelay = 8; 
%
% Generate two uncorrelated seq of Complex Gaussian Samples
%
z1 = randn(1,n)+1i*randn(1,n);
% z2 = z1;
z2 = randn(1,n)+1i*randn(1,n);
%
% Filter the two uncorrelated samples to generate correlated sequences
%
coefft = exp(-bdoppler*2*pi*ts);     
zz1 = zeros(1,n);
zz2 = zeros(1,n);
for k = 2:n   
   zz1(k) = z1(k)+coefft*zz1(k-1);
   zz2(k) = z2(k)+coefft*zz2(k-1);
end
f1 = 512; f2=128;
x1 = exp(1i*2*pi*f1*t)+exp(1i*2*pi*f2*t);	    % complex signal
y1 = x1.*zz1;					 	% first output component 
y2 = x1.*zz2; 						% second output component
y(1:ndelay) = y1(1:ndelay);
y(ndelay+1:n) = y1(ndelay+1:n)+y2(1:n-ndelay);
%
% Plot the results 
%
[psdzz,freq] = log_psd(y,n,ts);
figure;
subplot(2,1,1);plot(freq,psdzz); grid;
title('PSD of multipath channel Response');

[psdzz1,freq] = log_psd(y1,n,ts);
subplot(2,1,2);plot(freq,psdzz1); grid;
title('PSD of single path channel Response');

nn = 0:499;
figure;
subplot(2,1,1)
plot(nn,imag(x1(1:500)),nn,real(y1(1:500))); grid;
title('Input and the First Component of the Output');
xlabel('Sample Index')
ylabel('Signal Level')
subplot(2,1,2)
plot(nn,imag(x1(1:500)),nn,real(y(1:500)));grid;
title('Input and the Total Output')
xlabel('Sample Index')
ylabel('Signal Level')
% End of script file.