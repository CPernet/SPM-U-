% test bids processing pipeline on SPM's MOAE single subject dataset

%% update path

% in case spmup was not added to the path
location = fullfile(pwd, '..');
addpath(fullfile(location, 'adaptative_threshold'), ...
        fullfile(location, 'bids'), ...
        fullfile(location, 'external'), ...
        fullfile(location, 'hrf'), ...
        fullfile(location, 'plot'), ...
        fullfile(location, 'QA'), ...
        fullfile(location, 'utilities'));

%% get data with bids-matlab

if isempty(which('bids.util.download_ds'))
    if ~isfolder(fullfile(pwd, 'bids-matlab)'))
        system('git clone --branch dev https://github.com/bids-standard/bids-matlab.git');
    end
    addpath(fullfile(pwd, 'bids-matlab'));
end

output_dir = bids.util.download_ds('source', 'spm', ...
                                   'demo', 'moae', ...
                                   'out_path', fullfile(pwd, 'demos'), ...
                                   'force', false, ...
                                   'verbose', true, ...
                                   'delete_previous', false);

%%
BIDS_dir = fullfile(pwd, 'demos');

options = spmup_getoptions(BIDS_dir);

% set how many cores to use or don't and it uses N-1;
options.Ncores = 1;

% depends what you have, used for multispectral segmentation
options.anat = {'T1w'};
options.task = {'auditory'};

[BIDS, subjects] = spmup_BIDS_unpack(BIDS_dir, options);

% on servers you often need to do that as matlab messes up permissions
% system(['chmod -Rf 755 ' options.outdir])

[subjects, opt] = run_spmup_bids(BIDS, subjects, options);
