%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719)
%Date: February 2016
%version: 1.0

function w = lpcoeffs( x,m )
%Calculation of the weight vector w by minimizing the Jw factor
%x : n x 1 samples signal
%m : size of filter
%w : filter's coefficients

r = zeros(m+1,1);

for i=0:m 
    x_temp = [zeros(i,1); x(1:size(x,1)-i)];
    r(i+1) = mean(x.*x_temp);     
end

R = toeplitz(r(1:m));

r = r(2:m+1);

w= R\r;


end

