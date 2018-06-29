%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719) - Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0

function [D,L] = quantLevels( n,xmin,xmax )
% Uniform quantizer implementation
%n : number of bits
%xmin : the minimum of a signal x
%xmax : the maximum of a signal x
%D : Decision levels array
%L : Dequantization levels array

levels = 2^n;

D = zeros(levels-1,1);

step = (xmax - xmin)/(levels);

for i=1:levels-1
    D(i) = xmin + (i)*step;
end

L = zeros(length(D)+1,1);

L(1) = xmin/2 + D(1)/2;
L(length(D)+1) = D(length(D))/2 + xmax/2;

for i=2:length(D)
    L(i) = D(i)/2 + D(i-1)/2;
end


end

