function[output] = findcor(numr,out,true)
%function to find the % of correct classes
count = 0;
for rr = 1 : numr
    [y,r] = max(out(rr,:)); 
    
    if(r == true(rr,1))
        count = count +1;
    end
end
output = ((count/numr)*100);
