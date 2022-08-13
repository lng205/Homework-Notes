C=1:12;
code=GroupInterleave(C,4,3)
Cdecode=iGroupInterleave(code,4,3)

function code=GroupInterleave(data,m,n)
    nz=mod(m*n-mod(length(data),m*n),m*n);
    data=[reshape(data,1,[]) zeros(1,nz)];
    code=reshape(permute(reshape(data,n,m,[]),[2 1 3]),1,[]);
end

function data=iGroupInterleave(code,m,n)
    data=reshape(permute(reshape(code,m,n,[]),[2 1 3]),1,[]);
end

function ConvInterleave(code,m,n)
    
end