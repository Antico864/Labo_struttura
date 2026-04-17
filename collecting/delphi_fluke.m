fluke=serialport("ASRL3::INSTR");

Rs = table('Size', [0 2], 'VariableTypes', {'double', 'duration'},'VariableNames',{'Resistenza','Tempo'});
i = 1;

writeline(fluke, "OHMS")
writeline(fluke, 'RATE M') % sampling rate


while timeofday(datetime("now"))<duration(16,44,0) 
    pause(1);
end
while timeofday(datetime("now"))<duration(16,45,0)  
    % take a single R measure
    writeline(fluke, "MEAS1?");
    t = timeofday(datetime("now"));
    R_string = readline(fluke);
    
    cestino = readline(fluke);

    R_num = str2double(R_string);
    Rs(i, :) = {R_num, t};
    i = i + 1;
end

Rs.Tempo.Format = 'hh:mm:ss.SSSSSS';

nome_file = 'dati_resistenza.txt';

% Save on file
writetable(Rs, nome_file, 'Delimiter', '\t');

