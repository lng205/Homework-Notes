clearvars;close all
M=[1 1 0 0 1 0 1 1];
g0=[1 0 1]; g1=[1 1 1];
g=[g0;g1];
C=myconvenc(M,g);

N=1e6;
SNR=0:0.5:4;
ber_theory=qfunc(sqrt(10.^(SNR./10)));
tiledlayout(2,2);

CL=3;%constrains length
CG={'x2+1','x2+x+1'};
trellis1=poly2trellis(CL,CG);
CL=5;
CG={'x4+x+1','x4+x3+x2+1'};
trellis2=poly2trellis(CL,CG);
CL=3;
CG={'x2+1','x2+x+1','x2+x+1'};
trellis3=poly2trellis(CL,CG);
data=randi([0 1],1,N);
%     data=[randi([0 1],1,N-3) 0 0 0];
BER=zeros(4,length(SNR));
for codemethod=1:4
    switch codemethod
        case 1
            C=hamming_code_7_4(data);
        case 2
            C=convenc(data,trellis1);
        case 3
            C=convenc(data,trellis2);
        case 4
            C=convenc(data,trellis3);
    end
    sig=2*C-1;
    ber=zeros(size(SNR));
    for i=1:length(SNR)
        Pn=1/10^(SNR(i)/10);
        noise=sqrt(Pn)*randn(size(sig));
        Rsig=sig+noise;
        R=(sign(Rsig)+1)/2;
        switch codemethod
            case 1
                Rdata=hammming_decode_7_4(R);
            case 2
                Rdata=vitdec(R,trellis1,20,'trunc','hard');
            case 3
                Rdata=vitdec(R,trellis2,20,'trunc','hard');
            case 4
                Rdata=vitdec(R,trellis3,20,'trunc','hard');
        end
        [~,ber(i)]=biterr(data,Rdata);
    end
    BER(codemethod,:)=ber;
end
nexttile; semilogy(SNR,BER(1,:),SNR,BER(2,:),SNR,ber_theory)
legend('7,4 hamming code','2,1,3 convolutional code','raw')

nexttile; semilogy(SNR,BER(2,:),SNR,BER(3,:),SNR,ber_theory)
legend('2,1,3 hamming code','2,1,5 convolutional code','raw')

nexttile; semilogy(SNR,BER(2,:),SNR,BER(4,:),SNR,ber_theory)
legend('2,1,3 hamming code','3,1,3 convolutional code','raw')