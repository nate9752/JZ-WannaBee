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
fprintf('\n\n\nBeginning AeroVSP Simulations:\n');

% alphas = unique([-5:1:5 5:0.5:12]);
% mach = 0;


test.span = 3;
test.rootChord = 0.5;
test.tipChord = 0.5;
test.sweepDeg = 5;



%% writes geometries and vsp commands

writeVSPscript(vspName,test);   
command = sprintf('vsp -script "%s.vspscript"',vspName);
system(command);
pause(2);



%% Write aero input file and execute simulation

% % Might not need this
% % degenName = strcat(vspName, "_DegenGeom");
% writeVSPAeroScript(aircraft, vspName, alphas, mach);
% 
% command = sprintf('vspaero -omp 6 %s',vspName);
% system(command);
% pause(2);


%% Read Polar

command = strcat("rename ", vspName, ".polar ",vspName, ".polar.txt");
system(command);
pause(2);

% opts = detectImportOptions(strcat(vspName,'.polar.txt'),'FileType','text');
% opts.DataLines = [7 Inf];  % start reading at line 3
% opts.Delimiter = {' '};
% opts.VariableNamingRule = 'preserve';
filename = strcat(vspName,'.polar.txt');
lines = readlines(filename); 
lines(1:2) = [];
writelines(lines,filename);


data = readtable(strcat(vspName,".polar.txt"),'VariableNamingRule','preserve');



%% Data Extraction 

Cl = data{:,'CLtot'};
alpha = data{:,'AoA'};
Cdi = data{:,'CDi'};


% Package VSP Data
aircraft.aero.VSP.Cl = Cl;
aircraft.aero.VSP.alpha = alpha;
aircraft.aero.VSP.Cdi = Cdi;



%% Delete Everything Else

files = dir(fullfile(dir_vsp,[vspName '*']));

for k = 1:length(files)
    delete(fullfile(dir_vsp,files(k).name));
end
fclose('all');  % Close any open files
delete(fullfile(dir_vsp,'*.vspscript'));

cd(dir_main);



end