function data=iRandInterleave(code,order,N)
    code=reshape(code,length(order),[]);
    [~,order]=sort(order);
    data=reshape(code(order,:),1,[]);
    data=data(1:N);
end