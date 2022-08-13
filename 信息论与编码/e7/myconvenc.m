function C=myconvenc(M,g)
    [rows,columns]=size(g);
    C=zeros(rows,columns+length(M)-1);
    for i=1:rows
        C(i,:)=conv(M,g(i,:));
    end
    C=mod(reshape(C,1,[]),2);
    C=C(1:end-rows*(columns-1));
end