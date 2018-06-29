%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719) - Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0

function x = iQuant( q,L )
%Dequantize q using Dequnatize levels array D
%q : 1 x n samples signal
%L : Dequantization levels array
%x :The  dequantized 1 x n samples signal
sz = size(q,1);

x = zeros(sz,1);

for i=1:sz
    x(i) = L(q(i));
end


end

