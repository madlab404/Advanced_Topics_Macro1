%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

if isoctave || matlab_ver_less_than('8.6')
    clear all
else
    clearvars -global
    clear_persistent_variables(fileparts(which('dynare')), false)
end
tic0 = tic;
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'PS_3';
M_.dynare_version = '5.4';
oo_.dynare_version = '5.4';
options_.dynare_version = '5.4';
%
% Some global variables initialization
%
global_initialization;
M_.exo_names = cell(1,1);
M_.exo_names_tex = cell(1,1);
M_.exo_names_long = cell(1,1);
M_.exo_names(1) = {'eps_z'};
M_.exo_names_tex(1) = {'eps\_z'};
M_.exo_names_long(1) = {'eps_z'};
M_.endo_names = cell(3,1);
M_.endo_names_tex = cell(3,1);
M_.endo_names_long = cell(3,1);
M_.endo_names(1) = {'c'};
M_.endo_names_tex(1) = {'c'};
M_.endo_names_long(1) = {'c'};
M_.endo_names(2) = {'k'};
M_.endo_names_tex(2) = {'k'};
M_.endo_names_long(2) = {'k'};
M_.endo_names(3) = {'z'};
M_.endo_names_tex(3) = {'z'};
M_.endo_names_long(3) = {'z'};
M_.endo_partitions = struct();
M_.param_names = cell(8,1);
M_.param_names_tex = cell(8,1);
M_.param_names_long = cell(8,1);
M_.param_names(1) = {'beta'};
M_.param_names_tex(1) = {'beta'};
M_.param_names_long(1) = {'beta'};
M_.param_names(2) = {'alpha'};
M_.param_names_tex(2) = {'alpha'};
M_.param_names_long(2) = {'alpha'};
M_.param_names(3) = {'delta'};
M_.param_names_tex(3) = {'delta'};
M_.param_names_long(3) = {'delta'};
M_.param_names(4) = {'rho_z'};
M_.param_names_tex(4) = {'rho\_z'};
M_.param_names_long(4) = {'rho_z'};
M_.param_names(5) = {'sigma_z'};
M_.param_names_tex(5) = {'sigma\_z'};
M_.param_names_long(5) = {'sigma_z'};
M_.param_names(6) = {'k_ss'};
M_.param_names_tex(6) = {'k\_ss'};
M_.param_names_long(6) = {'k_ss'};
M_.param_names(7) = {'c_ss'};
M_.param_names_tex(7) = {'c\_ss'};
M_.param_names_long(7) = {'c_ss'};
M_.param_names(8) = {'y_ss'};
M_.param_names_tex(8) = {'y\_ss'};
M_.param_names_long(8) = {'y_ss'};
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 1;
M_.endo_nbr = 3;
M_.param_nbr = 8;
M_.orig_endo_nbr = 3;
M_.aux_vars = [];
M_ = setup_solvers(M_);
M_.Sigma_e = zeros(1, 1);
M_.Correlation_matrix = eye(1, 1);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = true;
M_.det_shocks = [];
M_.surprise_shocks = [];
M_.heteroskedastic_shocks.Qvalue_orig = [];
M_.heteroskedastic_shocks.Qscale_orig = [];
options_.linear = false;
options_.block = false;
options_.bytecode = false;
options_.use_dll = false;
M_.nonzero_hessian_eqs = [1 2];
M_.hessian_eq_zero = isempty(M_.nonzero_hessian_eqs);
M_.orig_eq_nbr = 3;
M_.eq_nbr = 3;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./+' M_.fname '/set_auxiliary_variables.m'], 'file') == 2;
M_.epilogue_names = {};
M_.epilogue_var_list_ = {};
M_.orig_maximum_endo_lag = 1;
M_.orig_maximum_endo_lead = 1;
M_.orig_maximum_exo_lag = 0;
M_.orig_maximum_exo_lead = 0;
M_.orig_maximum_exo_det_lag = 0;
M_.orig_maximum_exo_det_lead = 0;
M_.orig_maximum_lag = 1;
M_.orig_maximum_lead = 1;
M_.orig_maximum_lag_with_diffs_expanded = 1;
M_.lead_lag_incidence = [
 0 3 6;
 1 4 7;
 2 5 8;]';
M_.nstatic = 0;
M_.nfwrd   = 1;
M_.npred   = 0;
M_.nboth   = 2;
M_.nsfwrd   = 3;
M_.nspred   = 2;
M_.ndynamic   = 3;
M_.dynamic_tmp_nbr = [3; 2; 0; 0; ];
M_.model_local_variables_dynamic_tt_idxs = {
};
M_.equations_tags = {
  1 , 'name' , '1' ;
  2 , 'name' , '2' ;
  3 , 'name' , 'z' ;
};
M_.mapping.c.eqidx = [1 2 ];
M_.mapping.k.eqidx = [1 2 ];
M_.mapping.z.eqidx = [1 2 3 ];
M_.mapping.eps_z.eqidx = [3 ];
M_.static_and_dynamic_models_differ = false;
M_.has_external_function = false;
M_.state_var = [2 3 ];
M_.exo_names_orig_ord = [1:1];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(3, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(1, 1);
M_.params = NaN(8, 1);
M_.endo_trends = struct('deflator', cell(3, 1), 'log_deflator', cell(3, 1), 'growth_factor', cell(3, 1), 'log_growth_factor', cell(3, 1));
M_.NNZDerivatives = [11; 14; -1; ];
M_.static_tmp_nbr = [3; 0; 0; 0; ];
M_.model_local_variables_static_tt_idxs = {
};
M_.params(1) = 0.99;
beta = M_.params(1);
M_.params(2) = 0.33;
alpha = M_.params(2);
M_.params(3) = 0.1;
delta = M_.params(3);
M_.params(4) = 0.95;
rho_z = M_.params(4);
M_.params(5) = 0.01;
sigma_z = M_.params(5);
M_.params(6) = ((1-M_.params(1)*(1-M_.params(3)))/(M_.params(1)*M_.params(2)))^(1/(M_.params(2)-1));
k_ss = M_.params(6);
M_.params(8) = M_.params(6)^M_.params(2);
y_ss = M_.params(8);
M_.params(7) = M_.params(8)-M_.params(3)*M_.params(6);
c_ss = M_.params(7);
%
% INITVAL instructions
%
options_.initval_file = false;
oo_.steady_state(2) = M_.params(6);
oo_.steady_state(1) = M_.params(7);
oo_.steady_state(3) = 0;
if M_.exo_nbr > 0
	oo_.exo_simul = ones(M_.maximum_lag,1)*oo_.exo_steady_state';
end
if M_.exo_det_nbr > 0
	oo_.exo_det_simul = ones(M_.maximum_lag,1)*oo_.exo_det_steady_state';
end
steady;
oo_.dr.eigval = check(M_,options_,oo_);
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = (1)^2;
set_dynare_seed(12345);
options_.drop = 0;
options_.irf = 0;
options_.nograph = true;
options_.order = 2;
options_.periods = 200;
var_list_ = {};
[info, oo_, options_, M_] = stoch_simul(M_, options_, oo_, var_list_);
k_name = ['k_path_delta_', strrep(num2str(delta), '.', '_')];
assignin('base', k_name, k_sim);
idx_k = strmatch('k', M_.endo_names, 'exact');
k_sim = oo_.endo_simul(idx_k, :);   
T     = length(k_sim);
if ~exist('dynare_results', 'var')
dynare_results = struct();
end
if delta == 0.1
dynare_results.dynare_01.k = k_sim;
dynare_results.dynare_01.T = T;
elseif delta == 1
dynare_results.dynare_1.k = k_sim;
dynare_results.dynare_1.T = T;
end
outdir = 'output Dynare';
if ~exist(outdir, 'dir')
mkdir(outdir);
end
save(fullfile(outdir, 'dynare_results.mat'), 'dynare_results');
create_plot = 1;
if create_plot == 1 
load(fullfile(outdir, 'dynare_results.mat'));  
figure('Units','inches','Position',[1 1 8 10]);
subplot(2,1,1);
plot(1:dynare_results.dynare_01.T, dynare_results.dynare_01.k);
xlabel('Time');
ylabel('k_t');
title('Capital, \delta = 0.1');
grid on;
subplot(2,1,2);
plot(1:dynare_results.dynare_1.T, dynare_results.dynare_1.k);
xlabel('Time');
ylabel('k_t');
title('Capital, \delta = 1');
grid on;
savefig(fullfile(outdir, 'capital_compare.fig'));
saveas(gcf, fullfile(outdir, 'capital_compare_dynare.png'));
end 
save('z_sim.mat', 'z_sim')
idx_c = dr.inv_order_var(strmatch('c', M_.endo_names, 'exact'));
idx_k = dr.inv_order_var(strmatch('k', M_.endo_names, 'exact'));
idx_z = dr.inv_order_var(strmatch('z', M_.endo_names, 'exact'));
state_pos = dr.kstate(:,1);   
ik = 1;                       
ieps = 1;                     
oo_.dr.ghx     
oo_.dr.ghu     
dr = oo_.dr;
idx_c = dr.inv_order_var(strmatch('c', M_.endo_names, 'exact'));
idx_k = dr.inv_order_var(strmatch('k', M_.endo_names, 'exact'));
idx_z = dr.inv_order_var(strmatch('z', M_.endo_names, 'exact'));
state_pos = dr.kstate(:,1);
shock_pos = 1:size(dr.ghu,2); 
A1 = dr.ghx;   
B1 = dr.ghu;   
A1_c = A1(idx_c,:);   
A1_k = A1(idx_k,:);   
A1_z = A1(idx_z,:);   
B1_c = B1(idx_c,:);   
B1_k = B1(idx_k,:);   
B1_z = B1(idx_z,:);   
A2 = dr.ghxx;   
B2 = dr.ghuu;   
C2 = dr.ghxu;   
A2_c = squeeze(A2(idx_c,:,:));   
B2_c = squeeze(B2(idx_c,:,:));   
C2_c = squeeze(C2(idx_c,:,:));   
A2_k = squeeze(A2(idx_k,:,:));
B2_k = squeeze(B2(idx_k,:,:));
C2_k = squeeze(C2(idx_k,:,:));
Nk     = 1000;
k_min  = 0.5 * k_ss;
k_max  = 2 * k_ss;
k_grid = linspace(k_min, k_max, Nk);
EE_1st = zeros(1, Nk);
EE_2nd = zeros(1, Nk);
corr_c = dr.ghs2(idx_c);
corr_k = dr.ghs2(idx_k);
for i = 1:Nk
k_t  = k_grid(i);
k_hat = log(k_t/k_ss);   
z_hat = 0;               
c_hat_1  = A1_c(ik) * k_hat;
k1_hat_1 = A1_k(ik) * k_hat;
c_t_1    = c_ss * exp(c_hat_1);
k_tp1_1  = k_ss * exp(k1_hat_1);
c1_hat_1 = A1_c(ik) * k1_hat_1;
c_tp1_1  = c_ss * exp(c1_hat_1);
EE_1st(i) = 1/c_t_1 - beta * (alpha*k_tp1_1^(alpha-1) + (1-delta))/c_tp1_1;
c_hat_2  = ...
             A1_c(ik)*k_hat ...
           + 0.5*A2_c(ik,ik)*k_hat^2 ...
           + corr_c;
k1_hat_2 = ...
             A1_k(ik)*k_hat ...
           + 0.5*A2_k(ik,ik)*k_hat^2 ...
           + corr_k;
c_t_2   = c_ss * exp(c_hat_2);
k_tp1_2 = k_ss * exp(k1_hat_2);
c1_hat_2 = ...
             A1_c(ik)*k1_hat_2 ...
           + 0.5*A2_c(ik,ik)*k1_hat_2^2 ...
           + corr_c;
c_tp1_2  = c_ss * exp(c1_hat_2);
EE_2nd(i) = 1/c_t_2 - beta * (alpha*k_tp1_2^(alpha-1) + (1-delta))/c_tp1_2;
end
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
outdir = 'output Dynare';
if ~exist(outdir, 'dir')
mkdir(outdir);
end
save(fullfile(outdir, 'dynare_results.mat'), 'dynare_results', 'EEE');
if create_plot == 1
load(fullfile(outdir, 'dynare_results.mat'));  
figure('Units','inches','Position',[1 1 8 10]);
subplot(2,1,1);
plot(EEE.dynare_01.kgrid, log10(abs(EEE.dynare_01.EE1)), 'LineWidth', 1.4); hold on;
plot(EEE.dynare_01.kgrid, log10(abs(EEE.dynare_01.EE2)), '--', 'LineWidth', 1.4);
xlabel('k_t');
ylabel('log_{10} |EE|');
title('Euler errors, \delta = 0.1');
legend('1st order','2nd order','Location','best');
grid on;
subplot(2,1,2);
plot(EEE.dynare_1.kgrid, log10(abs(EEE.dynare_1.EE1)), 'LineWidth', 1.4); hold on;
plot(EEE.dynare_1.kgrid, log10(abs(EEE.dynare_1.EE2)), '--', 'LineWidth', 1.4);
xlabel('k_t');
ylabel('log_{10} |EE|');
title('Euler errors, \delta = 1');
legend('1st order','2nd order','Location','best');
grid on;
savefig(fullfile(outdir, 'EEE_compare.fig'));
saveas(gcf, fullfile(outdir, 'EEE_compare_dynare.png'));
end


oo_.time = toc(tic0);
disp(['Total computing time : ' dynsec2hms(oo_.time) ]);
if ~exist([M_.dname filesep 'Output'],'dir')
    mkdir(M_.dname,'Output');
end
save([M_.dname filesep 'Output' filesep 'PS_3_results.mat'], 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'PS_3_results.mat'], 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'PS_3_results.mat'], 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'PS_3_results.mat'], 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'PS_3_results.mat'], 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'PS_3_results.mat'], 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save([M_.dname filesep 'Output' filesep 'PS_3_results.mat'], 'oo_recursive_', '-append');
end
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
