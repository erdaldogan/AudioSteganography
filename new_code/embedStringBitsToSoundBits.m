function sound_bits = embedStringBitsToSoundBits(sound_bits, string_bits)
    sound_len = length(sound_bits);
    string_len = length(string_bits(:,1));

    if string_len * 7 > sound_len %each char is coded w/ 7 bits
        fprintf('This string is too long to hide in this media file!\n');
        return;
    end
    
    for i=0:string_len
        letter = string_bits(i+1,:);
        for j=1:7
            sound_bits((i*7)+j, 15) = letter(j); %(i*7)+j gives sequential
            % numbers that serves as index for samples of the audio
        end
        if letter == "1011100" %end of string identifier
            fprintf('Reached to the end!\n');
            fprintf('Last modified line %d!\n', ((i)*7)+j);
            return;
        end
    end
end
