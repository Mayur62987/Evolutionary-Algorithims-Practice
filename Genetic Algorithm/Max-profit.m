clc;
 clear;
 close all;
 disp('----------------------Assignemnt 3-------------------------Mayur Ramjee')
 %------------------------------Initialize---------------------------------
 Numpop = input('Enter size of population: ');
 
 Lim = input('Enter initial limit in KG: '); %initial weight limit to populate first generation
 Murate = input('Enter % mutuation rate: '); %varied percentage for mutation rate
 
 while (Murate > 100 || Murate < 0)
     Murate = input('Enter a mutation rate from 1 to 100 %: ');
 end
 TSize = input('Enter size of tornament from population: ');
 while TSize > Numpop
    TSize = input('Enter size smaller than population: ');%split the population
 end
 NoMut = 0;
 Mu = zeros(Numpop,1);
 Alloys = zeros(Numpop,5);
 TAlloy = zeros(Numpop,5);
 Mut = 0;
 iteration = 0;
 done = 0;
 plot = zeros(200,1);
 
 SState = 1; 
 %-----------------------------First Generation----------------------------
 
 for a = 1:Numpop
     for b = 1:4
         Alloys(a,b) = Lim*rand(1); %populate with random weights
     end
 end
 
 %-----------------------------Calculate fitness---------------------------
 [Alloys,Fitness] = calcfitness(Alloys,Numpop);
 %---------------------------------Sample crossover----------------------------------
tic
 while (iteration < 200)
      iteration = iteration+1;
 for d = 1:Numpop
     
     maxA = -inf;
     maxB = -inf;
     mPosA = -1;
     mPosB = -1;
     
     for u = 1:TSize
         RposA = ceil(Numpop*rand(1));
         if  maxA < Alloys(RposA,5)
             maxA = Alloys(RposA,5);
             mPosA = RposA;
         end
     end
     
     for f = 1:TSize
         RposB = ceil(Numpop*rand(1));
         if ((maxB < Alloys(RposB,5) && (mPosA ~= RposB)))
             maxB = Alloys(RposB,5);
             mPosB = RposB;
         end
     end
     
     
     select = ceil(4*rand(1)); %%selection of chromosomes
     switch(select)
         case(1)
             CrossO = [Alloys(mPosA,1) Alloys(mPosA,2) Alloys(mPosB,3) Alloys(mPosB,4)];
         case(2)
             CrossO = [Alloys(mPosB,1) Alloys(mPosB,2) Alloys(mPosA,3) Alloys(mPosA,4)];
         case(3)
             CrossO = [Alloys(mPosA,1) Alloys(mPosB,2) Alloys(mPosA,3) Alloys(mPosB,4)];
         case(4)
             CrossO = [Alloys(mPosB,1) Alloys(mPosA,2) Alloys(mPosA,3) Alloys(mPosB,4)];
     end
           
     Mu(d,1) = 100*rand(1);
     if Mu(d,1) <= Murate
         for t = 1:4
             CrossO(1,t) = CrossO(1,t) + random('unif',0,1);
         end
         NoMut = NoMut + 1;
     end
         
        [TAlloy,Fitness2] = calcfitness(CrossO,1);

         for u = 1:5
             TAlloy(d,u) = CrossO(1,u);
         end
 end
    
     Alloys = TAlloy;
     BestF = max(Alloys);
     Alloys(1,:) = BestF;
     fprintf('\nFitness = R%f',BestF(1,5));
     plot(iteration,1) = BestF(1,5);
     Fitness(iteration,1) = iteration;
     Fitness(iteration,2) = BestF(1,5);
     if iteration == 1
         SState = Fitness(iteration,2);
     else
         SState = (Fitness(iteration,2) - Fitness(iteration-1,2));
     end
     
 end
 
