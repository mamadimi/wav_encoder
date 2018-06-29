%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719) - Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0
function q = Quant( x,D )
%Quantize signal x usingDecision levels array D
%x : 1 x n samples signal
%D : Decision levels array
%q : quantized damples

if (size(D,2)>1)
    D=D';
end

q = zeros(length(x),1);

levels = size(D,1);

%Find the quantized samples based on project's description
for i=1:length(x)
    if x(i)<= D(1) 
        q(i) = 1;
    end
    
    if x(i) > D(levels)
        q(i) = levels + 1;
    end
    
    for j=2:levels 
        if x(i) > D(j-1) && x(i)<=D(j)
            q(i) = j;
            break;
        end
    end
end


end

