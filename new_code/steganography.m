clear all; clc;

[sound, fs] = audioread("chirp.wav");


[sound_bits, neg_loc] = getBitsFromSound("chirp.wav");
string_bits = getBitsFromString("msg.txt");

sound_bits = embedStringBitsToSoundBits(sound_bits, string_bits);

reconstructed_sound = bin2dec(sound_bits) / 32768;

for i=1:length(neg_loc)
    reconstructed_sound(neg_loc(i)) = reconstructed_sound(neg_loc(i)) * -1;
end

audiowrite("hidden_chirp.wav", reconstructed_sound, fs);
message = extractMessageFromSteganographedSound("hidden_chirp.wav");

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



