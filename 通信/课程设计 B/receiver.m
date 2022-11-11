function dataRxSymbolsAll = receiver(rxSigFilt, L, numDataCarriers, symsPerSlot, slots, ...
    extraCP, numFFT, cpLen, offset, simTime)
    rxSigFiltSync = rxSigFilt(L:end);  % Account for filter delay
    dataRxSymbolsAll = zeros(numDataCarriers*symsPerSlot*slots, 1);
    for i = 1:slots
        rxSigSym = rxSigFiltSync(extraCP+(1:(numFFT+cpLen)*symsPerSlot)+ ...
            (i-1)*(extraCP+(numFFT+cpLen)*symsPerSlot));
        rxSigSym = reshape(rxSigSym, [], symsPerSlot);
        rxSymbol = rxSigSym(cpLen+1:end,:);  % Remove CP
        RxSymbols = fftshift(fft(rxSymbol));  % FFT
        dataRxSymbols = RxSymbols(offset+(1:numDataCarriers),:);  % Select data subcarriers
        dataRxSymbolsAll((1:numDataCarriers*symsPerSlot)+ ...
            (i-1)*numDataCarriers*symsPerSlot) = reshape(dataRxSymbols, [], 1);
    end
end