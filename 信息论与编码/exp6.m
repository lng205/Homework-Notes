clearvars; close all;
% M=[1 0 1 1 0 1 0 1 1 0];
% disp("data"); disp(M)
% C=hamming_code_7_4(M);
% disp("code"); disp(C)
% R=C;
% R(4)=~R(4);
% R(5)=~R(5);
% disp("received data"); disp(R)
% MR=hammming_decode_7_4(R);
% disp("decode"); disp(MR)

N=1e6;
data=randi([0 1],1,N);
C=hamming_code_7_4(data);
sig=2*C-1;
SNR=0:0.5:5;
ber=zeros(size(SNR));
for i=1:length(SNR)
    Pn=1/10^(SNR(i)/10);
    noise=sqrt(Pn)*randn(size(sig));
    Rsig=sig+noise;
    R=(sign(Rsig)+1)/2;
    Rdata=hammming_decode_7_4(R);
    [~,ber(i)]=biterr(data,Rdata);
end
semilogy(SNR,ber,'ro-'); hold on
plot(SNR,qfunc(sqrt(10.^(SNR./10))))

function C = hamming_code_7_4(M)
%HAMMING_CODE_7_4 此处显示有关此函数的摘要
%   此处显示详细说明
    n=7; k=4;
    P=[ 1 0 1;
        0 1 1;
        1 1 1;
        1 1 0];
    G=[eye(k) P];
    M=reshape(M,1,[]);
    M=[M zeros(1,rem(length(M),4))];
    M=reshape(M,4,[])';
    C=rem(M*G,2);
    C=reshape(C',1,[]);
end

function MR = hammming_decode_7_4(R)
    R=reshape(R,7,[])';
    n=7; k=4;
    P=[ 1 0 1;
        0 1 1;
        1 1 1;
        1 1 0];
    H=[P' eye(n-k)];
    [~,order]=sort(binaryVectorToDecimal(H'));
    
    S=rem(R*H',2);
    
    S=binaryVectorToDecimal(S);
    p=find(S>0);
    S(p)=order(S(p));
    
    for i=1:length(S)
        if(S(i))
            R(i,S(i))=~R(i,S(i));
        end
    end
    MR=reshape(R(:,1:k)',1,[]);
end