clearvars;
close all;
snrdB_min = 0; snrdB_max = 10;			% SNR (in dB)limits(supposed to be EbN0)
snrdB = snrdB_min:1:snrdB_max;
Nsymbols = input('Enter number of symbols > ');
snr = 10.^(snrdB/10);					% convert from dB
h = waitbar(0,'SNR Iteration');
len_snr = length(snrdB);
x_d0=[1 1.414 1 1.414*cos(pi/6)];
x_q0=[0 0 0 0];
x_d1=[-1 0 0 0];
x_q1=[0 0 1 1.414*sin(pi/6)];
len_i = 4;%number of modulation methods
for i = 1:4
        for j=1:len_snr						    % increment SNR
           waitbar((len_snr*(i-1)+j)/(len_i*len_snr))
           sigma = sqrt(1/(2*snr(j)));                          % noise standard deviation(Eb = 1, optimum reception)
           error_count = 0;
           for k=1:Nsymbols					    % simulation loop begins
              d = round(rand(1));                                    % data
              if d ==0
                 x_d = x_d0(i);						% direct transmitter output	
                 x_q = x_q0(i);						% quadrature transmitter output	
              else
                 x_d = x_d1(i);						% direct transmitter output
                 x_q = x_q1(i);						% quadrature transmitter output
              end   
              n_d = sigma*randn(1);		        % direct noise component
              n_q = sigma*randn(1);		        % quadrature noise component
              y_d = x_d + n_d;				    % direct receiver input
              y_q = x_q + n_q;				    % quadrature receiver input
              if (y_d-x_d0(i))^2+(y_q-x_q0(i))^2 < (y_d-x_d1(i))^2+(y_q-x_q1(i))^2      %perpendicular bisector	
                 d_est = 0;					    % conditional data estimate
              else
                 d_est = 1;					    % conditional data estimate
              end
              if (d_est ~= d)				
                 error_count = error_count + 1;	% error counter
              end
           end									% simulation loop ends
           errors(j) = error_count;		        % store error count for plot
        end
        ber_sim = errors/Nsymbols;                              % BER estimate
        d = (x_d0(i)-x_d1(i))^2+(x_q0(i)-x_q1(i))^2;             %distance in constellation
        ber_theor = qfunc(sqrt(d/2.*snr));	% theoretical BER=q(d/2/sigma)
        semilogy(snrdB,ber_theor,snrdB,ber_sim,'o')
        hold on;
end
close(h)
xlabel('SNR in dB');
ylabel('BER');
legend('BPSK Theoretical', 'BPSK Simulation', 'OOK Theoretical', 'OOK Simulation', 'BFSK Theoretical', ...
'BFSK Simulation', '(cos(pi/6),0,(0,sin(pi/6))) Theoretical', '(cos(pi/6),0,(0,sin(pi/6))) Simulation');