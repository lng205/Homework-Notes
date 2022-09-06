function [BER,Errors]=MCBPSKrun(N,EbNo,delay,FilterSwitch,SamplesPerSymbol)
        NoiseSigma = sqrt(SamplesPerSymbol/(2*EbNo));   % scale noise level
        Errors = 0;									% initialize error counter
        
        %direct II type filter
        FilterOrder=5;
        [BTx,ATx] = butter(FilterOrder,2/SamplesPerSymbol);  		% compute filter parameters
        TxFilterReg=zeros(1,FilterOrder+1);             %channel
        BRx = ones(1,SamplesPerSymbol);                 % matched filter parameters
        RxFilterReg=zeros(1,SamplesPerSymbol);          %matched filter
        
        pulseshape=ones(1,SamplesPerSymbol);
        
        BitBuf = 0;              %previous sent bit buffer initialize
        
        for n = 1:N
                Bit = randi([0 1]);
                SymbolSamples = (2*Bit-1)*pulseshape;
                
                if FilterSwitch == 0
                        Tx = SymbolSamples;
                else
                        for i = 1:SamplesPerSymbol
                                TxFilterReg = [ATx*[SymbolSamples(i) -TxFilterReg(1:FilterOrder)]' TxFilterReg(1:FilterOrder)];
                                Tx(i) = BTx*TxFilterReg';
                        end
                end
                
                NoiseSamples = NoiseSigma*randn(size(Tx));
                Rx = Tx + NoiseSamples;
                
                if delay == 0
                        MatchFilterSample = Rx(SamplesPerSymbol);
                else
                        for i=1:SamplesPerSymbol
                                RxFilterReg = [Rx(i) RxFilterReg(1:SamplesPerSymbol-1)];
                                Rx(i) = BRx*RxFilterReg';
                        end
                        MatchFilterSample = Rx(delay);
                end
                
                BitReceived = (sign(MatchFilterSample)+1)/2;
                if BitReceived ~= BitBuf
                        Errors = Errors + 1;
                end
                BitBuf = Bit;
        end
        BER = Errors/N;
end