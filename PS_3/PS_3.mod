//////////////////////////////////////////
//   STOCHASTIC NCG: QUADRATIC APPROX   //
//////////////////////////////////////////

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

var c k z;              // endogenous
varexo eps_z;           // shock

parameters beta alpha delta rho_z sigma_z;
parameters k_ss c_ss y_ss;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------

beta   = 0.99;
alpha  = 0.33;

% run twice: delta = 0.1 and delta = 1
delta  = 0.1;

rho_z   = 0.95;
sigma_z = 0.01;

%----------------------------------------------------------------
% 3. Non-stochastic steady state (z = 0)
%----------------------------------------------------------------

k_ss = ((1 - beta * (1 - delta))/(alpha*beta))^(1/(alpha - 1));
y_ss = k_ss^alpha;
c_ss = y_ss - delta*k_ss;

%----------------------------------------------------------------
% 4. Model (non-linear, for 2nd order approximation)
%----------------------------------------------------------------

model;
    1/c = beta * ( (alpha*exp(z(+1))*k(+1)^(alpha-1) + (1-delta)) / c(+1) ); 
    c + k = exp(z)*k(-1)^alpha + (1-delta)*k(-1); %% Resource constraint:
    z = rho_z*z(-1) + sigma_z*eps_z; % AR(1) technology:
end;

%----------------------------------------------------------------
% 5. Initial values & steady state
%----------------------------------------------------------------

initval;
    k = k_ss;
    c = c_ss;
    z = 0;
end;

steady;
check;

%----------------------------------------------------------------
% 6. Shocks
%----------------------------------------------------------------

shocks;
    var eps_z; stderr 1;   // eps_z ~ N(0,1)
end;

%----------------------------------------------------------------
% 7. Simulation: 2nd-order (quadratic) approximation
%----------------------------------------------------------------

set_dynare_seed(12345);
stoch_simul(order=1, irf=0, periods=200, drop=0, nograph);

%----------------------------------------------------------------
% 8. Euler errors along simulated path
%----------------------------------------------------------------

    idx_c = strmatch('c', M_.endo_names, 'exact');
    idx_k = strmatch('k', M_.endo_names, 'exact');
    idx_z = strmatch('z', M_.endo_names, 'exact');

    c_sim = oo_.endo_simul(idx_c, :);
    k_sim = oo_.endo_simul(idx_k, :);
    z_sim = oo_.endo_simul(idx_z, :);

    T = length(c_sim);
    EE = zeros(1, T-1);

    for t = 1:(T-1)
        c_t   = c_sim(t);
        c_tp1 = c_sim(t+1);
        k_tp1 = k_sim(t+1);
        z_tp1 = z_sim(t+1);

        EE(t) = 1/c_t ...
            - beta * ( (alpha*exp(z_tp1)*k_tp1^(alpha-1) + (1-delta)) / c_tp1 );
    end

    max_EE  = max(abs(EE));
    mean_EE = mean(abs(EE));

    disp('--------------------------------------------');
    disp(['Delta = ', num2str(delta)]);
    disp('Euler errors (levels):');
    disp(['  max  |EE_t| = ', num2str(max_EE)]);
    disp(['  mean |EE_t| = ', num2str(mean_EE)]);
    disp('--------------------------------------------');

    EE_c      = c_sim(1:end-1) .* EE;
    max_EE_c  = max(abs(EE_c));
    mean_EE_c = mean(abs(EE_c));
    disp('Euler errors in units of consumption:');
    disp(['  max  |c_t * EE_t| = ', num2str(max_EE_c)]);
    disp(['  mean |c_t * EE_t| = ', num2str(mean_EE_c)]);
    disp('--------------------------------------------');

    k_name = ['k_path_delta_', strrep(num2str(delta), '.', '_')];
    assignin('base', k_name, k_sim);

    % 1. Find the index of capital in the list of endogenous variables
    idx_k = strmatch('k', M_.endo_names, 'exact');
    
    % 2. Extract the simulated path of k_t
    k_sim = oo_.endo_simul(idx_k, :);   % row vector
    T     = length(k_sim);
    
    % 3. Plot it
    figure;
    plot(1:T, k_sim);
    xlabel('Time');
    ylabel('Capital k_t');
    title('Simulated path of capital');
    grid on;
    
    % For USE in python
    save('z_sim.mat', 'z_sim')

