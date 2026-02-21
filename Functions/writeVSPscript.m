function  writeVSPscript(filename,geom)
% writeVSPscript(filename,aircraft)
%
%   - This function will use the generated geom features from sizing and
%   build a geom file for openVSP to run.
%
%%%

if exist([filename '.vspscript'],'file')
    delete([filename '.vspscript']);
end

fid = fopen(strcat(filename,'.vspscript'),'w');

fprintf(fid,'// Auto-generated OpenVSP script\n');
fprintf(fid,'void main()\n');
fprintf(fid,'{\n');

% Clear model
fprintf(fid,'    ClearVSPModel();\n');

% Add wing
fprintf(fid,'    string wing_id = AddGeom("WING");\n');
fprintf(fid,'    Update();\n');

% Set parameters
fprintf(fid,'    SetParmVal(wing_id, "TotalSpan", "WingGeom", %f);\n', geom.span);
fprintf(fid,'    SetParmVal(wing_id, "Root_Chord", "XSec_1", %f);\n', geom.rootChord);
fprintf(fid,'    SetParmVal(wing_id, "Tip_Chord", "XSec_1", %f);\n', geom.tipChord);
fprintf(fid,'    SetParmVal(wing_id, "Sweep", "XSec_1", %f);\n', geom.sweepDeg);

fprintf(fid,'    Update();\n');

% Save geometry
fprintf(fid,'    string final = "%s.vsp3";\n',filename);
fprintf(fid,'    WriteVSPFile(final, SET_ALL);\n');   % not sure about SET_ALL


% To be used in aero input file
fprintf(fid,'    string analysis_name;\n');
fprintf(fid,'    analysis_name = "VSPAEROComputeGeometry";\n');
fprintf(fid,'    ExecAnalysis(analysis_name);\n');



% //==== Run VSPAERO Sweep ====//
fprintf(fid,'analysis_name = "VSPAEROSweep";\n');


% Reset defaults
fprintf(fid,'SetAnalysisInputDefaults(analysis_name);\n');


% Use all geometries
fprintf(fid,'array<int> geom_set;\n');
fprintf(fid,'geom_set.push_back(SET_ALL);\n');
fprintf(fid,'SetIntAnalysisInput(analysis_name, "GeomSet", geom_set);\n');

% Use wing as reference
fprintf(fid,'array<int> ref_flag;\n');
fprintf(fid,'ref_flag.push_back(1);\n');
fprintf(fid,'SetIntAnalysisInput(analysis_name, "RefFlag", ref_flag);\n');

fprintf(fid,'array<string> wid = FindGeomsWithName("WingGeom");\n');
fprintf(fid,'SetStringAnalysisInput(analysis_name, "WingID", wid);\n');

% AoA sweep
fprintf(fid,'array<double> alpha_start; alpha_start.push_back(-5.0);\n');
fprintf(fid,'SetDoubleAnalysisInput(analysis_name, "AlphaStart", alpha_start);\n');

fprintf(fid,'array<double> alpha_end; alpha_end.push_back(10);\n');
fprintf(fid,'SetDoubleAnalysisInput(analysis_name, "AlphaEnd", alpha_end);\n');

fprintf(fid,'array<int> alpha_pts; alpha_pts.push_back(16);\n');
fprintf(fid,'SetIntAnalysisInput(analysis_name, "AlphaNpts", alpha_pts);\n');

% Mach
fprintf(fid,'array<double> mach; mach.push_back(0.2);\n');
fprintf(fid,'SetDoubleAnalysisInput(analysis_name, "MachStart", mach);\n');
fprintf(fid,'array<int> machN; machN.push_back(1);\n');
fprintf(fid,'SetIntAnalysisInput(analysis_name, "MachNpts", machN);\n');
fprintf(fid,'Update();\n');

% Execute solver
fprintf(fid,'ExecAnalysis(analysis_name);\n');


fprintf(fid,'}\n');


fclose(fid);

end