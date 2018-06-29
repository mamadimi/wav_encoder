%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia

%Authors: Mamagiannos Dimitios(7719)- Bakas Stylianos (7726)
%Date: February 2016
%version: 1.0

function [ b , newstate ] = encoder( x , state )
%Generate the bitstream of a part of the signal utilizing huffman code and
%adding the header. More information on the strucure of the header and the
%procedure in the report.

addpath ../quantizer
addpath ../lpcoeffs
addpath ../huffman
addpath ../adpcm

%% Recover the previous state,
newstate = state;

m=state.m;
y=x;
w = lpcoeffs(y',m);

%% Find the limits of the quantLevels.
xmin = min(x);
xmax = max(x);

numOfBits = log2( abs(xmax-xmin)/0.003);

n_x = round(numOfBits);

if n_x>7
    n_x = 7;
end

if n_x<=3
    n_x =4;
end

%n_x =state.n_x;

    
[D,L] = quantLevels(n_x,xmin,xmax);

%% Calculate the w coefficients.
n_wq = state.n_wq;
wmin = min(w);
if(floor(wmin)>15)
    fprintf('Wmin overflow wmin_dec is not 3 bit')
end
wmax = max(w);
if(floor(wmax)>15)
    fprintf('Wmax overflow wmin_dec is not 3 bit')
end

%% ADPCM
[rq,wq] = adpcm(x,D,L,m,wmin,wmax,n_wq);

%% Calculate the frequencies of the quantizer's levels.
p_x = zeros(2^n_x,1);


for i=1:length(rq)
    p_x(rq(i)) = p_x(rq(i)) + 1;
end

p_x = p_x / (length(x));

position = []; %position[i] is a pointer on which position of p_x tne value of p[i] is matched.

for i=1:length(p_x)
    if (p_x(i) ~=0)
        position = [position ; i];
    end
end

p=[];
for i = 1:length(position)
    p = [p; p_x(position(i))];
end

q=[];

for i=1:length(x)
    
    q = [q ; find(position == rq(i))];
end

%% Huffman
s = huffLUT( p);

sum=[0 0];
for i=1:length(s)
    sum = sum + size(s{i});
end
b = huff( q,s );

%% Header
%More information on the strucure of the header and the procedure in the report.

header = cell(1,1);

%% Add n_x
    header{1} = strcat(header{1},dec2bin( n_x,4 ) );


%% Add Wmin and Wmax

if(wmin <0)
    wmin_temp = -wmin;
    header{1} = strcat(header{1},'1');
    
else
    wmin_temp = wmin;
    header{1} = strcat(header{1},'0');
end

% wmin 32 bit
w_dec_bit = 4;         % number bits for integer part of your number
w_fl_bit = 28;         % number bits for fraction part of your number
d2b = fix(rem(wmin_temp*pow2(-(w_dec_bit-1):w_fl_bit),2));


for j=1:32
    header{1} = strcat(header{1},num2str(d2b(j)));
end

if(wmax <0)
    wmax_temp = -wmax;
    header{1} = strcat(header{1},'1');
    
else
    wmax_temp = wmax;
    header{1} = strcat(header{1},'0');
end

w_dec_bit = 4;         % number bits for integer part of your number
w_fl_bit = 28;         % number bits for fraction part of your number
d2b = fix(rem(wmax_temp*pow2(-(w_dec_bit-1):w_fl_bit),2));

for j=1:32
    header{1} = strcat(header{1},num2str(d2b(j)));
end

%% Add wq
for j=1:length(wq)
    wq(j);
    header{1} = strcat(header{1},dec2bin( wq(j)-1,n_wq ) );
    
end

%Choose between the two situations.
%situatuion 0: The number of non-zero possibility symbols >= The number of zero possibility symbols
%situatuion 1: The number of non-zero possibility symbolsz The number of zero possibility symbols


if( length(s) <= 2^n_x - length(s) )
    header{1} = strcat(header{1},'0');
    
    %Length s
    header{1} = strcat(header{1},dec2bin( length(s),n_x ) );
    
    %For every symbol s matxh with position array
    
    for j=1:length(s)
        dec2bin( position(j),n_x);
        
        header{1} = strcat(header{1},dec2bin( position(j)-1,n_x) );
        
        length(s{j});
        
        header{1} = strcat(header{1},dec2bin( length(s{j}),n_x) );
        
        header{1} = strcat(header{1},s{j});
        
    end
else
    header{1} = strcat(header{1},'1');
    
    positionZeros = [];
    
    for i=1:length(p_x)
        if (p_x(i) == 0)
            positionZeros = [positionZeros ; i];
        end
    end
    
    length(positionZeros);
    %Length positionZeros
    header{1} = strcat(header{1},dec2bin( length(positionZeros),n_x ) );
    
    %zeros numbers with zero possibilities
    for j=1:length(positionZeros)
        header{1} = strcat(header{1},dec2bin( positionZeros(j)-1,n_x) );
    end
    
    %% Add the symbols
    
    for j=1:length(s)
        
        length(s{j});
        
        header{1} = strcat(header{1},dec2bin( length(s{j}),n_x) );
        
        header{1} = strcat(header{1},s{j});
        
    end
end

%% Add rq min and rq max
min_rq = xmin;
max_rq = xmax;
if(min_rq <0)
    min_rq_temp = -min_rq;
    header{1} = strcat(header{1},'1');
    
else
    min_rq_temp = min_rq;
    header{1} = strcat(header{1},'0');
end

w_dec_bit =3;         % number bits for integer part of your number
w_fl_bit =29;         % number bits for fraction part of your number
d2b = fix(rem(min_rq_temp*pow2(-(w_dec_bit-1):w_fl_bit),2));


for j=1:32
    header{1} = strcat(header{1},num2str(d2b(j)));
end

if(max_rq <0)
    max_rq_temp = -max_rq;
    header{1} = strcat(header{1},'1');
    
else
    max_rq_temp = max_rq;
    header{1} = strcat(header{1},'0');
end

w_dec_bit = 3;         % number bits for integer part of your number
w_fl_bit = 29;         % number bits for fraction part of your number
d2b = fix(rem(max_rq_temp*pow2(-(w_dec_bit-1):w_fl_bit),2));


for j=1:32
    header{1} = strcat(header{1},num2str(d2b(j)));
end

%% Add size of window

b{1} = strcat(header{1},b{1});

b{1} = strcat(dec2bin (length(b{1})+state.sizeWindows_binary,state.sizeWindows_binary) ,b{1});


end

