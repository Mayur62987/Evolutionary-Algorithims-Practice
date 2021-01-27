clc;
clear;
% close all;
% 
disp('----------------------------------------------------------------------------------------------------')
disp('ASSIGNMENT 4: OPTIMIZATION INVESTIGATION: PARTICLE SWARM OPTIMIZATION ALGORITHM');
disp('----------------------------------------------------------------------------------------------------')

% INPUT
% -----------------------------------------------------------------------------
a = input('Please enter function to be investigated: 1.Ackley, 2.Griewank, 3.Spherical : ');
weighty = input('Please enter the required inertia weight: ');
generations= input('please enter the required generation investigated: ');
Population = input('Please enter the population size: ');

Vi = zeros(Population,30); % old/initial velocity
Vf = zeros(Population,30);%new/final velocity
pBest = random('unif',-0.25,0.25,Population,30);
particles = random('unif',-0.25,0.25,Population,30);
Xf = zeros(Population,30);
val = zeros(Population,1);
low=zeros(Population,1);
fittest = zeros(generations,1);
c1min = 0.1;
c2min = 0.1;
c1max = 2.5;
c2max = 2.5;

for fr=1:1
        switch a
            case 1
        f=@(x) Ackley(x);
            case 2
        f= @(x) Griewank(x);
            case 3
        f=@(x) Spherical(x);
        end
%-----------------------------------------------------------------------------
%                        PARTICLE SWARM OPTIMIZATION ALGORITHM
%-----------------------------------------------------------------------------
                for y=1:generations
                    
                    c1 = (c1min-c1max)*(y/generations) + c1max;
                    c2 = (c2min-c2max)*(y/generations) + c2max;
                    
                    
                    for k = 1:Population%populate function
                    val(k,1) = f(particles(k,:));%fitness
                    end
                    %select best individual for trial vector
                    [Slay, pos] = sort(val);
                    Winner = particles(pos(1),:); 

                        for s = 1:Population 
                            if f(particles(s,:)) > f(pBest(s,:)) %compare local to personal best
                            pBest(s,:) = pBest(s,:); %personal stays personal
                            elseif f(particles(s,:)) < f(pBest(s,:))
                            pBest(s,:) = particles(s,:);%new personal best
                            end
                            if f(particles(s,:)) < f(Winner); % compare personal best to global best
                            Winner = particles(s,:);
                            end

                            R1 = random('unif',0,1);
                            R2 = random('unif',0,1);
                            Vf(s,:) = weighty*Vi(s,:) + c1*R1*(pBest(s,:)-particles(s,:)) + c2*R2*(Winner-particles(s,:));
                            Xf(s,:) = particles(s,:) + Vf(s,:);
                            particles(s,:) = Xf(s,:);
                            Vi(s,:) = Vf(s,:);    
                        end
                    low(y,1)=min(val);
                end   
               
end
            xlabel('Generations');
            hold on;
            ylabel('fitness minimum');
            hold on;
            title('Variation of fitness minimum');
            hold on;
            plot(low);
            hold on

