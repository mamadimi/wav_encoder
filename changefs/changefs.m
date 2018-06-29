%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Author: Mamagiannos Dimitios(7719)
%Date: February 2016
%version: 1.0

function y = changefs( x,fs1,fs2 )
%Undersample or oversample a signal x
%x : a nx1 samples signal
%fs1 : signal's frequency
%fs2 : the desired frequency
%y : the undersampled or oversampled signal

%The fisrt sample is the same. 
y=[];
y=[y  x(1)];

N = length(x);

%In case of ffs1 > fs2 OR fs1 < fs2
if (fs1 > fs2 || fs1 < fs2) 
    t1=[];  %t1 : x samples time slot, starting from 0 sec
    for i=0:length(x) -1
        t1 = [t1 i/fs1];
    end

    i=1;
    while (1)
        t2 = i/fs2; %t2 : y samples time slot, starting from 0 sec
        
        %If t2>max(t1) stop the while loop
        if (t2>=max(t1))
            break
        end
        
        %Find the in which t1 area t2 belongs to.
        pos1 = size(find(t1<=t2),2)  ;
        
        pos2 = N - size(find(t1>t2),2) + 1 ;
          
        %Linear interpolation
        l = ( x(pos2) - x(pos1) ) / ( t1(pos2) - t1(pos1) );
        temp_y = l*(t2-t1(pos1)) + x(pos1);
        
        y = [y  temp_y];
        
        i=i+1;
    end
else 
    %In case of fs1=fs2
    y=x;      
end

%According to the description, new signal y has a specific size
%limit = floor((fs2/fs1)*(N-1));
limit = floor((fs2/fs1)*(N-1));

if size(y,2) > limit
     y(size(y,2)) = [];
end

if size(y,2) < limit
     for (i=size(y,2):limit)
         y(i)=y(size(y,2));
     end   
end

end

