function code=GroupInterleave(data,m,n)
    data=reshape(data,1,[]);
    data=[data zeros(1,mod(m*n-mod(length(data),m*n),m*n))];%zeros filling
    code=reshape(permute(reshape(data,n,m,[]),[2 1 3]),1,[]);
end