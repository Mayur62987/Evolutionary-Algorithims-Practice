%Code for assignment 2 Mayur Ramjee 210050039
 clear;
 clc;
 close all;
 %1500 for learning and 400 for validataion
 disp('----------------------Assignemnt 2-------------------------Mayur Ramjee')
 wait = waitbar(0,'Loading Data');
 %---------------------Import data from CSV file--------------------------
 filename1 = 'Plates.csv'; %filename
 Target = dlmread(filename1,',',[0 27 1499 27]); %output code for plates (learn)
 ValidT = dlmread(filename1,',',[1500 27 1899 27]); %validation Target
 Input = dlmread(filename1,',',[0 0 1499 26]); %input characteristics (learn)
 Input(:,end+1) = -1; %store the final column for bais inputs
 ValidI = dlmread(filename1,',',[1500 0 1899 26]); %validation input
 ValidI(:,end+1) = -1;
 
 
 
     
             
 
  %---------------------User Input-----------------------------------------
  
    iterations = input('enter number of iterations for programe: ');
    J = input('enter number of hidden layer neurons :  '); %J
%   ETrain = input('Exclusive training sets to be used y/n: ','s'); %used uniqiue training sets only?
    scle = input('Scaled input values to be used y/n: ','s');
    dyn = input('Dynamic learning rate to be used y/n: ','s'); %dynn
    noise = input('Noise injection to be used y/n: ','s'); %noise inj
    dyw = input('Should weight initialisation be used y/n: ','s'); %dynw
    momen = input('Should momentum be used y/n: ','s'); %mom
  
 %--------------------scale inputs-----------------------------------------
      if(scle == 'y' || scle == 'Y')
             Imax = max(Input);
            Imin = min(Input);
 
        for x = 1:1500
            for i = 1:27
                Input(x,i) = ((Input(x,i)-Imin(1,i))/((Imax(i)-Imin(i))))*(1.73205 - (-1.73205))+ (-1.73205);
                 if(noise == 'y' || noise == 'Y')
                     Input(x,i)  = Inputs(x,i) + (-0.5 + (0.5+0.5)*rand(1));
                 end
            end
        end
      end
          
          
  %---------------------Exclusive Training-----------------------------------
%   if (ETrain == 'y' || ETrain == 'Y')
%       Temp = dlmread(filename1,',');
%       Temp = Etrain(Temp);
%       for rr = 1 : size(Temp,2)-1
%           
%           for cc = 1 : size(Temp,1)
%               Input(rr,cc) = Temp(rr,cc);
%           end
%       end
%       
%   
%   
%       
%   end
%   disp('');
%   disp('');
%   
  %---------------------Dynamic Learning-----------------------------------
  if(dyn == 'y' || dyn == 'Y')
      disp('User has opted for Dynamic Learing to be used ');
      max = input('Input max learning rate: ');
      min = input('Input min learning rate: ');
      gam = -iterations/log(min/max);
      eta = max;
      
  else
      n = input('Enter Learning rate: ');
      
  end
  
  disp('');
  disp('');
  %---------------------Weight initialisation------------------------------
  
  if(dyw == 'y' || dyw == 'Y')
     disp('User has opted for weight initialisation to be used ');
     wV = (1/sqrt(27) + 1/sqrt(27)).*rand(J,28) - 1/sqrt(27);
     wW = (1/sqrt(J) + 1/sqrt(J)).* rand(7,J+1) - 1/sqrt(J); 
     
  else
      disp('User has opted for Random weights to be used ');
      wV = rand(J,28);
      wW = rand(7,J+1);
  end
  disp('');
  disp('');
  
    
  %---------------------Momentum-------------------------------------------
  if(momen == 'y' || momen == 'Y')
     disp('User has opted for momentum to be used ');
     alpha = input('enter alpha value: ');
  end
  
  disp('');
  disp('');
   %----------------------------classify output binary------------------------------
 
 FaultclassT = zeros(1500,7);
 FaultclassV = zeros(400,7);
 
 for ii = 1:1500
     switch(Target(ii,1))
     case (1)
         FaultclassT(ii,1) = 1 ;
     case (2)
         FaultclassT(ii,2) = 1 ;
     case (3)
         FaultclassT(ii,3) = 1 ;
     case (4)
         FaultclassT(ii,4) = 1 ;
     case (5)
         FaultclassT(ii,5) = 1 ;
     case (6)
         FaultclassT(ii,6) = 1 ;
     case (7)
         FaultclassT(ii,7) = 1 ;
     end
 end
     
  for ii = 1:400
     switch(ValidT(ii,1))
     case (1)
         FaultclassV(ii,1) = 1 ;
     case (2)
         FaultclassV(ii,2) = 1 ;
     case (3)
         FaultclassV(ii,3) = 1 ;
     case (4)
         FaultclassV(ii,4) = 1 ;
     case (5)
         FaultclassV(ii,5) = 1 ;
     case (6)
         FaultclassV(ii,6) = 1 ;
     case (7)
         FaultclassV(ii,7) = 1 ;
     end
 end
  
  %------------------Variable intialisation--------------------------------
      
  pdV = zeros(J,28); %partialdv
  
  pdW = zeros(7,J+1); %partialdw
  pdWCur = 0;
  
  Hidout = zeros(J+1,1); %hiddenout N+1 rows by 1 column
 
  out = zeros(1500,7); %output for each of the test set
  vout = zeros(400,7); %validation output for each of the set
  e = zeros(1500,7); %% check this for 
  erow = zeros(1500,1);
  SSE = zeros(iterations,1);
  verror = zeros(iterations,1);
  
  tic %timnig function
  
  %---------------------itteration loop------------------------------------
  trainingsize = size(Input,1);
  for a = 1:iterations
      
      if ((dyn == 'y' || dyn == 'Y') && iterations > 1)
          n = eta*exp(-a/gam);
      end
      
      for b = 1 : trainingsize
          
          for c = 1 : J
             Hidout(c,1) = sigmoidfunc(Input(b,:),wV(c,:));
          end
          Hidout(J+1,1) = -1; %hiddenout last row by convention hidden bias
          for d = 1:7
              out(b,d) = sigmoidfunc(Hidout,wW(d,:));
%               e(a) = e(a) +(FaultclassT(b,d) - out(b,d))^2;
              e(b,d) = (FaultclassT(b,d) - out(b,d))^2;
                   
         
          end
          
          erow(b,1) = sum(e(b,:));
%       endn
 
%           
%           SSE(a,1) = sum(erow);
%           SSE(a,1) = 0.5*SSE(a,1);
          
%        for f = 1:400
%             vout(f,1) = NNout(ValidI(f,:),wV,wW,J);
%        
%            verror(a) = verror(a) + (ValidT(f,1) - vout(f,1))^2;   
%        end  
%        verror(a) = verror(a)*0.5;
       
  %-------------------output layer------------------------------------
 
   for r  = 1:7    
       for s = 1:J+1
          tk1 = FaultclassT(b,r);
          ok1 = out(b,r);
          yj1 = Hidout(s);
          pdWCur = -(tk1 - ok1)*ok1*(1-ok1)*yj1; % find partial derv of the output weight using chain rule
          
   %---------------momentum used ----------------------------------
   
   if momen =='y' || momen == 'Y'
       pdWCur= pdWCur + alpha*pdW(r,s);
       pdW(r,s) = pdWCur;
   end
   
   wW(r,s) = wW(r,s) - n*pdWCur;
      end
   end
   
  %------------------update hidden layer---------------------
  %-------------------------------------------------------------------------------------------------------------
             
                 for t = 1 : J
                     for u = 1 :28
                         pdVCur = 0;
                         for z = 1 : 7
                             pdVCur = pdVCur + (-(FaultclassT(b,z) - out(b,z))*out(b,z)*(1-out(b,z))*wW(z,t)*(Hidout(t,1)*(1-Hidout(t,1))*(Input(b,u))));
                             
                               if momen =='y' || momen == 'Y'
                                 pdVCur = pdVCur +  alpha*pdV(t,u);
                                 pdV (t,u) = pdVCur;
                               end
                         end
                         wV(t,u) = wV(t,u) - n*pdVCur;
                     end
                 end
                             
%                    for t = 1:7
%                         for u = 1: J
%                             for z = 1:28
%                               tk2 = FaultclassT(b,t);%correct
%                               ok2 = out(b,t);%correct
%                               wk = wW(t,u);
%                               yj2 = Hidout(u);
%                               zi = Input(b,z);
%                               pdVCur = -(tk2-ok2)*ok2*(1-ok2)*wk*yj2*(1-yj2)*zi;
%                   %---------------momentum used ----------------------------------
% 
%                              if momen =='y' || momen == 'Y'
%                               pdVCur = pdVCur +  alpha*pdV(u,z);
%                               pdV (u,z) = pdVCur;
%                              end
%                          
%                         wV(u,z) = wV(u,z) - n*pdVCur;
%                              end
%                         end
%                    
%                 end
 
 
 
 
      end
          SSE(a,1) = sum(erow);
          SSE(a,1) = 0.5*SSE(a,1);
          a
  end
          
      plot(1:iterations,SSE);
      title('(Training)Iterations vs SSE');
      xlabel('Iterations');
      ylabel('SSE');
      
    waitbar(1,wait,'Training Complete');
    
 %-------------Check Number Correct---------------------------------------
    Tpercorrect = findcor(1500,out,Target);
  toc
 
  
 
%--------------validation--------------------------------------------------
 
 
  Vmax = max(ValidI);
  Vmin  = min(ValidI);
  VHidout = zeros(400,J+1);
  Vout = zeros(400,7);
  ve = zeros(400,7);
  verow = zeros(400,1);
  Vsse = 0 ;
  
  for x = 1:400
      for ff  = 1 : 27
          ValidI(x,ff) = ((ValidI(x,ff)-Vmin(1,ff))/((Vmax(ff)-Vmin(ff))))*(1.73205 - (-1.73205))+ (-1.73205);
      end
  end
  
 for bb = 1:400
      
   for cc = 1 : J
             VHidout(cc,1) = sigmoidfunc(ValidI(bb,:),wV(cc,:));
   end
             VHidout(J+1,1) = -1;   
             
   for dd = 1:7
       Vout(bb,dd) = sigmoidfunc(VHidout,wW(dd,:));
       ve(bb,dd) = (FaultclassV(bb,dd) - Vout(bb,dd))^2;
   end
       verow(bb,1) = sum(ve(bb,:));
       Vsse = sum(verow);
 end
   
 %-------------Check Number Correct---------------------------------------
 Vpercorrect = findcor(400,Vout,ValidT);
 
 %-----------------------Testing-------------------------------------------
  TestInput = dlmread(filename1,',',[ 1900 0 1939 26]); 
  TestInput(:,end+1) = -1;
  Tmax = max(TestInput);
  Tmin  = min(TestInput);
  THidout = zeros(40,J+1);
  Tout = zeros(40,7);
 
   for xx = 1:40
      for fff  = 1 : 27
          TestInput(xx,fff) = ((TestInput(xx,fff)-Tmin(1,fff))/((Tmax(fff)-Tmin(fff))))*(1.73205 - (-1.73205))+ (-1.73205);
      end
   end
   
   
   for bbb = 1:40
      
   for ccc = 1 : J
             THidout(ccc,1) = sigmoidfunc(TestInput(bbb,:),wV(ccc,:));
   end
             THidout(J+1,1) = -1;   
             
   for ddd = 1:7
       Tout(bbb,ddd) = sigmoidfunc(THidout,wW(ddd,:));
   end
   end
  
