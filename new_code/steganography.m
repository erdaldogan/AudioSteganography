clear all; clc;
%info = audioinfo()
sound = audioread("chirp.wav");
%soundsc(sound);

[sound_bits, neg_loc] = getBitsFromSound("chirp.wav");
string_bits = getBitsFromString("msg.txt");

sound_bits = embedStringBitsToSoundBits(sound_bits, string_bits);

reconstructed_sound = bin2dec(sound_bits) / 32768;

for i=1:length(neg_loc)
    reconstructed_sound(neg_loc(i)) = reconstructed_sound(neg_loc(i)) * -1;
end

soundsc(reconstructed_sound);



