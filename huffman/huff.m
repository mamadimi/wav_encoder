%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719) - Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0

function b = huff( q,s )
%Calculate the bitstream b by matching the appropriate huffman symbols  with q 
%q : quantized samples
%s : huffman symbols

b=cell(1,1);

for i=1:length(q)
    b{1} = [b{1}   s{q(i)}];
end

end

