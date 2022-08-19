clearvars; close all;
%%transmitter
m = 20000;	bits = 2*m;						% number of symbols and bits
iphase = 0;									% initial phase
order = 5;									% filter order
bw = 0.2;									% normalized filter bandwidth
sps=10;
theta = zeros(1,m);
thetaout = zeros(1,sps*m);
data = round(rand(1,bits));
dd = data(1:2:bits-1);
qq = data(2:2:bits);
theta(1) = iphase;						% set initial phase
thetaout(1:sps) = theta(1)*ones(1,sps);
for k=2:m
   if dd(k) == 1
      phi_k = (2*qq(k)-1)*pi/4;
   else
      phi_k = (2*qq(k)-1)*3*pi/4;
   end   
   theta(k) = phi_k + theta(k-1);
   for i=1:sps
      j = (k-1)*sps+i;
      thetaout(j) = theta(k);
   end
end
d = cos(thetaout);
q = sin(thetaout);
[b,a] = butter(order,bw);
df = filter(b,a,d);
qf = filter(b,a,q);


%%receiver
snrdB=2:14;
berMin=zeros(size(snrdB));
for i=1:length(snrdB)
    snr=10^(snrdB(i)/10);
    sigma=sqrt(sps/2/snr);
    dReceived=df+sigma*randn(size(df));
    qReceived=qf+sigma*randn(size(qf));
    dDelta=dReceived(sps+1:end).*dReceived(1:end-sps)...
        +qReceived(sps+1:end).*qReceived(1:end-sps);
    qDelta=qReceived(sps+1:end).*dReceived(1:end-sps)...
        -dReceived(sps+1:end).*qReceived(1:end-sps);
    dMF_out=conv(dDelta,cos(pi/4)*ones(1,sps));% matched filter output
    qMF_out=conv(qDelta,sin(pi/4)*ones(1,sps));% matched filter output
    berMin(i)=0.5;
    for shift=0:sps-1
        dMF_out_downsamp=dMF_out(sps+shift:sps:end);% sampling at end of bit period
        qMF_out_downsamp=qMF_out(sps+shift:sps:end);% sampling at end of bit period
        dDemod=dMF_out_downsamp>0;
        qDemod=qMF_out_downsamp>0;
        dataDemod=reshape([dDemod;qDemod],1,[]);
        [~,ber]=biterr(data(3:end),dataDemod);
        if ber<berMin(i)
            berMin(i)=ber;
        end
    end
end
semilogy(snrdB,berMin,'o'); hold on
semilogy(snrdB,erfc(sqrt(2*10.^(snrdB/10))*sin(pi/8)))