%This function calculates the net value as well as the output of the
%activation function(sigmoid)
function[output] = sigmoidfunc(inputs,weights)
net = 0;
for j = 1:size(weights,2)
    net = net + inputs(j)*weights(j);
% net = dot(inputs(j),weights(j));
 end
% net = dot(inputs,weights);
lambda = 1;
output = 1/(1+exp(-net*lambda));
