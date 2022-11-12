clearvars; close all

s = rng(777);  %random seed

%% Parameters
numRBs = 8;
L = 513;
Fs = 30.72e6;  % sample rate
bitsPerQAM = 8;  % bits per QAM symbol
snrdB = -5:3:30;
simTime = 10;

% band1
numFFT = 2048;
rbSize = 12;
numDataCarriers = numRBs*rbSize;
cpLen = 144;
extraCP = 160-144;  % extra CP for the first OFDM symbol in each slot
symsPerSlot = 7;  % 7 OFDM symbols in one slot(0.5ms).
slots = 2;
toneOffset = 6;        % excess bandwidth (in subcarriers)
offset = (numFFT-numDataCarriers)/2;

% band2
numFFT2 = 1024;
rbSize2 = 6;
numDataCarriers2 = numRBs*rbSize2;
cpLen2 = 200;
extraCP2 = 224-200;
symsPerSlot2 = 5;  % 5 OFDM symbols in one slot(0.2ms).
slots2 = 5;
toneOffset2 = 4;
offset2 = (offset+numDataCarriers+2*toneOffset2+toneOffset)/2;

%% Filter
n = -floor(L/2):floor(L/2);
pb = sinc((numDataCarriers+2*toneOffset)/numFFT*n);  % Sinc function prototype filter

% w = (0.5*(1+cos(2*pi.*n/(L-1)))).^0.6;  % Sinc truncation window
% w = hamming(L)';
w = hann(L)';

fnum = (pb.*w)/sum(pb.*w);  % Normalized lowpass filter coefficients
filtTx = dsp.FIRFilter(fnum);  % Use dsp filter objects for filtering
filtRx = clone(filtTx);

% band2
pb2 = sinc((numDataCarriers2+2*toneOffset2)/numFFT2*n);  % Sinc function prototype filter
fnum2 = (pb2.*w)/sum(pb2.*w);  % Normalized lowpass filter coefficients
fnum2 = fnum2.*exp(1i*2*pi*n*(numDataCarriers+2*toneOffset2+toneOffset)/numFFT);
filtTx2 = dsp.FIRFilter(fnum2);
filtRx2 = dsp.FIRFilter(conj(fnum2(end:-1:1)));

%% Transmit Processing
tic;
err = zeros(size(snrdB));
err2 = zeros(size(snrdB));
errN = zeros(size(snrdB));
errN2 = zeros(size(snrdB));
for k = 1:simTime
    for i = 1:length(snrdB)
        bitsLen = bitsPerQAM*numDataCarriers*symsPerSlot*slots;  % bits length
        bitsIn = randi([0 1], bitsLen, 1);
        txSigOFDM = transmitter(Fs, slots, bitsIn, bitsPerQAM, numDataCarriers, ...
            symsPerSlot, offset, numFFT, cpLen, extraCP);
        txSigFOFDM = filtTx([txSigOFDM; zeros(L-1,1)]);  % Filter, with zero-padding to flush tail.
        
        % band2
        bitsLen2 = bitsPerQAM*numDataCarriers2*symsPerSlot2*slots2;
        bitsIn2 = randi([0 1], bitsLen2, 1);
        txSigOFDM2 = transmitter(Fs, slots2, bitsIn2, bitsPerQAM, numDataCarriers2, ...
            symsPerSlot2, offset2, numFFT2, cpLen2, extraCP2);
        txSigFOFDM2 = filtTx2([txSigOFDM2; zeros(L-1,1)]);
        
        txSig = txSigFOFDM + txSigFOFDM2;
        
        %% Channel
%         rayleighchan = comm.RayleighChannel('SampleRate',Fs);
%         txSig = rayleighchan(txSig);
% 
%         ricianchan = comm.RicianChannel('SampleRate',Fs);
%         txSig = ricianchan(txSig);

        rxSig = awgn(txSig, snrdB(i), 'measured');  % Add WGN

        %% Receive Processing
        % band1
        rxSigFilt = filtRx(rxSig);  % Receive matched filter
        dataRxSymbols = receiver(rxSigFilt, L, numDataCarriers, symsPerSlot, slots, ...
            extraCP, numFFT, cpLen, offset);
        rxBits = qamdemod(dataRxSymbols, 2^bitsPerQAM, 'OutputType', 'bit', ...
            'UnitAveragePower', true);
        [err(i), ~] = biterr(bitsIn, rxBits);  % Perform hard decision and measure errors
        
        % band2
        rxSigFilt2 = filtRx2(rxSig);  % Receive matched filter
        dataRxSymbols2 = receiver(rxSigFilt2, L, numDataCarriers2, symsPerSlot2, slots2, ...
            extraCP2, numFFT2, cpLen2, offset2);
        rxBits2 = qamdemod(dataRxSymbols2, 2^bitsPerQAM, 'OutputType', 'bit', ...
            'UnitAveragePower', true);
        [err2(i), ~] = biterr(bitsIn2, rxBits2);
    end
    errN = errN + err;
    errN2 = errN2 + err2;
end
ber = errN/simTime/length(bitsIn);
ber2 = errN2/simTime/length(bitsIn2);
toc;

%% Output
semilogy(snrdB, ber, '*-', snrdB, ber2, '*-');
% semilogy(snrdB, (ber+ber2)/2)
xlabel('snr/dB'); ylabel('ber');
title(['F-OFDM, ' 'toneOffset1 = ' num2str(toneOffset) '  toneOffset2 = ' num2str(toneOffset2)])
% legend('band1', 'band2')

% Set up a figure for spectrum plot
hFig = figure;
axis([-0.2 0.2 -140 -20]);
hold on;
grid on
xlabel('Normalized frequency'); ylabel('PSD (dBW/Hz)')
title(['F-OFDM, ' 'toneOffset1 = ' num2str(toneOffset) '  toneOffset2 = ' num2str(toneOffset2)])

% Plot power spectral density (PSD)
[psd,f] = periodogram(txSigOFDM+txSigOFDM2, ...
    rectwin(length(txSigOFDM)), numFFT*2, 1, 'centered');
plot(f,10*log10(psd));

[psd,f] = periodogram(txSig, rectwin(length(txSig)), numFFT*2, 1, 'centered');
plot(f,10*log10(psd));
legend('OFDM', 'FOFDM');

% Plot received symbols constellation
switch bitsPerQAM
    case 2  % QPSK
        refConst = qammod((0:3).', 4, 'UnitAveragePower', true);
    case 4  % 16QAM
        refConst = qammod((0:15).', 16,'UnitAveragePower', true);
    case 6  % 64QAM
        refConst = qammod((0:63).', 64,'UnitAveragePower', true);
    case 8  % 256QAM
        refConst = qammod((0:255).', 256,'UnitAveragePower', true);
end
constDiagRx = comm.ConstellationDiagram( ...
    'ShowReferenceConstellation', true, ...
    'ReferenceConstellation', refConst, ...
    'Position', figposition([20 15 30 40]), ...
    'EnableMeasurements', true, ...
    'MeasurementInterval', length(dataRxSymbols2), ...
    'Title', 'F-OFDM Demodulated Symbols', ...
    'Name', 'F-OFDM Reception', ...
    'XLimits', [-1.5 1.5], 'YLimits', [-1.5 1.5]);
constDiagRx(dataRxSymbols2);