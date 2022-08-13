function C = hamming_code_7_4(M)
%HAMMING_CODE_7_4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    n=7; k=4;
    P=[ 1 0 1;
        0 1 1;
        1 1 1;
        1 1 0];
    G=[eye(k) P];
    M=reshape(M,1,[]);
    M=[M zeros(1,rem(length(M),4))];
    M=reshape(M,4,[])';
    C=rem(M*G,2);
    C=reshape(C',1,[]);
end