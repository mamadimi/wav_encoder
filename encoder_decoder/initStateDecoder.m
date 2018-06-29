%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia

%Authors: Mamagiannos Dimitios(7719)- Bakas Stylianos (7726)
%Date: February 2016
%version: 1.0

function statee = initStateDecoder()
%initialize the starting state of the decoder.

statee =state;
statee.m = 2;

statee.n_x =7;

statee.n_wq = 16;

statee.sizeWindows_binary = 24;

statee.start =0;

end

