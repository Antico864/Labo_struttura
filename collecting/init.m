clear all

serialportlist
visadevlist

% NAMES HAVE TO BE CHANGED
% maxtek
maxtek=serialport('nome', BaudRate);
config=uint8([255,254,1,1,0,254]);
write(maxtek,config,'char');
status=read(maxtek,8,'char'); % dovrebbe darci gli 8 bit di controllo. Poi:
check=read(maxtek,4,'char'); % che ci dà la signature 255 254 1 1
name_str=read(maxtek, 36,'char');
name_maxtek=char(name_str); % questo dovrebbe essere il nome
disp(name_maxtek);

% fluke
fluke=visadev("ASRL3::INSTR");
% readline(fluke); Non so se questo serve... Boh
fluke.BaudRate = 9600;
fluke.DataBits = 8;
fluke.Parity = 'none';
fluke.StopBits = 1;
configureTerminator(fluke, "CR/LF");
writeline(fluke, "*IDN?");
readline(fluke); % Questo serve?
name_fluke=readline(fluke);
readline(fluke);
disp(name_fluke);
