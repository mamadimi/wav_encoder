%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia

%Authors: Mamagiannos Dimitios(7719)- Bakas Stylianos (7726)
%Date: February 2016
%version: 1.0

function [n,new_fs] = getParams(x,fs)
%Initialize the size of window

%Calculate the undersampling frequency anad the size of windows.
%Undersample the signal and the MSE of the recoved signal is calculated.
%Rerun until the MSE is lower than a specific value.
%The number of windows is chosen experimentally.

for factor=3:16
    
    new_fs = 1*fs/factor;
    
    [p,q] = rat(new_fs/fs);
    y = resample(x,p,q);
    [p,q] = rat(fs/new_fs);
    z = resample(y,p,q);
    
    mse = mean((x-z(1:length(x))).^2);
    
    if mse>0.0002
        break;
    end
    
end
if factor ~=1
factor = factor - 1;
end

new_fs = fs/factor;


if factor==2
    n=20000;
elseif factor==3
    n=18000;
elseif factor==4
    n=16000;
elseif factor==5
    n=15000;
elseif factor==6
    n=10000;
else
    n=5500;
end

end

