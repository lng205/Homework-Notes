function MR = hammming_decode_7_4(R)
    R=reshape(R,7,[])';
    n=7; k=4;
    P=[ 1 0 1;
        0 1 1;
        1 1 1;
        1 1 0];
    H=[P' eye(n-k)];
    [~,order]=sort(binaryVectorToDecimal(H'));
    
    S=rem(R*H',2);
    
    S=binaryVectorToDecimal(S);
    p=find(S>0);
    S(p)=order(S(p));
    
    for i=1:length(S)
        if(S(i))
            R(i,S(i))=~R(i,S(i));
        end
    end
    MR=reshape(R(:,1:k)',1,[]);
end