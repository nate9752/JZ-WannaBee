function aircraft = runVSP(aircraft)
% aircraft = runVSP(aircraft)
%
%   - This script will use system calls and design file manipulation to run
%   OpenVSP on a new custom geometry to determine the aero properties of a
%   new design. 
%
%
%  Guide to Running VSP on new Geometry:
%
%   - 
%

%% Locate Files and Initialize

dir_vsp = fullfile(pwd,'OpenVSP-3.46.0-win64');
dir_main = pwd;
vspName = aircraft.name;

cd(dir_vsp);

alphas = unique([-5:1:5 5:0.5:12]);
mach = 0;


test.span = 1.6;
test.rootChord = 0.25;
test.tipChord = 0.12;
test.sweepDeg = 5;



%% writes geometries and vsp commands

writeVSPscript(vspName,test);   
command = sprintf('vsp -script "%s.vspscript"',vspName);
system(command);



%% Write aero input file and execute simulation

degenName = strcat(vspName, "_DegenGeom");
writeVSPAeroScript(aircraft, degenName, alphas, mach);

command = sprintf('vspaero -omp 6 %s',degenName);
system(command);


%% Read Polar

command = strcat("rename ", vspName, ".polar ",vspName, ".polar.txt");
system(command);

opts = detectImportOptions(strcat(vspName,'.polar.txt'),'FileType','text');
opts.DataLines = [3 Inf];  % start reading at line 3
opts.Delimiter = {' '};
opts.VariableNamingRule = 'preserve';
data = readtable(strcat(vspName,".polar.txt"),opts);



%% Delete Everything Else
files = dir(fullfile(dir_vsp,[vspName '*']));

for k = 1:length(files)
    delete(fullfile(dir_vsp,files(k).name));
end




end