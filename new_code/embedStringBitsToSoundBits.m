function sound_bits = embedStringBitsToSoundBits(sound_bits, string_bits)
    sound_len = length(sound_bits);
    string_len = length(string_bits(:,1));

    if string_len * 7 > sound_len
        fprintf('This string is too long to hide in this media file!\n');
        return;
    end
    
    for i=0:string_len
        letter = string_bits(i+1,:);
        if letter == "1011100"
            fprintf('Reached to the end!\n');
            fprintf('Last modified line %d!\n', ((i-1)*7)+j);
            return;
        end
        for j=1:7
            sound_bits((i*7)+j, 15) = letter(j);
        end
    end
end
