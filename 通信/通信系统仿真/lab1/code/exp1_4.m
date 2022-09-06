close all;
%% BER
clearvars;
Eb = 22:0.5:26; No = -50;					% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70;					% Channel attenuation in dB
EbNodB = (Eb-ChannelAttenuation)-No;	    % Eb/No in dB
EbNo = 10.^(EbNodB./10);					% Eb/No in linear units
BER_T = 0.5*erfc(sqrt(EbNo)); 			    % BER (theoretical)
N = round(100./BER_T);          			% Symbols to transmit
BER_MC = zeros(size(Eb)); 					% Initialize BER vector of QDPSK
BER_MC1 = zeros(size(Eb)); 					% Initialize BER vector of QPSK
for k=1:length(Eb)        					% Main Loop
  BER_MC(k) = MCQPSKrun(N(k),Eb(k),No,ChannelAttenuation,0,0,0,0,1,0);%QDPSK
  BER_MC1(k) = MCQPSKrun(N(k),Eb(k),No,ChannelAttenuation,0,0,0,0,0,0);%QPSK
end
%QDPSK & QPSK
figure;semilogy(EbNodB,BER_MC,'o',EbNodB,BER_MC1,'x',EbNodB,2*BER_T,'-', EbNodB,BER_T)
xlabel('Eb/No (dB)'); ylabel('Bit Error Rate'); 
legend('MC BER Estimate of QDPSK', 'MC BER Estimate of QPSK', 'Theoretical BER of QDPSK', 'Theoretical BER of QPSK'); grid;

%% delay
clearvars;
Eb = 23; No = -50;				% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70;		% channel attenuation in dB
N = 1000;                        
delay = -0.1:0.1:0.5;                  
EbNo = 10.^(((Eb-ChannelAttenuation)-No)/10);
BER_MC = zeros(size(delay));       
for k=1:length(delay)            
  BER_MC(k) = MCQPSKrun(N,Eb, No,ChannelAttenuation,delay(k),0,0,0,1,0);
  BER_MC1(k) = MCQPSKrun(N,Eb, No,ChannelAttenuation,delay(k),0,0,0,0,0);%QPSK
end
BER_T = 0.5*erfc(sqrt(EbNo))*ones(size(delay)); % Theoretical BER
figure;semilogy(delay,BER_MC,'o', delay,BER_MC1,'x', delay,2*BER_T,'-', delay,BER_T)    %Plot BER vs Delay
xlabel('Delay (symbols)'); ylabel('Bit Error Rate'); 
legend('MC BER Estimate of QDPSK', 'MC BER Estimate of QPSK', 'Theoretical BER of QDPSK', 'Theoretical BER of QPSK');grid;

%% phase sync error
clearvars;
PhaseError = 0:10:90; 				% Phase Error at Receiver
Eb = 24; No = -50;       	       	% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70; 			% dB
EbNo = 10.^((Eb-ChannelAttenuation-No)/10); 
BER_T = 0.5*erfc(sqrt(EbNo)*ones(size(PhaseError)));
N = round(100./BER_T); 
BER_MC = zeros(size(PhaseError)); 
for k=1:length(PhaseError)
  BER_MC(k) = MCQPSKrun(N(k),Eb,No,ChannelAttenuation,0,0, PhaseError(k),0,1,0);
  BER_MC1(k) = MCQPSKrun(N(k),Eb,No,ChannelAttenuation,0,0, PhaseError(k),0,0,0);
end
figure;semilogy(PhaseError,BER_MC,'o', PhaseError,BER_MC1,'x', PhaseError,2*BER_T,'-', PhaseError,BER_T)
xlabel('Phase Error (Degrees)'); 
ylabel('Bit Error Rate'); 
legend('MC BER Estimate of QDPSK', 'MC BER Estimate of QPSK', 'Theoretical BER of QDPSK', 'Theoretical BER of QPSK'); grid;

%% phase jitter
clearvars;
PhaseBias = 0; PhaseJitter = 0:2:30;
Eb = 24; No = -50;              				% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70; 						% dB
EbNo = 10.^((Eb-ChannelAttenuation-No)/10); 
BER_T = 0.5*erfc(sqrt(EbNo)*ones(size(PhaseJitter)));
N = round(100./BER_T); 
BER_MC = zeros(size(PhaseJitter)); 
for k=1:length(PhaseJitter)
  BER_MC(k) = MCQPSKrun(N(k),Eb,No,ChannelAttenuation,0,0, PhaseBias,PhaseJitter(k),1,0);
  BER_MC1(k) = MCQPSKrun(N(k),Eb,No,ChannelAttenuation,0,0, PhaseBias,PhaseJitter(k),0,0);
end
figure;semilogy(PhaseJitter,BER_MC,'o', PhaseJitter,BER_MC1,'x', PhaseJitter,2*BER_T,'-', PhaseJitter,BER_T)
xlabel('Phase Error Std. Dev. (Degrees)'); 
ylabel('Bit Error Rate'); 
legend('MC BER Estimate of QDPSK', 'MC BER Estimate of QPSK', 'Theoretical BER of QDPSK', 'Theoretical BER of QPSK'); grid;

%% Sym jitter
clearvars;
SymJitter = 0:0.02:0.2;
Eb = 24; No = -50;              	% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70; 			% channel attenuation in dB
EbNo = 10.^((Eb-ChannelAttenuation-No)/10); 
BER_T = 0.5*erfc(sqrt(EbNo)*ones(size(SymJitter)));
N=round(100./BER_T); 
BER_MC = zeros(size(SymJitter)); 
for k=1:length(SymJitter)
  BER_MC(k) = MCQPSKrun(N(k),Eb,No,ChannelAttenuation,0,SymJitter(k),0,0,1,0);
  BER_MC1(k) = MCQPSKrun(N(k),Eb,No,ChannelAttenuation,0,SymJitter(k),0,0,0,0);
end
figure;semilogy(SymJitter,BER_MC,'o', SymJitter,BER_MC1,'x', SymJitter,2*BER_T,'-', SymJitter,BER_T)
xlabel('Symbol Timing Error Std. Dev. (Symbols)'); 
ylabel('Bit Error Rate'); 
legend('MC BER Estimate of QDPSK', 'MC BER Estimate of QPSK', 'Theoretical BER of QDPSK', 'Theoretical BER of QPSK'); grid;

%% ISI
%test delay
clearvars;
Eb = 23; No = -50;				% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70;		% channel attenuation in dB
N = 1000;                        
delay = -0.1:0.1:0.5;                  
BER_MC = zeros(size(delay));       
for k=1:length(delay)
  BER_MC(k) = MCQPSKrun(N,Eb, No,ChannelAttenuation,delay(k),0,0,0,0,1);%QPSK+ISI
end
delay = delay(BER_MC==min(BER_MC));

%estimate BER
clearvars -except delay;
Eb = 22:0.5:26; No = -50;					% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70;					% Channel attenuation in dB
EbNodB = (Eb-ChannelAttenuation)-No;	    % Eb/No in dB
EbNo = 10.^(EbNodB./10);					% Eb/No in linear units
BER_T = 0.5*erfc(sqrt(EbNo)); 			    % BER (theoretical)
N = round(100./BER_T);          			% Symbols to transmit
BER_MC1 = zeros(size(Eb)); 					% Initialize BER vector of QPSK
BER_MC2 = zeros(size(Eb)); 					% Initialize BER vector of QPSK+ISI
for k=1:length(Eb)        					% Main Loop
  BER_MC1(k) = MCQPSKrun(N(k),Eb(k),No,ChannelAttenuation,0,0,0,0,0,0);%QPSK
  BER_MC2(k) = MCQPSKrun(N(k),Eb(k),No,ChannelAttenuation,delay,0,0,0,0,1);%QPSK+ISI
end
%QPSK & QPSK+ISI
figure;semilogy(EbNodB,BER_MC1,'o',EbNodB,BER_MC2,'x',EbNodB,BER_T)
xlabel('Eb/No (dB)'); ylabel('Bit Error Rate'); 
legend('MC BER Estimate of QPSK', 'MC BER Estimate of QPSK+ISI', 'Theoretical BER of QPSK'); grid;

%% phase sync error 0~360°
clearvars;
PhaseError = 0:10:360; 				% Phase Error at Receiver
Eb = 24; No = -50;       	       	% Eb (dBm) and No (dBm/Hz)
ChannelAttenuation = 70; 			% dB
EbNo = 10.^((Eb-ChannelAttenuation-No)/10); 
BER_T = 0.5*erfc(sqrt(EbNo)*ones(size(PhaseError)));
N = round(100./BER_T); 
BER_MC = zeros(size(PhaseError)); 
for k=1:length(PhaseError)
  BER_MC(k) = MCQPSKrun(N(k),Eb,No,ChannelAttenuation,0,0, PhaseError(k),0,1,0);
  BER_MC1(k) = MCQPSKrun(N(k),Eb,No,ChannelAttenuation,0,0, PhaseError(k),0,0,0);
end
figure;semilogy(PhaseError,BER_MC,'o', PhaseError,BER_MC1,'x', PhaseError,2*BER_T,'-', PhaseError,BER_T)
xlabel('Phase Error (Degrees)'); 
ylabel('Bit Error Rate'); 
legend('MC BER Estimate of QDPSK', 'MC BER Estimate of QPSK', 'Theoretical BER of QDPSK', 'Theoretical BER of QPSK'); grid;