function out_values = myfiltfunc(in_columns)

[m,n] = size(in_columns); 
out_values = zeros(1,n); 

for i = 1:n
    
    sorted = sort(in_columns(:,i));
    out_values(i) = sorted(end-1)*median(sorted);

end
end