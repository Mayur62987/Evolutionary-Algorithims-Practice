function[output1,output2] = calcfitness(Alloys,Num)
 
for z = 1:Num
    SP = Alloys(z,1)*3000 + Alloys(z,2)*3100 + Alloys(z,3)*5200 + Alloys(z,4)*2500 ; 
    iron = 0.7*Alloys(z,1) + 0.2*Alloys(z,2) + 0.1*Alloys(z,3) + 0.5*Alloys(z,4);
    plat = 0.2*Alloys(z,1) + 0.3*Alloys(z,2) + 0.8*Alloys(z,3) + 0.1*Alloys(z,4);
    cop = 0.1*Alloys(z,1) + 0.5*Alloys(z,2) + 0.1*Alloys(z,3) + 0.4*Alloys(z,4);
    
    if cop > 8
        cop = cop*0.9;
    end
    
    Tplat = floor(plat);
    if Tplat >=1
        iron = iron - 1*Tplat;
    end
    
    if iron < 0 
        iron = 0;
    end
    
    
    MC = plat*(plat*10 + 1200) + (iron*300) + (cop*800);
    EC = exp(0.005*(25*Alloys(z,1) + 23*Alloys(z,2) + 35*Alloys(z,3) + 20*Alloys(z,4)));
    TC = MC + EC;
    
    Fit = SP - TC;
    Alloys(z,5) = Fit;
end
Fit(1,1) = 0;
Omax  = max(Alloys);
Fit(1,2) = Omax(1,5);
output1 = Alloys;
output2 = Fit;
end
 
 

