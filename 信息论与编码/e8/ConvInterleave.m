function code=ConvInterleave(data,B,M)
    data=reshape(data,1,[]);
    data=[data zeros(1,mod(B-mod(length(data),B),B))];%zeros filling
    data=reshape(data,B,[]);
    [~,columns]=size(data);
    code=zeros(B,(B-1)*M+columns);
    for i=1:B
       code(i,:)=[zeros(1,M*(i-1)) data(i,:) zeros(1,M*(B-i))];
    end
    code=reshape(code,1,[]);
end