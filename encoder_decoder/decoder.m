
%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia

%Authors: Mamagiannos Dimitios(7719)- Bakas Stylianos (7726)
%Date: February 2016
%version: 1.0



function [ x,newstate ] = decoder( b,state )

%Decode the bitstream of a part of the signal utilizing huffman code and
%the included header. More information on the strucure of the header and the
%procedure in the report.


addpath ../quantizer
addpath ../lpcoeffs
addpath ../huffman
addpath ../adpcm

%% Recover the previous state,

n_wq = state.n_wq;
m = state.m;
newstate = state;

%% Export size of the window
sizeWindows_binary = state.sizeWindows_binary;
sizeWmin_max_binary = 32;
sizeHuffman_binary = state.n_x;
w_length = 16;

%% Header
start = 0; %pointer that shows where to read from the bitstream.

sizeWindow = bin2dec(b{1}(start + 1:start + sizeWindows_binary ));

start = start + sizeWindows_binary  ;

%% Get n_x
    sizeHuffman_binary = bin2dec ( b{1}( start+1 : start+ 4 )) ;
    start = start +4;

%% Get wmin.
sign = bin2dec ( b{1}(start +1) );

start = start +1 ;
bb =  b{1}(start+1:start +  sizeWmin_max_binary) ;

start =start + sizeWmin_max_binary;

wmin= zeros(1,sizeWmin_max_binary);
for i=1:sizeWmin_max_binary
    if(bb(i)=='1')
        wmin(i) =1;
    else
        wmin(i) =0;
    end
end

wmin = wmin*pow2(4-1:-1:-28).';


if(sign==1)
    wmin=-wmin;
end

%% Get wmax.
sign = bin2dec ( b{1}(start + 1) );

start =start + 1;

bb =  b{1}(start + 1:start+ sizeWmin_max_binary) ;

start = start + sizeWmin_max_binary;
wmax= zeros(1,sizeWmin_max_binary);
for i=1:sizeWmin_max_binary
    if(bb(i)=='1')
        wmax(i) =1;
    else
        wmax(i) =0;
    end
end

wmax = wmax*pow2(4-1:-1:-28).';

if(sign==1)
    wmax=-wmax;
end

%% Recover wq.

wq=zeros(m,1);
for i=1:m
    wq(i) = bin2dec ( b{1}( start+1 : start+ w_length )) +1 ;
    start = start +w_length;
end

[Dq,Lq]=quantLevels(n_wq,wmin,wmax);
w=iQuant(wq,Lq);

%% Decode huffman.

kindOfPositions = bin2dec ( b{1}(start+1));
start = start + 1;
if (kindOfPositions==0)
    
    numberHuffmanSymbols = bin2dec( b{1}(start+1:start + sizeHuffman_binary) );
    
    start = start + sizeHuffman_binary;
    
    s= cell( numberHuffmanSymbols,1);
    position=zeros(numberHuffmanSymbols,1);
    
    for i=1:numberHuffmanSymbols
        
        match = bin2dec( b{1}(start+1:start+sizeHuffman_binary) ) +1 ;
        start = start + sizeHuffman_binary;
        position(i) = match;
        
        numBits = bin2dec( b{1}(start+1 : start+sizeHuffman_binary) );
        start = start +sizeHuffman_binary;
        ss = b{1}(start+1:start+numBits);
        start =start + numBits;
        s{i} = ss;
    end
else
    numOfPositionZeros = bin2dec( b{1}(start+1:start+sizeHuffman_binary) );
    start = start + sizeHuffman_binary;
    
    %zeros numbers with zero possibilities
    positionZeros = zeros(numOfPositionZeros,1);
    
    for j=1:length(positionZeros)
        positionZeros(j) = bin2dec( b{1}(start+1:start+sizeHuffman_binary) ) + 1 ;
        start = start + sizeHuffman_binary;
    end
    
    
    
    numberHuffmanSymbols = 2^sizeHuffman_binary - length(positionZeros);
    
    s= cell( numberHuffmanSymbols,1);
    
    for i=1:numberHuffmanSymbols
        
        numBits = bin2dec( b{1}(start+1 : start+sizeHuffman_binary) );
        start = start +sizeHuffman_binary;
        ss = b{1}(start+1:start+numBits);
        start =start + numBits;
        s{i} = ss;
    end
    
    
    position = zeros(numberHuffmanSymbols,1);
    
    %% Recreate positions
    k=1;
    for j=1:2^sizeHuffman_binary
        if ( size( find(positionZeros == j) , 1) == 0)
            position(k) = j;
            k=k+1;
        end
    end
    
end
%% Recover rqmin and rqmax

%min_rq
sign = bin2dec ( b{1}(start +1) );

start = start +1 ;
bb =  b{1}(start+1:start +  sizeWmin_max_binary) ;

start =start + sizeWmin_max_binary;

min_rq= zeros(1,sizeWmin_max_binary);
for i=1:sizeWmin_max_binary
    if(bb(i)=='1')
        min_rq(i) =1;
    else
        min_rq(i) =0;
    end
end

min_rq = min_rq*pow2(3-1:-1:-29).';

if(sign==1)
    min_rq=-min_rq;
end

%max_rq
sign = bin2dec ( b{1}(start + 1) );

start =start + 1;

bb =  b{1}(start + 1:start + sizeWmin_max_binary) ;

start = start + sizeWmin_max_binary;
max_rq= zeros(1,sizeWmin_max_binary);
for i=1:sizeWmin_max_binary
    if(bb(i)=='1')
        max_rq(i) =1;
    else
        max_rq(i) =0;
    end
end

max_rq = max_rq*pow2(3-1:-1:-29).';


if(sign==1)
    max_rq=-max_rq;
end

%% Dequant

bb = cell(1,1);
bb{1} = b{1}(start+1:sizeWindow );
start = state.start+sizeWindow;

[q,nn] = ihuff( bb,s );

q_real = [];

for i=1:length(q)
    q_real = [q_real ; position(q(i)) ];
end

[Dq,Lq] = quantLevels(sizeHuffman_binary,min_rq,max_rq);

x = iadpcm(q_real,wq,Lq,wmin,wmax,16);

newstate.start = start;

end

