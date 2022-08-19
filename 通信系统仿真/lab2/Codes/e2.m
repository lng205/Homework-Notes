clearvars; close all;
k = 50;	nsamp = 50000; snrdb = zeros(1,17); x = 4:20;
f={@(x)(sin(pi*x/k)./(pi*x/k)).^2; @(x)(sin(pi*x/2/k)./(pi*x/2/k)).^4;...
@(x)((cos(2*pi*x/k)./(1-(4*x/k).^2)).^2); @(x)(sin(pi*x/k)./(pi*x/k)).^2};
Marker = ['o','k','b','r']; hold on;
for i = 1:length(f)
    for m = 4:20
        f_fold = k*m/2;		        % folding frequency
        signal = sum(f{i}(1:f_fold));
        noise = sum(f{i}(f_fold+1:nsamp));
        snrdb(m-3) = 10*log10(signal/noise); 
    end
    plot(x,snrdb,Marker(i))			        % plot results
end
legend('Rect','Tri','MSK','QPSK'); grid on;
xlabel('Samples per symbol'); ylabel('Signal-to-aliasing noise ratio')