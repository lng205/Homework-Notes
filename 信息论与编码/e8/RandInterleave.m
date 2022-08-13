function [code,order]=RandInterleave(data,N)
    data=reshape(data,1,[]);
    data=[data zeros(1,mod(N-mod(length(data),N),N))];%zeros filling
    data=reshape(data,N,[]);
    order=randperm(N);
    code=reshape(data(order,:),1,[]);
end