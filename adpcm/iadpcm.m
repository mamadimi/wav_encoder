%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719) - Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0

function xd = iadpcm(rq,wq,Lr,wmin,wmax,n)
%inverse adaptive DPCM implementation
%rq : quantized differences samples
%wq : quantized prediction coeeficients vector
%Lr : Dequantization levels array
%wmin : the minimum of a  w prediction coeeficients vector
%wmax : the maximum of a  w prediction coeeficients vector
%m : length of predictor
%n : number of bits
 %xd : n x 1 samples signal;
 
addpath ../task2
addpath ../task3

[Dpred,Lpred] = quantLevels(n,wmin,wmax);

xd = [];
xd = [ xd iQuant(rq(1),Lr) ];

m = length(wq);

% For the first m samples use only the previous sample
for i = 2:m
    
     temp_x = zeros(m,1);
     for j=1:i-1
        temp_x(j) = xd(i-j);
    end
    
    temp = iQuant(rq(i),Lr) + ( iQuant(wq,Lpred)' ) * temp_x;
    
    xd  = [xd temp];
    %{
    temp = iQuant(rq(i),Lr) + xd(i-1);
    xd = [xd temp];
    %}
end

%For the rest samples use the predictor
for i=m+1:length(rq)
    
    temp_x = [];
     for j=1:m
        temp_x = [temp_x ; xd(i-j)];
    end
    
    temp = iQuant(rq(i),Lr) + ( iQuant(wq,Lpred)' ) * temp_x;
    
    xd  = [xd temp];
end

end

