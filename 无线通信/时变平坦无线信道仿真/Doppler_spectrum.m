function y=Doppler_spectrum(fd,f)
    y = zeros(size(f));
    Interval = f>-fd&f<fd;
    y(Interval) = 1./sqrt(fd^2-f(Interval).^2);
end