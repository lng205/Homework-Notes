clearvars; close all; clc

N_total = 1024;%number of subcarriers
N=N_total/2-1;%number of data per blck
Nb = 4096;%blocks per frame
Lcp = 16;%length of ciyclic prefix
K = 3.2;%DC offset ratio
SNRdB = 0:15;%SNR(dB)
SNR=10.^(SNRdB/10);
Es=1;%Energy per symbol
BER_theoretic=@(M,gamma) 4*(sqrt(M)-1)/(sqrt(M)*log2(M))*qfunc(sqrt(3*log2(M)/(M-1).*gamma))...
        + 4*(sqrt(M)-2)/(sqrt(M)*log2(M))*qfunc(3*sqrt(3*log2(M)/(M-1).*gamma));
fb=80e6;%LED -3dB bandwidth
L=14;%length of LED inpulse response
fs=500e6;
t=(0:L)/fs;
h=exp(-2*pi*fb.*t);
h=h/sum(h);%normalize

for ModOrder=[4 16]
    bps=log2(ModOrder);
    Eb=Es/bps;
    data = randi([0 1],[N*Nb*bps,1]);%random bit stream
    sigQAM = sqrt(Es)*qammod(data, ModOrder, 'InputType', 'bit','UnitAveragePower',true);
    sigQAM = reshape(sigQAM,N,Nb);%Reshape data. Each column is a  DCO-OFDM block with legnth N.
    sig = [zeros(1,Nb);sigQAM;zeros(1,Nb);conj(sigQAM(N:-1:1,:))];%Hermitian symmetry
    sig = sig./fft([h zeros(1,N_total-L-1)]');%pre equalization
    sig = sqrt(N_total)*ifft(sig);%IFFT
    sig = sig + K*Es;%DC bias
    sig(sig<0) = 0;%cut off
    Tx = [sig(end-Lcp+1:end,:);sig];%CP
    Tx = conv(h,reshape(Tx,1,[]));%LED channel
    Tx = Tx(1:end-L);
    
    BER = zeros(1,length(SNR));%pre allocate output matrix
    for k = 1:length(SNR)
        Rx = Tx+sqrt(Es/SNR(k))*randn(size(Tx));
        Rx = reshape(Rx,[],Nb);
        sig= Rx(Lcp+1:end,:);%remove CP
        sig = fft(sig)/sqrt(N_total);
        sig= sig(2:N+1,:);%extract original symbols
        dataReceived = qamdemod(sig/sqrt(Es),ModOrder,...
            'OutputType','bit','UnitAveragePower',true);%qamdemod
        [~, BER(k)] = biterr(data,reshape(dataReceived,[],1));
    end
    semilogy(SNRdB, BER,'o'); hold on
    plot(SNRdB,BER_theoretic(ModOrder,SNR/bps));
end
legend('QPSK','QPSK theoretic','16QAM','16QAM theoretic'); title('DCO-OFDM simulation')
xlabel('SNR/dB'); ylabel('BER/dB')