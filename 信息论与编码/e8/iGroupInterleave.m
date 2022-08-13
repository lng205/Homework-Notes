function data=iGroupInterleave(code,m,n,N)
    data=reshape(permute(reshape(code,m,n,[]),[2 1 3]),1,[]);
    data=data(1:N);
end