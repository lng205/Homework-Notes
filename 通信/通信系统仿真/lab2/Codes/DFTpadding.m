function [y,N] = DFTpadding(x,Nz)
    N = length(x);
    if mod(N,2) == 0
        x = [x(1:N/2+1) x(N/2+1) x(N/2+2:end)];
        N = N + 1;
    end
    y = [x(1:ceil(N/2)) zeros(1,Nz) x(ceil(N/2+1:end))];
    N = N + Nz;
end