close all;clearvars;hold on;
dt=[];%delay time vetctor initialize
for SamplesPerSymbol = [10 20]
        % delay estimation
        EbNodB = 6;										% Eb/No (dB) value
        z = 10.^(EbNodB/10);							% convert to linear scale
        delay = 0:SamplesPerSymbol-1;									% delay vector
        BER = zeros(1,length(delay));					% initialize BER vector
        Errors = zeros(1,length(delay));				% initialize Errors vector
        BER_T = qfunc(sqrt(2*z))*ones(1,length(delay));	    % theoretical BER vector
        N = round(100./BER_T);							% 100 errors for ideal (zero ISI) system							
        FilterSwitch = 1;								% set filter switch (in=1 or out=0)
        for k=1:length(delay)
           [BER(k),Errors(k)] = MCBPSKrun(N(k),z,delay(k),FilterSwitch,SamplesPerSymbol);
        end
        delay = delay(BER==min(BER));
        dt=[dt delay/SamplesPerSymbol];

        % BER estimation
        EbNodB = 0:8;					% vector of Eb/No (dB) values
        z = 10.^(EbNodB/10);			% convert to linear scale
        BER = zeros(1,length(z));		% initialize BER vector
        Errors = zeros(1,length(z));	% initialize Errors vector
        BER_T = qfunc(sqrt(2*z));			% theoretical (AWGN) BER vector
        N = round(100./BER_T);          % 100 errors for ideal (zero ISI) system
        for k=1:length(z)
           [BER(k),Errors(k)] = BPSKrun(N(k),z(k),delay,FilterSwitch,SamplesPerSymbol);
        end
        semilogy(EbNodB,BER,'o')
end
semilogy(EbNodB,BER_T);
xlabel('E_b/N_0 - dB'); ylabel('Bit Error Rate'); grid
legend(sprintf('delay=%.2fTb, SamplesPerSymbol=10',...
        dt(1)),sprintf('delay=%.2fTb, SamplesPerSymbol=20', dt(2)),'theoretic BER without ISI');