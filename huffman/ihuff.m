%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719) - Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0
function [q,n] = ihuff( b,s )
%Return the number of which  symbol  is matched using huffman's symbol array 
%b : bitstream 
%s : huffman symbols
%q : the returned quantized samples
%n : the rest of bits that do not match with a symbol.

q=[];

lgth = length(b{1});

pos = 1 ;

last_pos=1;

 symbol = cell(1,1);

while  (pos <= lgth)
    symbol{1} = [symbol{1} b{1}(pos)];
    index = find(strcmp(s, symbol{1}));
    if (size(index,1) ~= 0)
        symbol = cell(1,1);
        q = [q ; index];
        last_pos = pos;
    end
        
    pos = pos+1;
    
end

n = lgth - last_pos;


end

