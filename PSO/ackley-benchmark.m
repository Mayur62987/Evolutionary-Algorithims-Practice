function [y] = Ackley(x)
dim = 30;
sumsq = 0;
sumcos = 0;
for i=1:dim
    sumsq = sumsq + x(i)*x(i);
    sumcos = sumcos + cos(2*pi*x(i));
end
y = -20*exp(-0.2*sqrt(sumsq/dim)) - exp(sumcos/dim) + 20 + exp(1);
