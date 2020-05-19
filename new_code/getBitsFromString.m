function ascii_as_bits = getBitsFromString(x)
    text = fileread(x);
    ascii_codes = unicode2native(text, 'US-ASCII');
    ascii_as_bits = dec2bin(ascii_codes);
end