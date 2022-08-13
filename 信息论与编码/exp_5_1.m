clc; clearvars;
data='abcabcdab';
[code,dict,dict_init]=LZW(data);
disp('code:'); disp(code)
disp('dict_init'); disp([keys(dict_init)' values(dict_init)'])
disp('dict:'); disp([keys(dict)' values(dict)'])

function [code,dict,dict_init]=LZW(data)
    L=length(data);
    code=[];
    
    value=1;
    dict=containers.Map;
    for n=1:L
        P=data(n);
        if ~isKey(dict,P)
            dict(P)=value;
            value=value+1;
        end
    end
    dict_init=containers.Map(keys(dict),values(dict));
    
    P='';
    for n=1:L
        C=data(n);
        PC=[P,C];
        if isKey(dict,PC)
            P=PC;
        else
            dict(PC)=value;
            value=value+1;
            code=[code dict(P)];
            P=C;
        end
    end
    code=[code dict(P)];
end