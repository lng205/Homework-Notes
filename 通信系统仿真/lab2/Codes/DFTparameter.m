function [t,f,N,Td] = DFTparameter(TdExpect,fs)
    N = ceil(TdExpect*fs);
    Td = N/fs;
    t = (0:N-1)/fs;
    f = ((0:N-1)-floor(N/2))*fs/N;
end