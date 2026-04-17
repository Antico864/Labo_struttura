% Name has to be changed 
maxtek=serialport("/dev/cu.usbserial-AM00OLX4", 9600);

Zs = table('Size', [0 2], 'VariableTypes', {'double', 'duration'},'VariableNames',{'Spessore','Tempo'});
i = 1;
t_start = timeofday(datetime("now")) + seconds(2);
t_stop = t_start + seconds(0.5);
t = duration(0, 0, 0);
Z = 0; % double
intext = blanks(5);
checksum = blanks(1);


disp('Waiting');
while timeofday(datetime("now")) < t_start 
    pause(1);
end

disp('Start data logging');

% Automatic data logging
% Structure: [Header1, Header2, Address, Instruction, Length, Data1, Data2, Checksum]
flush(maxtek); % Butta via i bit che ha occupati da precedenti esecuzioni
cmd_start = char([255, 254, 1, 5, 2, 16, 0, 232]); % Solo thickness del 1° monitor
write(maxtek, cmd_start, "char");

receipt = read(maxtek, 8, "char"); % Una volta sola, dopo il comando di inizio misura

% Measure
while timeofday(datetime("now")) < t_stop
    intext = read(maxtek,5,'char'); % Intestazione
    data = read(maxtek,5,'char'); % Misura
    % Dimmi il tempo
    t = timeofday(datetime('now'));
    Z = str2double(data); % il tipo è giusto?
    checksum = read(maxtek,5,'char'); % Checksum
    Zs(i,:) = {Z, t};
    i = i + 1;
end

Zs.Tempo.Format = ('hh:mm:ss:SSSSSS');
% Il formato della Z non è modificabile a quanto pare


% L'output della misura, in byte, è: 
% 255 254 1 5 5 " 5 byte di caratteri" 7 (il 7 è la checksum)

% Manca da riunificare i due script, e da mettere separatamente 
% la parte in cui dichiariamo le macchine