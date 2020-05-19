    clear; clc; close all;
    [Y, Fs]=audioread('chirp.wav');
%    figure;
%    plot(Y);
    samples = Y*32768; % 32768 = 2^15
    sample_int = int16(samples);
    sample_int_abs = abs(sample_int);

    scalar_matrix = sample_int ./ sample_int_abs;
    scalar_matrix2 = scalar_matrix;
    for i=1:numel(scalar_matrix)
        if scalar_matrix(i)==0
            scalar_matrix2(i)=1;
        end
    end
    
    sample_uint16=uint16(sample_int_abs);
    encKey=file2bin('encryptionKey.txt')';
    %encKey=encKey1';
    
    s1=file2bin('msg.txt');
    s=s1';
    nsample_uint16=sample_uint16;
    %LSB leri s1 deki bitlere uygun mu diye kontrol et
    L=numel(s);
    
    crypLength=length(Y)-100;
    bitSpace1=floor(crypLength/length(s1));
    bitSpace=de2bi(bitSpace1, 12)';
    bitSpace2=bitSpace(:)';
    bitSpChar= char(bitSpace);
    for i=1:88 % 8 character password ü gömme
        
        [bit,encKey]=getBits(encKey,1);
        nsample_uint16(i) = LSB(sample_uint16(i), bit, 1);
    end
    
    k=0;
    for i=89:100
      disp(bitSpChar(i-88));
        %  nsample_uint16(i) = LSB(sample_uint16(i),bitSpace(i-88),1);
       nsample_uint16(i) = bitSpace(i-88);
    end
    
  for i=100:L
   % disp(i);
            
    [bit,s]=getBits(s,1);
     nsample_uint16(i)=LSB(sample_uint16(i),bit,1);
           
      
  end
    %% Display stego Samples
    
    %final audio dan LSB leri çekerek stringi displayle
  
    final_int = int16(nsample_uint16).*scalar_matrix2;
    final_audio = double(final_int)/32768;
    figure;
    plot(final_audio); title('Gömülü audio');
    audiowrite('Myaudio.wav',final_audio,Fs);
    
    Diff= final_audio-Y;
    figure;
    plot(Diff);
    %Fark= nsample_uint16;
    
 function [binn]=file2bin(FileName)
% Read the file:
FID  = fopen(FileName, 'rb');
if FID < 0
   %error([ErrID, ':ReadFile'], ['Cannot read file: ', ClearFile]);
    msgbox(['Cannot read file: ', FileName],'File Error','Error');
end
Data = fread(FID, Inf, '*uint8');
Data2=Data(:);
bin=dec2bin(Data2,8)';
binn=bin(:);
fclose(FID);
 end   

 function [sample] = LSB(sample,bits,length)
%LSB4 Summary of this function goes here
%   Detailed explanation goes here
sample=bitshift(sample,-length);
sample=bitshift(sample,length);
bitval=bin2dec(bits);
sample=sample+bitval;
end

function [token,remaining] = getBits(bits,tokenLength)
token=bits(1,1:tokenLength);
remaining=bits(1,tokenLength+1:end);
end
