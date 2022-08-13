% N=20;
% C=1:N;
% code=GroupInterleave(C,7,4)
% Cdecode=iGroupInterleave(code,7,4,N)
% code=ConvInterleave(C,4,7)
% Cdecode=iConvInterleave(code,4,7,N)
% [code,order]=RandInterleave(C,28)
% Cdecode=iRandInterleave(code,order,N)
N=1e6;
data=randi([0 1],1,N);
SNR=0:0.5:4;
ber_theory=qfunc(sqrt(10.^(SNR./10)));
CL=3;%constrains length
CG={'x2+1','x2+x+1'};
trellis=poly2trellis(CL,CG);
BER=zeros(5,length(SNR));
for codemethod=1:5
    switch codemethod
        case 1
            C=hamming_code_7_4(data);
        case 2
            C=convenc(data,trellis);
        case 3
            C=hamming_code_7_4(data);
            Lcode=length(C);
            C=GroupInterleave(C,7,4);
            C=convenc(C,trellis);
        case 4
            C=hamming_code_7_4(data);
            Lcode=length(C);
            C=ConvInterleave(C,4,7);
            C=convenc(C,trellis);
        case 5
            C=hamming_code_7_4(data);
            Lcode=length(C);
            [C,order]=RandInterleave(C,28);
            C=convenc(C,trellis);
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
                Rdata=vitdec(R,trellis,20,'trunc','hard');
            case 3
                Rdata=vitdec(R,trellis,20,'trunc','hard');
                Rdata=iGroupInterleave(Rdata,7,4,Lcode);
                Rdata=hammming_decode_7_4(Rdata);
            case 4
                Rdata=vitdec(R,trellis,20,'trunc','hard');
                Rdata=iConvInterleave(Rdata,4,7,Lcode);
                Rdata=hammming_decode_7_4(Rdata);
            case 5
                Rdata=vitdec(R,trellis,20,'trunc','hard');
                Rdata=iRandInterleave(Rdata,order,Lcode);
                Rdata=hammming_decode_7_4(Rdata);
        end
        [~,ber(i)]=biterr(data,Rdata);
    end
    BER(codemethod,:)=ber;
end
semilogy(SNR,ber_theory,SNR,BER(1,:),SNR,BER(2,:),SNR,BER(3,:),...
    SNR,BER(4,:),SNR,BER(5,:))
legend('raw','7,4 hamming code','2,1,3 convolutional code',...
    '7,4 group interleave','4,7 conv interleave','28 rand interleave')