%% unit testing for spmup_realign_qa

close all

%% get data
test_data_folder = fullfile(test_folder(), 'data');

time_series = spm_select('FPlistRec', test_data_folder, '^sub.*bold.nii');

plot_figures = 'off';

%% 
new_files = spmup_realign_qa(time_series, ...
                        'Motion Parameters', 'off', ...
                        'Framewise displacement', 'off', ...
                        'Globals', 'off', ...
                        'Voltera', 'off', ...
                        'Movie', 'off', ...
                        'figure', plot_figures);
                      
assert(isempty(new_files))                      

%% Motion
new_files = spmup_realign_qa(time_series, ...
                        'Motion Parameters', 'on', ...
                        'Framewise displacement', 'off', ...
                        'Globals', 'off', ...
                        'Voltera', 'off', ...
                        'Movie', 'off', ...
                        'figure', plot_figures);

assert(isempty(new_files))  

%% FD
new_files = spmup_realign_qa(time_series, ...
                        'Motion Parameters', 'off', ...
                        'Framewise displacement', 'on', ...
                        'Globals', 'off', ...
                        'Voltera', 'off', ...
                        'Movie', 'off', ...
                        'figure', plot_figures);

% 6 motion + FD + RMS + 3 censoring regressors                      
motion_and_fd_censor = spm_load(new_files{1});
assert(size(motion_and_fd_censor, 2) == 11)

%% Voltera
new_files = spmup_realign_qa(time_series, ...
                        'Motion Parameters', 'off', ...
                        'Framewise displacement', 'off', ...
                        'Globals', 'off', ...
                        'Voltera', 'on', ...
                        'Movie', 'off', ...
                        'figure', plot_figures);

% 6 motion + their derivatives + square of each                    
voltera = spm_load(new_files{1});
assert(size(voltera, 2) == 24)
                      
%% Globals
new_files = spmup_realign_qa(time_series, ...
                            'Motion Parameters', 'off', ...
                            'Framewise displacement', 'off', ...
                            'Globals', 'on', ...
                            'Voltera', 'off', ...
                            'Movie', 'off', ...
                            'figure', plot_figures);

% 6 motion + one global regressor
globals = spm_load(new_files{1});
assert(size(globals, 2) == 7)

