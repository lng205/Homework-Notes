clc;clearvars;close all;
SourseDist=[.21 .10 .30 .09 .25 .05];
H=-(log2(SourseDist))*SourseDist';
[Code,L_average] = huffmandict(1:length(SourseDist),SourseDist);
eff=(H/L_average);
disp('huffman')
disp(Code(:,2)')
disp(['Average length = ',num2str(L_average),'bits/symbol'])
disp(['Efficiency=',num2str(eff*100),'%'])