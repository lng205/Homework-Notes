function data=iConvInterleave(code,B,M,N)
    code=reshape(code,B,[]);
    columns=ceil(N/B);
    data=zeros(B,columns);
    for i=1:B
       data(i,:)=code(i,M*(i-1)+1:M*(i-1)+columns);
    end
    data=reshape(data,1,[]);
    data=data(1:N);
end