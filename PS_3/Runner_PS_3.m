% Goal of this File 
%{ 
1. Simulate the path
2. Compute the Policy function as dynare does
3. Compute EEE
%} 

%Instructions: Run once with delta = 0.1 and once with delta = 1 without
%clearing 

clearvars -except dynare_results EEE
dynare PS_3_v2 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Construct path for capital 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    idx_c = strmatch('c', M_.endo_names, 'exact'); 
    idx_k = strmatch('k', M_.endo_names, 'exact'); 
    idx_z = strmatch('z', M_.endo_names, 'exact'); 
    c_sim = oo_.endo_simul(idx_c, :); 
    k_sim = oo_.endo_simul(idx_k, :); z_sim = oo_.endo_simul(idx_z, :); 
    T = length(c_sim); 
    EE = zeros(1, T-1); 
    
    for t = 1:(T-1) 
        c_t = c_sim(t); 
        c_tp1 = c_sim(t+1); 
        k_tp1 = k_sim(t+1); 
        z_tp1 = z_sim(t+1); 
        EE(t) = 1/c_t - beta * ( (alpha*exp(z_tp1)*k_tp1^(alpha-1) + (1-delta)) / c_tp1 ); 
    end

    k_name = ['k_path_delta_', strrep(num2str(delta), '.', '_')];
    assignin('base', k_name, k_sim);

    % 1. Find the index of capital in the list of endogenous variables
    idx_k = strmatch('k', M_.endo_names, 'exact');
    
    % 2. Extract the simulated path of k_t
    k_sim = oo_.endo_simul(idx_k, :);   % row vector
    T     = length(k_sim);
    
    % Create / update struct to store results
    if ~exist('dynare_results', 'var')
        dynare_results = struct();
    end
    
    if delta == 1
        dynare_results.dynare_01.k = k_sim;
        dynare_results.dynare_01.T = T;
    elseif delta == 0.1
        dynare_results.dynare_1.k = k_sim;
        dynare_results.dynare_1.T = T;
    end
    
    outdir = 'output Dynare';
    if ~exist(outdir, 'dir')
        mkdir(outdir);
    end
    save(fullfile(outdir, 'dynare_results.mat'), 'dynare_results');
    
    % Creating the plot 
    create_plot = 1;
    
    if create_plot == 1 
        load(fullfile(outdir, 'dynare_results.mat'));  % loads dynare_results

        figure('Units','inches','Position',[1 1 8 10]);
            % Top plot: delta = 0.1
            subplot(2,1,1);
            plot(1:dynare_results.dynare_01.T, dynare_results.dynare_01.k);
            xlabel('Time');
            ylabel('k_t');
            title('Capital, \delta = 0.1');
            grid on;
            
            % Bottom plot: delta = 1
            subplot(2,1,2);
            plot(1:dynare_results.dynare_1.T, dynare_results.dynare_1.k);
            xlabel('Time');
            ylabel('k_t');
            title('Capital, \delta = 1');
            grid on;
    
        % Save comparison figure
        savefig(fullfile(outdir, 'capital_compare.fig'));
        saveas(gcf, fullfile(outdir, 'capital_compare_dynare.png'));

    end 

    % For USE in python
    save('z_sim.mat', 'z_sim')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  RECONSTRUCT DYNARE "POLICY AND TRANSITION FUNCTIONS" FOR CAPITAL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars -except dynare_results EEE
dynare PS_3_v2 

% --- Retrieve decision rule structure ---
dr = oo_.dr;
ys = dr.ys;                % steady state (declaration order)

% === Indices for variables ===
idx_k_decl = strmatch('k', M_.endo_names, 'exact');
idx_z_decl = strmatch('z', M_.endo_names, 'exact');
idx_k_dr   = dr.inv_order_var(idx_k_decl);

% === Extract decision-rule matrices for k_t (in DR order) ===
A1_k = dr.ghx(idx_k_dr,:);          % coefficients on states (k(-1), z(-1))
B1_k = dr.ghu(idx_k_dr,:);          % coefficients on shocks (eps_z)
A2_k = squeeze(dr.ghxx(idx_k_dr,:,:));
B2_k = squeeze(dr.ghuu(idx_k_dr,:,:));
C2_k = squeeze(dr.ghxu(idx_k_dr,:,:));
corr_k = dr.ghs2(idx_k_dr);         % mean correction term (Δ²)

% === Steady states ===
k_ss = ys(idx_k_decl);
z_ss = ys(idx_z_decl);              % should be 0 here

% === Handle possible squeezing issues ===
ns = size(A1_k,2);                  % number of state entries (should be 2)
ne = size(B1_k,2);                  % number of shocks (should be 1)
A2_k = reshape(A2_k,ns,ns);
B2_k = reshape(B2_k,ne,ne);
C2_k = reshape(C2_k,ns,ne);

% ------------------------------------------------------------------------
% 1. FIRST- AND SECOND-ORDER COEFFICIENTS IN DEVIATIONS (hat variables)
% ------------------------------------------------------------------------
% First order
a_k1 = A1_k(1);      % coeff on k_hat(-1)
a_z1 = A1_k(2);      % coeff on z_hat(-1)
b_e1 = B1_k(1);      % coeff on eps_t

% Second order
a_kk = 0.5 * A2_k(1,1);   % k_hat(-1)^2
a_kz =       A2_k(1,2);   % k_hat(-1)*z_hat(-1)
a_zz = 0.5 * A2_k(2,2);   % z_hat(-1)^2
b_ee = 0.5 * B2_k(1,1);   % eps_t^2
c_ke =       C2_k(1,1);   % k_hat(-1)*eps_t
c_ze =       C2_k(2,1);   % z_hat(-1)*eps_t

% ------------------------------------------------------------------------
% 2. PRINT RESULTS IN THE SAME FORMAT AS DYNARE'S POLICY TABLE
% ------------------------------------------------------------------------
fprintf('\n//////////////////////////////////////////////////////////////\n');
fprintf('//   RECONSTRUCTED DYNARE POLICY AND TRANSITION FUNCTION   //\n');
fprintf('//////////////////////////////////////////////////////////////\n\n');

fprintf('Variable: k_t\n\n');
fprintf('%-15s %12s\n','Term','Coefficient');
fprintf('%-15s %12.6f\n','Constant',       k_ss);
fprintf('%-15s %12.6f\n','(correction)',   0.5*corr_k);
fprintf('%-15s %12.6f\n','k(-1)',          a_k1);
fprintf('%-15s %12.6f\n','z(-1)',          a_z1);
fprintf('%-15s %12.6f\n','eps_z',          b_e1);
fprintf('%-15s %12.6f\n','k(-1),k(-1)',    a_kk);
fprintf('%-15s %12.6f\n','z(-1),k(-1)',    a_kz);
fprintf('%-15s %12.6f\n','z(-1),z(-1)',    a_zz);
fprintf('%-15s %12.6f\n','eps_z,eps_z',    b_ee);
fprintf('%-15s %12.6f\n','k(-1),eps_z',    c_ke);
fprintf('%-15s %12.6f\n','z(-1),eps_z',    c_ze);

fprintf('\n//////////////////////////////////////////////////////////////\n');
fprintf('//   END OF DYNARE POLICY FUNCTION FOR CAPITAL (k_t)       //\n');
fprintf('//////////////////////////////////////////////////////////////\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  EULER EQUATION ERRORS USING RECONSTRUCTED POLICY FUNCTIONS
%   (1st and 2nd order, based on Dynare "policy and transition" coeffs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1. Extract consumption policy coefficients (analogous to k_t)

% --- indices for c in declaration and DR order ---
idx_c_decl = strmatch('c', M_.endo_names, 'exact');
idx_c_dr   = dr.inv_order_var(idx_c_decl);

% --- steady state of consumption ---
c_ss = ys(idx_c_decl);

% --- first-order matrices for c_t ---
A1_c = dr.ghx(idx_c_dr,:);        % 1 x ns
B1_c = dr.ghu(idx_c_dr,:);        % 1 x ne (not really used here)

% --- second-order matrices for c_t (quadratic in state deviations) ---
A2_c_flat = squeeze(dr.ghxx(idx_c_dr,:,:));
A2_c      = reshape(A2_c_flat, ns, ns);

% --- mean correction for c ---
corr_c = dr.ghs2(idx_c_dr);

% We know from the k_t policy block that:
%  column 1 in ghx corresponds to k_hat(-1)
%  column 2 in ghx corresponds to z_hat(-1)
% so we mirror that here.

% ---- coefficients for c in deviations (hat variables) ----
a_ck1 = A1_c(1);              % coeff on \hat k_{t-1} in c_t
a_cz1 = A1_c(2);              % coeff on \hat z_{t-1} in c_t

a_ckk = 0.5 * A2_c(1,1);      % coeff on \hat k_{t-1}^2 in c_t
a_ckz =       A2_c(1,2);      % coeff on \hat k_{t-1}\hat z_{t-1} in c_t
a_czz = 0.5 * A2_c(2,2);      % coeff on \hat z_{t-1}^2 in c_t

%% 2. Set up grid and containers for Euler errors

Nk     = 1000;
k_min  = 0.5 * k_ss;
k_max  = 2.0 * k_ss;
k_grid = linspace(k_min, k_max, Nk);

EE_1st = zeros(1, Nk);   % Euler errors for 1st-order policy
EE_2nd = zeros(1, Nk);   % Euler errors for 2nd-order policy

% beta, alpha, delta are in the workspace from the .mod file.

%% 3. Loop over grid points

for i = 1:Nk
    
    % ------------ CURRENT STATE (LEVELS & DEVIATIONS) --------------
    k_t   = k_grid(i);           % level of capital today
    k_hat = k_t - k_ss;          % deviation from steady state
    z_hat = 0.0;                 % evaluate at z = z_ss = 0
    eps_t = 0.0;                 % diagnostic: no shock
    
    % ===============================================================
    % 1) FIRST-ORDER POLICY (linear in deviations, no correction)
    % ===============================================================
    % Today's consumption and next-period capital in deviations:
    c_hat_1  = a_ck1 * k_hat + a_cz1 * z_hat;  % but z_hat = 0 here
    k1_hat_1 = a_k1  * k_hat + a_z1  * z_hat;  % z_hat = 0
    
    % Convert to levels:
    c_t_1   = c_ss + c_hat_1;
    k_tp1_1 = k_ss + k1_hat_1;
    
    % Next-period state (again at z_{t+1} = 0, eps_{t+1} = 0):
    k_hat_tp1_1 = k_tp1_1 - k_ss;
    z_hat_tp1_1 = 0.0;
    
    % Next-period consumption from 1st-order policy:
    c1_hat_1 = a_ck1 * k_hat_tp1_1 + a_cz1 * z_hat_tp1_1;
    c_tp1_1  = c_ss + c1_hat_1;
    
    % Euler equation residual for 1st-order policy:
    EE_1st(i) = 1 / c_t_1 ...
        - beta * (alpha * exp(0) * k_tp1_1^(alpha-1) + (1-delta)) / c_tp1_1;
    
    % ===============================================================
    % 2) SECOND-ORDER POLICY (quadratic in deviations + correction)
    % ===============================================================
    % Today's consumption and next-period capital in deviations:
    c_hat_2 = ...
          a_ck1 * k_hat ...
        + a_cz1 * z_hat ...
        + a_ckk * k_hat^2 ...
        + a_ckz * k_hat * z_hat ...
        + a_czz * z_hat^2 ...
        + 0.5 * corr_c;
    
    k1_hat_2 = ...
          a_k1  * k_hat ...
        + a_z1  * z_hat ...
        + a_kk  * k_hat^2 ...
        + a_kz  * k_hat * z_hat ...
        + a_zz  * z_hat^2 ...
        + 0.5 * corr_k;
    
    % Convert to levels:
    c_t_2   = c_ss + c_hat_2;
    k_tp1_2 = k_ss + k1_hat_2;
    
    % Next-period state deviations (2nd-order policy, z_{t+1} = 0):
    k_hat_tp1_2 = k_tp1_2 - k_ss;
    z_hat_tp1_2 = 0.0;
    
    % Next-period consumption, 2nd-order rule:
    c1_hat_2 = ...
          a_ck1 * k_hat_tp1_2 ...
        + a_cz1 * z_hat_tp1_2 ...
        + a_ckk * k_hat_tp1_2^2 ...
        + a_ckz * k_hat_tp1_2 * z_hat_tp1_2 ...
        + a_czz * z_hat_tp1_2^2 ...
        + 0.5 * corr_c;
    
    c_tp1_2 = c_ss + c1_hat_2;
    
    % Euler equation residual for 2nd-order policy:
    EE_2nd(i) = 1 / c_t_2 ...
        - beta * (alpha * exp(0) * k_tp1_2^(alpha-1) + (1-delta)) / c_tp1_2;
    
end

%% ================================================================
%  Store Euler errors and plot comparison (1st vs 2nd order)
% ================================================================
create_plot =1;
% Collect results in struct EEE
if ~exist('EEE','var')
    EEE = struct();
end

if delta == 0.1
    EEE.dynare_01.EE1   = EE_1st;
    EEE.dynare_01.EE2   = EE_2nd;
    EEE.dynare_01.kgrid = k_grid;
elseif delta == 1
    EEE.dynare_1.EE1   = EE_1st;
    EEE.dynare_1.EE2   = EE_2nd;
    EEE.dynare_1.kgrid = k_grid;
end

% Create output folder
outdir = 'output Dynare';
if ~exist(outdir, 'dir')
    mkdir(outdir);
end

save(fullfile(outdir, 'EEE_results.mat'), 'EEE');

% ================================================================
%  Plot results
% ================================================================
if create_plot == 1
    % Load only EEE (no dynare_results needed for this figure)
    load(fullfile(outdir, 'EEE_results.mat'), 'EEE');

    % ---- Euler error comparison figure ----
    figure('Units','inches','Position',[1 1 8 10]);

        % delta = 0.1
        subplot(2,1,1);
        plot(EEE.dynare_01.kgrid, log10(abs(EEE.dynare_01.EE1)), 'LineWidth', 1.4); hold on;
        plot(EEE.dynare_01.kgrid, log10(abs(EEE.dynare_01.EE2)), '--', 'LineWidth', 1.4);
        xlabel('k_t');
        ylabel('log_{10} |EE|');
        title('Euler errors, \delta = 0.1');
        legend('1st order','2nd order','Location','best');
        grid on;

        % delta = 1
        subplot(2,1,2);
        plot(EEE.dynare_1.kgrid, log10(abs(EEE.dynare_1.EE1)), 'LineWidth', 1.4); hold on;
        plot(EEE.dynare_1.kgrid, log10(abs(EEE.dynare_1.EE2)), '--', 'LineWidth', 1.4);
        xlabel('k_t');
        ylabel('log_{10} |EE|');
        title('Euler errors, \delta = 1');
        legend('1st order','2nd order','Location','best');
        grid on;

    % Save comparison figure
    savefig(fullfile(outdir, 'EEE_compare.fig'));
    saveas(gcf, fullfile(outdir, 'EEE_compare_dynare.png'));
end
