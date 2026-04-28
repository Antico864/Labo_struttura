writeline(fluke, "OHMS")
readline(fluke);
writeline(fluke, 'RATE M') % sampling rate
readline(fluke);

Measures = table('Size', [0 4], 'VariableTypes', {'double', 'double', 'duration', 'duration'},'VariableNames',{'Resistance', 'Thickness', 'Time_R', 'Time_T'});
i = 1;
t_start = timeofday(datetime("now")) + seconds(2);
t_stop = t_start + seconds(10);
t_R = duration(0, 0, 0);
t_Z = duration(0, 0, 0);
Z = 0;
% maxtek bin variables
header = blanks(5);
checksum = blanks(1);
bin = "";
% plot allocation
figure('Name', 'Real-time Scatter R vs Z');
h_scatter = scatter([], [], 'filled'); 
title('Real-time monitoring: R vs Z');
xlabel('Z');
ylabel('R');
grid on;

% wait
disp('Waiting');
while timeofday(datetime("now")) < t_start 
    pause(0.01);
end



% Measure

disp('Data logging has started');

% Automatic data logging
% Structure: [Header1, Header2, Address, Instruction, Length, Data1, Data2, Checksum]
flush(maxtek); % Discard occupied bytes
cmd_start = char([255, 254, 1, 5, 2, 16, 0, 232]); % Only 1st monitor thickness
write(maxtek, cmd_start, "char");

receipt = read(maxtek, 8, "char"); % Once, after the "measure" command

while timeofday(datetime("now")) < t_stop
    %take a single joint measure

    while maxtek.NumBytesAvailable >= 11
        header = read(maxtek,11,'char');
    if maxtek.NumBytesAvailable < 11
        pause(0.001);
    end
    end

    header = read(maxtek,5,'char'); % header
    writeline(fluke, "MEAS1?");
    t_R = timeofday(datetime("now"));
    data = read(maxtek,5,'char'); % proper measure
    t_Z = timeofday(datetime('now')); % acquire time of measure
    
    checksum = read(maxtek,1,'char');
    R_string = readline(fluke);
    bin = readline(fluke);
    R = str2double(R_string);
    Z = str2double(data);
    
    Measures(i,:)={R,Z,t_R,t_Z};
    
    % real-time plot updating
    h_scatter.XData(end+1) = Z;
    h_scatter.YData(end+1) = R;
    
    % update window
    drawnow limitrate; 


    
    i = i + 1;
    
end

Measures.Time_R.Format = 'hh:mm:ss.SSSSSS';
Measures.Time_T.Format = 'hh:mm:ss.SSSSSS';
% Z format can't be modified

data_file = 'data_file.txt';

% Save on file
writetable(Measures, data_file, 'Delimiter', '\t');

% The maxtek measure's output, in bytes, is: 
% 255 254 1 5 5 " 5 character bytes" 7 (7 is the checksum)

flush(maxtek);

% If Ctrl+C is used, digit writetable(Measures, data_file, 'Delimiter', '\t'); to save measures in the log file. 
% Matlab automatically saves all variables, so no data is lost. 