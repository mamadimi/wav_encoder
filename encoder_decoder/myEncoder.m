%Aristotle University of Thessaloniki
%Faculty of engineering
%Department of electrical & computer engineering
%Lesson : Multimedia

%Authors: Mamagiannos Dimitios(7719)- Bakas Stylianos (7726)
%Date: February 2016
%version: 1.0

function myEncoder( wavFilename,codedFilename )

addpath ../quantizer
addpath ../lpcoeffs
addpath ../huffman
addpath ../adpcm

fprintf('Encoding %s...',wavFilename);


[data,fs] = audioread(wavFilename);

channel_1 = data(:,1);
channel_1 = channel_1';

channel_2 = data(:,2);
channel_2 = channel_2';

%Send the diff between channels
channel_2 = channel_1-channel_2;

%% Get frequency and size of windows for each channel
[nch1,new_fs_ch1]=getParams(channel_1,fs);
[nch2,new_fs_ch2]=getParams(channel_2,fs);

if new_fs_ch2>new_fs_ch1
    new_fs_ch2 = new_fs_ch1;
    nch2 = nch1;
end


nch1=nch1*(fs/new_fs_ch1);
nch2=nch2*(fs/new_fs_ch2);

windows_ch1 = floor( length(channel_1)/(nch1) );
windows_ch2 = floor( length(channel_2)/(nch2) );

if windows_ch1==0
    windows_ch1 = 1;
end

if windows_ch2==0
    windows_ch2 = 1;
end



bitstream=cell(1,1);


%% Compress windows
newstate = state;
newstate = initStateEncoder();

for i=1:windows_ch1-1
    
    unchanged_x1(i,:) = channel_1(1+(i-1)*nch1:i*nch1);
    x1(i,:)  = changefs(unchanged_x1(i,:),fs,new_fs_ch1) ;
    
end

for i=1:windows_ch2-1
    
    unchanged_x2(i,:) = channel_2(1+(i-1)*nch2:i*nch2);
    x2(i,:)  = changefs(unchanged_x2(i,:),fs,new_fs_ch2) ;
    
end


%% Compress last window.
last_x1 = channel_1(1+(windows_ch1-1)*nch1:length(channel_1));
size1=length(last_x1);
last_x1= changefs(last_x1,fs,new_fs_ch1) ;
last_x2 = channel_2(1+(windows_ch2 - 1)*nch2:length(channel_2));
size2=length(last_x2);
last_x2 = changefs(last_x2,fs,new_fs_ch2) ;

sizech1=length(last_x1);
sizech2=length(last_x2);

last_x1=last_x1(1:sizech1-1)  ;
last_x2=last_x2(1:sizech2-1)  ;

%% Encode windows.
for i=1:windows_ch1-1
    [b1,newstate] = encoder(x1(i,:),newstate);
    
    bitstream{1} = strcat(bitstream{1},b1{1});
end
[b1,newstate] = encoder(last_x1,newstate);

bitstream{1} = strcat(bitstream{1},b1{1});

for i=1:windows_ch2-1
    [b2,newstate] = encoder(x2(i,:),newstate);
    
    bitstream{1} = strcat(bitstream{1},b2{1});
end

[b2,newstate] = encoder(last_x2,newstate);

bitstream{1} = strcat(bitstream{1},b2{1});

%% Add the modulo of channel 1 (the number of samples that are lost because of the undersampling).
modulo = dec2bin (mod(size1,(fs/new_fs_ch1)),8 );
bitstream{1} = strcat(bitstream{1},modulo);

%% Add the modulo of channel 2 (the number of samples that are lost because of the undersampling).
modulo = dec2bin (mod(size2,(fs/new_fs_ch2)),8 );
bitstream{1} = strcat(bitstream{1},modulo);

%% Add the number of windows of channel 1
bitstream{1} = strcat(bitstream{1},dec2bin (windows_ch1,8 ));

%% Add the quotient of fs devided by the undersasmpling frequency of channel 1

bitstream{1} = strcat(dec2bin( (fs/new_fs_ch2),5 ),bitstream{1});
%% Add the quotient of fs devided by the undersasmpling frequency of channel 2

bitstream{1} = strcat(dec2bin( (fs/new_fs_ch1),5 ),bitstream{1});

bitrate =length(bitstream{1})/ (size(data,1)/fs)/1000;

b= bitstream{1};

fprintf('done\n');
save(codedFilename,'b');

end

