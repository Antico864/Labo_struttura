% Here we understand the different conduction zones. 

% data file: 
name = 'vetro_2_28_04';
filename = ['data/', name, '.txt'];


% Extract data: 
opts = detectImportOptions(filename, 'Delimiter', '\t');

opts = setvartype(opts, {'Resistance','Thickness','Rate'}, 'double');
opts = setvartype(opts, {'Time_R','Time_T'}, 'string');

T = readtable(filename, opts);

R = T.Resistance;
thickness = T.Thickness;
rate = T.Rate;
G = 1./R;

valid = ~isnan(R) & ~isnan(thickness) & (R > 0);
R = R(valid);
thickness = thickness(valid);

rate_nm = rate*100;
thickness_nm = thickness*100;




% zone 1: nucleation
% The region is determined empirically... 

% zone 2: tunneling
% We have to test the sqrt(t) or t dependence of log(G)...
t_min_tunneling = 4.5;
t_max_tunneling = 10.0;

% Seleziona solo i punti che soddisfano ENTRAMBE le condizioni
idx_tun = (thickness_nm >= t_min_tunneling) & (thickness_nm <= t_max_tunneling);

t_tun = thickness_nm(idx_tun);
G_tun = G(idx_tun);

% 2. Calcolo dei delta (differenze tra punti adiacenti)
d_logG = diff(log(G_tun));
dt = diff(t_tun);
d_sqrt_t = diff(sqrt(t_tun));

% 3. Calcolo delle derivate (approssimazione numerica)
slope_t = d_logG ./ dt;          % Derivata rispetto a t
slope_sqrt_t = d_logG ./ d_sqrt_t; % Derivata rispetto a sqrt(t)

% Creiamo un asse x per i punti derivati (punto medio tra i campioni)
t_mid = t_tun(1:end-1) + dt/2;

% --- 4. PLOT DELLE DERIVATE ---
figure;
tiledlayout(2, 1, 'TileSpacing', 'compact');

% Plot derivata rispetto a t (Anisotropa)
nexttile;
plot(t_mid, slope_t, 'o-', 'LineWidth', 1.5);
grid on;
xlabel('Thickness [nm]');
ylabel('d(logG)/dt');
title('Test Crescita Anisotropa (Cerca un plateau orizzontale)');

% Plot derivata rispetto a sqrt(t) (Isotropa)
nexttile;
plot(t_mid, slope_sqrt_t, 'x-', 'LineWidth', 1.5, 'Color', '#D95319');
grid on;
xlabel('Thickness [nm]');
ylabel('$\frac{d(\log G)}{d(\sqrt{t})}$', 'Interpreter', 'latex');
title('Test Crescita Isotropa (Cerca un plateau orizzontale)');

figname = ['fig/', name, '_DerivateTunneling.fig'];
savefig(gcf, figname);




% zone 3: coalescence