%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719)-Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0

function y = changefs( x,fs1,fs2 )
%Undersample or oversample a signal x
%x : a nx1 samples signal
%fs1 : signal's frequency
%fs2 : the desired frequency
%y : the undersampled or oversampled signal

%The fisrt sample is the same. 

[p,q] = rat(fs2/fs1);

y = resample(x,p,q);

end

