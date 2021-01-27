function [y] = Griewank(x)
dim = 30;
sumsq = 0;
prod = 1;
for i=1:dim
    sumsq  = sumsq + x(i)*x(i);
    prod = prod*(cos(x(i)/sqrt(i)));
end
y = 1 + sumsq * 1/4000 - prod;
