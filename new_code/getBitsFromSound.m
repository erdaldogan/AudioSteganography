function [sound_as_bits, negative_locations] = getBitsFromSound(x)
    sound = audioread(x, 'double');
    len = length(sound);
    negative_locations = [];
    sound = sound * 32768; %normalize the values for 16 bits per sample

    % loop below checks the negative values and converts them to postive by 
    % saving their positions for reconsturction later on.
    for i = 1:len
        current_val = sound(i);
        if current_val < 0
            negative_locations = [negative_locations, i];
            sound_abs(i) = abs(sound(i));
        else
            sound_abs(i) = sound(i);
        end
    end
        sound_as_bits = dec2bin(sound_abs);
end