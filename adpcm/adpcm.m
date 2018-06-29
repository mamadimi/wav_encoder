%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719) - Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0

function [ rq,wq ] = adpcm( x,D,L,m,wmin,wmax,n )
%Adaptive DPCM implementation
%x : n x 1 samples signa;
%D : Decision levels array
%L : Dequantization levels array
%m : length of predictor
%wmin : the minimum of a  w prediction coeeficients vector
%wmax : the maximum of a  w prediction coeeficients vector
%n : number of bits
 %rq : quantized differences samples
 %wq : quantized prediction coeeficients vector
 %rq_min : minimum of signal differences
 %rq_max : maximum of signal differences

addpath ../task2
addpath ../task3

%Calculate D,L of w prediction coeeficients

[Dpred,Lpred] = quantLevels(n,wmin,wmax);

w = lpcoeffs(x',m);

%According to theory the encoder qunatize and dequantize the w coeffs in
%order to avoid an error accumulation
wq = Quant(w,Dpred);
wiq = iQuant(wq,Lpred);

rq = [];

rq = [rq ; x(1)];

% For the first m samples use only the previous sample
for i=2:m
    
        temp_x = zeros(1,m);
    
    for j=1:m
        pos = i-j;
        if i-j <=0
            temp_x(j) =0;
        else
            temp_x(j) = x(pos);
        end
    end
    
    temp_x_q = Quant(temp_x,D);
    temp_x_iq = iQuant(temp_x_q,L);
    
    prediction = (wiq')*temp_x_iq;
    
    rq = [rq ; x(i)-prediction];
    
   %{ 
    temp = x(i-1);
    temp = Quant(temp,D);
    temp = iQuant(temp,L);

    rq = [rq ; x(i)-temp];
    %}
end

%Calculate the rest diferrences.
for i=m+1:length(x)
    
    temp_x =[];
    
    for j=1:m
        temp_x = [temp_x ; x(i-j)];
    end
    
    temp_x_q = Quant(temp_x,D);
    temp_x_iq = iQuant(temp_x_q,L);
    
    prediction = (wiq')*temp_x_iq;
    
    rq = [rq ; x(i)-prediction];
    
end

%Find the minimum & maximum of the differences array rq.
%rq_min = min(rq);
%rq_max = max(rq);
%Find the D,L for float rq array 
%[D,L] = quantLevels(log2(length(D)+1),rq_min,rq_max);

%Convert float rq difderences to quantized rq array.
rq = Quant(rq,D);

end

