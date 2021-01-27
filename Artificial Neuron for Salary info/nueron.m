%code for neuron training,Mayur Ramjee 
clear;
clc;
filename = 'SalData.csv'; %CSV file read
Input = dlmread(filename,',',[1 1 2000 7] ); %enter in values from the second row
Input(:,end+1) = 1; %add in bais for each
Income = dlmread(filename,',',[1 0 2000 0 ]); %actual value of income
rng('shuffle'); %time based random number such that order is changed
initialw = rand(1,8);%random weights
fprintf('\n initial weights');
disp(initialw);
eta = 1E-7; %n learning rate
error = 0; %initialise the error
Serror = 0; %initialise square error
SSerror = 0; %initialise sum square error
percenterror = 0; %initialise percent error
sumoferror = 0; %initialise the sum of error
aveerror = 1; %initalise the iteration error
m = 0; %initialise the counter
%training the neuron
while(aveerror > 0.03) %while the average % error per set is greater than 3%
m = m+1; %increment counter
for p = 1:1500 %for each of the values in the training set
yp(p,1) = dot(Input(p,:),initialw(1,:)); %fnet
tp(p,1) = Income(p,1); %true value of training set
xp = Input(p,:); %actual inputs
error(p,1) = tp(p,1) - yp(p,1) ; %error
percenterror(p,1) = abs(error(p,1)/tp(p,1)); %percent error
for q = 1:8 %for each input
initialw(1,q) = initialw(1,q)+2*eta*error(p,1)*xp(q);%update weights
end
Serror(p,1) = error(p,1) ^ 2 ; %square error
end
SSerror(m,1) = sum(Serror);%SSE
sumofpercenterror(m,1) = sum(percenterror);% get %error
aveerror(m,1) = sumofpercenterror(m,1)/1500; %calc ave %error for stopping condition
end
fprintf('\n weights learnt');
disp(initialw); %weights
fprintf('\n number of iterations');
disp(m) %number of iterations
aveerror(m,1) %ave error achieved
