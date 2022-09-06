clc; clearvars; close all;
%
% Default parameters
%
NN = 8192;								% number of symbols
tb = 0.5;								% bit time
fs = 16;                                % samples/symbol
ebn0db = [1:2:14];						% Eb/N0 vector
%
% Establish QPSK signals
%
x = random_binary(NN,fs)+i*random_binary(NN,fs);   % QPSK signal
for i=1:2
    %
    % Input powers and delays
    %
    if i==1 %AWGN
        p0=1;
        p1=0;
    else    %Rayleigh&Jake
        p0 = 0;
        p1 = 1;
    end
    delay0 = 0; delay1 = 0;
    %
    % Set up the Complex Gaussian (Rayleigh) gains
    %
    gain = sqrt(p1)*abs(randn(1,NN) + i*randn(1,NN));
    %
    %interpolation, slow fading
    %
    for k = 1:NN
       for kk=1:fs
          index=(k-1)*fs+kk;
          ggain(1,index)=gain(1,k);
       end
    end
    
    y1 = x;
    for k=1:delay1
       y2(1,k) = y1(1,k)*sqrt(p0);
    end
    for k=(delay1+1):(NN*fs)
       y2(1,k)= y1(1,k)*sqrt(p0) + ...
                 y1(1,k-delay1)*ggain(1,k);
    end
    %
    % Matched filter
    %
    b = ones(1,fs); b = b/fs; a = 1;
    y = filter(b,a,y2);
    %
    % End of simulation 
    %
    % Use the semianalytic BER estimator. The following sets 
    % up the semi analytic estimator. Find the maximum magnitude 
    % of the cross correlation and the corresponding lag.
    %
    [cor lags] = vxcorr(x,y);
    [cmax nmax] = max(abs(cor));
    timelag = lags(nmax);
    theta = angle(cor(nmax))
    y = y*exp(-i*theta);     								% derotate 
    %
    % Noise BW calibration
    %
    hh = impz(b,a); ts = 1/16; nbw = (fs/2)*sum(hh.^2);
    %
    % Delay the input, and do BER estimation on the last 128 bits. 
    % Use middle sample. Make sure the index does not exceed number
    % of input points. Eb should be computed at the receiver input. 
    %
    index = (10*fs+8:fs:(NN-10)*fs+8);
    xx = x(index);
    yy = y(index-timelag+1);
    [n1 n2] = size(y2); ny2=n1*n2;
    eb = tb*sum(sum(abs(y2).^2))/ny2;
    eb = eb/2;
    [peideal,pesystem] = qpsk_berest(xx,yy,ebn0db,eb,tb,nbw);
    pe(i,:)=pesystem;
end
fd = 100; impw = jakes_filter(fd);
%
% Generate tap input processes and Run through doppler filter.
%
x1 = randn(1,256)+i*randn(1,256); y1 = filter(impw,1,x1);
x2 = randn(1,256)+i*randn(1,256); y2 = filter(impw,1,x2);
%
% Discard the first 128 points since the FIR filter transient.
% Scale them for power and Interpolate weight values.
% Interpolation factor=100 for the QPSK sampling rate of 160000/sec.
%
z1(1:128) = y1(129:256); z2(1:128) = y2(129:256);
z2 = sqrt(0.5)*z2; m = 100;
tw1 = linear_interp(z1,m); tw2 = linear_interp(z2,m);
%
% Generate QPSK signal and filter it.
%
nbits = 512; nsamples = 16; ntotal = 8192;
qpsk_sig = random_binary(nbits,nsamples)+i*random_binary(nbits,nsamples);
%
% Genrate output of tap1 (size the vectors first). 
%
input1 = qpsk_sig(1:8184); output1 = tw1(1:8184).*input1;
%
% Delay the input by eight samples (this is the delay specified 
% in term of number of samples at the sampling rate of 
% 16,000 samples/sec and genrate the output of tap 2.
%
input2 = qpsk_sig(9:8192); output2 = tw2(9:8192).*input2;
%
% Add the two outptus and genrate overall output.
%
qpsk_output = output1+output2;
index = (10*fs+8:fs:(NN-10)*fs+8);
xx = qpsk_sig(1:8184);
yy = qpsk_output;
[n1,~] = size(y2); ny2=n1*n2;
eb = tb*sum(sum(abs(y2).^2))/ny2;
eb = eb/2;
[peideal,pesystem] = qpsk_berest(xx,yy,ebn0db,eb,tb,nbw);
pe(3,:)=pesystem;
figure
semilogy(ebn0db,pe(1,:),'b*-',ebn0db,pe(2,:),'r+-',ebn0db,pe(3,:),'go-')
xlabel('E_b/N_0 (dB)'); ylabel('Probability of Error'); grid
axis([0 14 10^(-10) 1])