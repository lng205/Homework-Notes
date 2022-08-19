clc; clearvars; close all;
TdExpect = 1;
tiledlayout(2,2);
for fs = [10 7]
    [t,f,N,Td] = DFTparameter(TdExpect,fs);
    signal = 5*cos(6*pi*t)+3*sin(8*pi*t);
    nexttile; plot(t,signal,'o');hold on;
    spectrum = fft(signal);
    [spectrumPadded,Na] = DFTpadding(spectrum,999*N);
    Tda = (0:Na-1)/Na*Td;
    plot(Tda,Na/N*ifft(spectrumPadded));
    title(sprintf('fs=%d', fs)); xlabel('t'); ylabel('amplitude');
    legend('sampled signal','reconstructed signal');
    nexttile;plotComplex(f,fftshift(spectrum/N));
    title(sprintf('fs=%d', fs)); xlabel('f')
end