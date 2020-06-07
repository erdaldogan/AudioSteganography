function message = extractMessageFromSteganographedSound(x)
    hidden_sound_bits = getBitsFromSound(x);
    len = length(hidden_sound_bits);
    message = ''; %final string
    temp_str = ''; % will change at every 7 iteration
    for i=1:len
        temp_str = append(temp_str, hidden_sound_bits(i, 15));
        if mod(i,7) == 0 % once in every 7 iteration
            if temp_str == "1011100" % check if I've read the end of string character
                return;
            end
            %append new char to the final string
            message = append(message, native2unicode(bin2dec(temp_str), 'US-ASCII'));
            temp_str = ''; %reinit temp_str
        end
    end
end