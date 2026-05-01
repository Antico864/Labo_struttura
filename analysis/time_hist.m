filename = 'data_file.txt'
T = readtable(filename, 'Delimiter', '\t');

disp(class(T.Time_R));
disp(class(T.Time_T));

delta_t = T.time_T - T.Time_R;
delta_ms = milliseconds(delta_t);
delta_ms = delta_ms(~isnan(delta_ms));

figure;
histogram(delta_ms, 50); % bin number has to be chosen

xlabel('\Delta t  [ms]');
ylabel('Occurrence');
title('Time\_T - Time\_R');
grid on;