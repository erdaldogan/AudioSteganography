function message = extractMessageFromSteganographedSound(x)
    hidden_sound_bits = getBitsFromSound(x);
    len = length(hidden_sound_bits);
    message = '';
    temp_str = '';
    for i=1:len
        temp_str = append(temp_str, hidden_sound_bits(i, 15));
        if mod(i,7) == 0
            if temp_str == "1011100"
                return;
            end
            message = append(message, native2unicode(bin2dec(temp_str), 'US-ASCII'));
            temp_str = '';
        end
    end
end