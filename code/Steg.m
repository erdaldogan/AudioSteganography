    clear; clc; close all;
    [Y, Fs]=audioread('chirp.wav');
    figure;
    plot(Y);
    samples = Y*32768;
    sample_int = int16(samples);
    sample_int_abs = abs(sample_int);

    scalar_matrix = sample_int./sample_int_abs;
    scalar_matrix2 = scalar_matrix;
    for i=1:numel(scalar_matrix)
        if scalar_matrix(i)==0
            scalar_matrix2(i)=1;
        end
    end
    sample_uint16=uint16(sample_int_abs);
    encKey1=file2bin('encryptionKey.txt')';
    encKey=encKey1';
    
    s1=file2bin('msg.txt');
    s=s1';
    nsample_uint16=sample_uint16;
    %LSB leri s1 deki bitlere uygun mu diye kontrol et
    L=length(Y);
    L1=numel(s);
    encLength=de2bi(L1, 17)';
    encLengthChar= num2str(encLength);
    
    crypLength=length(Y)-100;
    bitSpace=floor(crypLength/length(s1));
    bitSpace1=de2bi(bitSpace, 12)';
    bitNumtostr= num2str(bitSpace1);
    finalEnchChar = vertcat(bitNumtostr, encLengthChar);
    for i=1:88 % 8 character password ü gömme
        
        [bit,encKey1]=getBits(encKey1);
        nsample_uint16(i) = LSB(sample_uint16(i), bit);
    end
    lul=88+numel(finalEnchChar);
    k=0;
    for i=89:lul-1
      disp((i));
         [bit, finalEnchChar] = getBits(finalEnchChar);
         disp(bit);
         nsample_uint16(i) = LSB(sample_uint16(i),finalEnchChar(1));
      %nsample_uint16(i) = bitSpace(i-88);
    end
    spaceCounter= 0;
    stegCount= 0;
  for i=lul:L
      if(i<1000)
    disp(i);
      end
            if( spaceCounter == 0 && numel(s) ~= 0)
             disp('gömdük');
             [bit,s]=getBits(s);
            nsample_uint16(i)=LSB(sample_uint16(i),bit);
            spaceCounter = bitSpace;
            stegCount = stegCount +1;
            
            end
        spaceCounter = spaceCounter -1;
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

 function [sample] = LSB(sample,bit)
%LSB4 Summary of this function goes here
%   Detailed explanation goes here
sample=bitshift(sample,-1);
sample=bitshift(sample,1);
bitval=bin2dec(bit);
sample=sample+bitval;
end

function [token,remaining] = getBits(bits)
token=bits(1);
remaining=bits(2:end);
end
