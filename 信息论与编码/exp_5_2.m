clc; clearvars;
data='abcdabcdab';
[code,dict]=LZW(data);
disp('code:'); disp(code)
disp('dict:'); disp([keys(dict)' values(dict)'])

function [code,dict]=LZW(data)
    L=length(data);
    code=[];
    value=1;
    dict=containers.Map;
    
    P='';
    n=1;
    while n<=L
        C=data(n);
        PC=[P,C];
        if isKey(dict,PC)
            P=PC;
            n=n+1;
        else
            dict(PC)=value;
            value=value+1;
            if P
                code=[code dict(P)];
            end
            P='';
        end
    end
    code=[code dict(P)];
end