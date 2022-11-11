function txSigOFDM_All = transmitter(Fs, slots, bitsInAll, bitsPerQAM, numDataCarriers, ...
    symsPerSlot, offset, numFFT, cpLen, extraCP)
txSigOFDM_All = zeros(Fs/1e3, 1); % Preallocation for the transmit data matrix
for i = 1:slots
    bitsIn = bitsInAll((1:bitsPerQAM*numDataCarriers*symsPerSlot)+ ...
        (i-1)*bitsPerQAM*numDataCarriers*symsPerSlot);
    symsIn = qammod(bitsIn, 2^bitsPerQAM, 'InputType', 'bit', 'UnitAveragePower', true);
    symsIn = reshape(symsIn, [], symsPerSlot);
    symbolsInOFDM = [zeros(offset, symsPerSlot); symsIn; ...
        zeros(numFFT-offset-numDataCarriers, symsPerSlot)];
    ifftOut = ifft(ifftshift(symbolsInOFDM));
    
    txSigOFDM = [ifftOut(end-cpLen+1:end,:); ifftOut];  % CP
    txSigOFDM = reshape(txSigOFDM, [], 1);
    txSigOFDM_All((1:Fs/1e3/slots)+(i-1)*Fs/1e3/slots) = ...
    [txSigOFDM(end-cpLen-extraCP+1:end-cpLen); txSigOFDM];  % Extra CP
end