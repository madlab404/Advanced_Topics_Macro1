//////////////////////////////////////////
//   STOCHASTIC NCG: QUADRATIC APPROX   //
//////////////////////////////////////////
%addpath /Applications/Dynare/5.4/matlab/ 
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
stoch_simul(order=2, irf=0, periods=200, drop=0, nograph);


    