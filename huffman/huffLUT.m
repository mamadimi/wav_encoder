%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia 

%Authors: Mamagiannos Dimitios(7719) - Bakas Stylianos(7726)
%Date: February 2016
%version: 1.0
%Builds a variable-lenght Huffman code for a symbol source.

function symbol = huffLUT( pos )

    %Function returns a huffman code as binary strings in cell
    %array symbol for input symbol probability vector pos. Each word in
    %symbol corresponds to a symbol whose probability is at the corresponding
    %index of pos.

    
    
    % Global variable surviving all recursions of function generatecode
    global symbol
    symbol = cell(length(pos),1);             % Init the global cell array
    if length(pos) > 1                     % When more than one symbol…
         pos = pos/sum(pos);                     % Normalize the input probabilities
         symbol = reduction(pos);                    % Do Huffman source symbol reductions
         generatecode(symbol, []);                  % Recursively generate the code
    else
         symbol = {'1'};                    % Else, trivial one symbol case!
    end
end

function symbol = reduction(pos)

    %Function creates a Huffman source reduction tree in a MATLAB cell structure by
    %performing source symbol reductions until there are only two reduced
    %symbols.
    
    symbol =  cell(length(pos),1);
    
    %Generate a starting tree with symbol nodes 1,2,3,.. 
    for i = 1:length(pos)
        symbol{i} = i;
    end
    while numel(symbol) > 2
           [pos,i] = sort(pos);             % Sort the symbol probabilities
           pos(2) = pos(1) + pos(2);          % Merge the 2 lowest probabilities
           pos(1) = [];                  % and discard the lowest.
           symbol = symbol(i);                    % Reorder tree for new probabilities.
           symbol{2} = {symbol{1},symbol{2}};          % and alter the nodes in order to
           symbol(1) = [];                  % to match the probabilities
    end
end

function generatecode(sc, codeword)

    % Function scans the nodes of a Huffman source reduction tree recursively in order to
    % generate the indicated variable length code words.
  
    
    global symbol
    if isa(sc,'cell')                                          % For cell array nodes,
        generatecode(sc{1},[codeword 0]);         % add 0 if it is  1st element,
        generatecode(sc{2}, [codeword 1]);        % or a 1 if it is the 2nd
        
    else                                                            % For leaf nodes,
        symbol{sc} = char('0' + codeword); 
    end

end

