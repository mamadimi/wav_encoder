%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia

%Authors: Mamagiannos Dimitios(7719)- Bakas Stylianos (7726)
%Date: February 2016
%version: 1.0

function myDecoder( codedFilename , wavFilename )

addpath ../quantizer
addpath ../lpcoeffs
addpath ../huffman
addpath ../adpcm

fprintf('Decoding %s...',wavFilename);

fs = 44100;

load(codedFilename)

bb=b;
clear b;
b=cell(1,1);
b{1} = bb;

%% Recover new_fs_ch1
factor_ch1 = b{1}(1:5);
factor_ch1 = bin2dec(factor_ch1);

new_fs_ch1 = fs/factor_ch1;

b{1} = b{1}(5+1:length(b{1}));

%% Recover new_fs_ch2
factor_ch2 = b{1}(1:5);
factor_ch2 = bin2dec(factor_ch2);

new_fs_ch2 = fs/factor_ch2;

b{1} = b{1}(5+1:length(b{1}));

%% Remove size of windows
windows_ch1 = b{1}(length(b{1})-7 : length(b{1}));
windows_ch1 = bin2dec(windows_ch1);
b{1} = b{1}(1:length(b{1})-8);


%% Remove modulo 2
modulo2 = b{1}(length(b{1})-7 : length(b{1}));
modulo2 = bin2dec(modulo2);
b{1} = b{1}(1:length(b{1})-8);

%% Remove modulo 1
modulo1 = b{1}(length(b{1})-7 : length(b{1}));
modulo1 = bin2dec(modulo1);
b{1} = b{1}(1:length(b{1})-8);

%% Compress window
newstate = state;
newstate = initStateDecoder();

bitstream_size = length( b{1} );
sizeWindows_binary = 24;
channel1 =[];
channel2=[];
j=0;


%% Start decoding
temp_x1=zeros(1,fs/new_fs_ch1);
temp_x2=zeros(1,fs/new_fs_ch1);
sum=0;

%% Decode windows
while (newstate.start < bitstream_size)
    
    %channel 1
    start = newstate.start;
    sizeWindow = bin2dec(b{1}(start + 1:start + sizeWindows_binary ));
    b1=cell(1,1);
    b1{1} = b{1}(start+1:start+sizeWindow);
    
    
    [x1,newstate] = decoder(b1,newstate);
    x1 = changefs(x1,new_fs_ch1,fs);
    
    channel1 = [channel1 x1] ;
    
    j=j+1;
    
    if j==windows_ch1
        break;
    end
    
end

j=0;
while (newstate.start < bitstream_size)
    
    %Channel 2
    start = newstate.start;
    
    sizeWindow = bin2dec(b{1}(start + 1:  start + sizeWindows_binary));
    b1=cell(1,1);
    b1{1} = b{1}(start+1:start+sizeWindow);
    
    [x2,newstate] = decoder(b1,newstate);
    x2 = changefs(x2,new_fs_ch2,fs);
    
    channel2 = [channel2 x2];
    
    j=j+1;
    
end

x1_size = length(x1);
x2_size= length(x2);

%% Add missing samples.

%Modulo channel 1
if(modulo1==0)
    y1=zeros(1,(fs/new_fs_ch1));
    for i=1:(fs/new_fs_ch1)
        y1(i)=x1(x1_size);
    end
else
    y1=zeros(1,modulo1);
    
    for i=1:modulo1
        y1(i)=x1(x1_size);
    end
end

%Modulo channel 2
if(modulo2==0)
    y2=zeros(1,(fs/new_fs_ch2));
    for i=1:(fs/new_fs_ch2)
        y2(i)=x2(x2_size);
    end
else
    y2=zeros(1,modulo2);
    
    for i=1:modulo2
        y2(i)=x2(x2_size);
    end
end
channel1 = [channel1 y1];
channel2 = [channel2 y2];

channel1 = channel1';
channel2=channel2';



x = [channel1  channel1-channel2];

fprintf('done\n');

wavwrite(x,fs,32,wavFilename);

end

