function [y] = Spherical(x)
dim = 30;
tmp = 0;
for i=1:dim
    tmp = tmp + x(i)*x(i);
end
y = tmp;
