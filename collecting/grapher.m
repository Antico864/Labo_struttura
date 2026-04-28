% file name
filename = 'dati.txt'; % MUST BE CHANGED!!

% read the table
opts = detectImportOptions(filename, 'Delimiter', '\t');

% force correct data types
opts = setvartype(opts, {'Resistance','Thickness','Rate'}, 'double');
opts = setvartype(opts, {'Time_R','Time_T'}, 'string');

T = readtable(filename, opts);

% column extraction
R = T.Resistance;
thickness = T.Thickness;

% remove NaN and invalid values
valid = ~isnan(R) & ~isnan(thickness) & (R > 0);
R = R(valid);
thickness = thickness(valid);

% graph
figure;
semilogy(thickness, R, 'o-','LineWidth',1.5);
grid on;

xlabel('Thickness');
ylabel('Resistance');
title('Resistance vs Thickness (log scale)');