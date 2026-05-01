% file name

name = 'vetro_2_28_04';
filename = ['data/', name, '.txt']; % MUST BE CHANGED EACH TIME!!

% read the table
opts = detectImportOptions(filename, 'Delimiter', '\t');

% force correct data types
opts = setvartype(opts, {'Resistance','Thickness','Rate'}, 'double');
opts = setvartype(opts, {'Time_R','Time_T'}, 'string');

T = readtable(filename, opts);

% column extraction
R = T.Resistance;
thickness = T.Thickness;
rate = T.Rate;

% remove NaN and invalid values
valid = ~isnan(R) & ~isnan(thickness) & (R > 0);
R = R(valid);
thickness = thickness(valid);

rate_nm = rate*100;
thickness_nm = thickness*100;



% percolation curve with rate=color
figure;
scatter(thickness_nm, R, 25, rate_nm, 'filled'); 
set(gca, 'YScale', 'log'); % log y axis
colormap('turbo'); % high contrast color map
cb = colorbar; 
ylabel(cb, 'Rate [nm/s]'); % color bar label

grid on;
xlabel('Thickness [nm]');
ylabel('Resistance [Ω]');
title('Resistance vs Thickness (Color = Rate)');

figname = ['fig/', name, '_R.fig'];
savefig(gcf, figname);



% Resistance and rate: 
figure;
yyaxis left;
semilogy(thickness_nm, R, '+-', 'LineWidth', 1.5);
ylabel('Resistance [Ω]');

% Right y axis: 
yyaxis right;
plot(thickness_nm, rate_nm, 'x-', 'LineWidth', 1.5); % not log, rate < 5...
ylabel('Rate [nm/s]'); 

xlabel('Thickness [nm]');
title('Resistance and Rate vs Thickness');
grid on;

figname = ['fig/', name, '_RuR.fig'];
savefig(gcf, figname);

% conductance
G = 1 ./ R;

figure;
semilogy(thickness_nm,G,'+-','LineWidth',1.5);
grid on;

xlabel('Thickness [nm]');
ylabel('G  [Ω^-1]');
title('Conductance vs Thickness (log scale)');

figname = ['fig/', name, '_S.fig'];
savefig(gcf, figname);

% DOBBIAMO SCEGLIERE UN RATE E NON CAMBIARLO PIÙ!!!!!!
% Altrimenti non si possono distinguere le zone...