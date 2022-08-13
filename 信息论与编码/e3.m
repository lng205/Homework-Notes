clc;clearvars;close all;
SourseDist=[.2 .1 .3 .15 .25];
H=-(log2(SourseDist))*SourseDist';
Code = shannondict(SourseDist);
Len = cellfun('length',Code);
L_average=SourseDist*Len;
eff=(H/L_average);
disp('shannon')
disp(Code')
disp(['Average length = ',num2str(L_average),'bits/symbol'])
disp(['Efficiency=',num2str(eff*100),'%']);disp(' ')

function Code = shannondict(SourseDist)
    [SourseDist,Order]=sort(SourseDist,'descend');  %the probabilities are sorted in descending order
    Info=-(log2(SourseDist)); %Information
    Len=ceil(Info);
    CumulativeDist=cumsum([0 SourseDist(1:end-1)]);
    Code=cell(1,length(SourseDist));%init
    for i = 1:length(SourseDist)
        Code{i}=dec2bin(CumulativeDist(i)*2^Len(i));
        while(length(Code{i})<Len(i))
            Code{i}=['0' Code{i}];
        end
    end
    [~,Index]=sort(Order,'ascend');
    Code=Code(Index)';
end