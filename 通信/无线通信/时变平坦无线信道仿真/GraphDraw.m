function GraphDraw(t,a,f,fDoppler)
    figure;tiledlayout(4,1);
    
    nexttile;plot(t,20*log10(abs(a)));xlim([0,15e-3]);grid on;
    xlabel('t/s');ylabel('gain/dB');title('Channel Gain');
    
    [N,edges]=histcounts(abs(a),'Normalization', 'pdf');
    nexttile;histogram('BinEdges',edges,'BinCounts',N);
    xlabel('Amplitude');ylabel('pdf');title('Channel Gain Distribution');
    
    [N,edges]=histcounts(angle(a),'Normalization', 'pdf');
    nexttile;histogram('BinEdges',edges,'BinCounts',N)
    xlabel('Phase');ylabel('pdf');title('Channel Phase Distribution');
    
    nexttile;plot(f,20*log10(abs(fDoppler)));xlim([-2e3,2e3]);grid on;
    xlabel('frequency/Hz');ylabel('gain/dB');title('Doppler Spectrum')
end