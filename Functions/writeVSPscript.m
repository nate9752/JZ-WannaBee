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

% Set parameters
fprintf(fid,'    SetParmVal(wing_id, "Span", "WingGeom", %f);\n', geom.span);
fprintf(fid,'    SetParmVal(wing_id, "Root_Chord", "XSec_1", %f);\n', geom.rootChord);
fprintf(fid,'    SetParmVal(wing_id, "Tip_Chord", "XSec_1", %f);\n', geom.tipChord);
fprintf(fid,'    SetParmVal(wing_id, "Sweep", "XSec_1", %f);\n', geom.sweepDeg);

fprintf(fid,'    Update();\n');

% Save geometry
fprintf(fid,'    string final = "%s.vsp3";\n',filename);
fprintf(fid,'    WriteVSPFile(final, SET_ALL);\n');   % not sure about SET_ALL

% fprintf(fid,'    SetComputationalFileName(DEGEN_GEOM_CSV_TYPE,"%s_DegenGeom.csv");\n',filename);
% fprintf(fid,'    ComputeDegenGeom( SET_ALL, DEGEN_GEOM_CSV_TYPE );\n\n');
% fprintf(fid,'    ComputeCompGeom( SET_ALL, false, 0);\n');


% % TO be used in aero input file
% fprintf(fid,'    string analysis_name;\n');
% fprintf(fid,'    analysis_name = "VSPAEROComputeGeometry";\n');
% fprintf(fid,'    ExecAnalysis(analysis_name);\n');
% 
% fprintf(fid,'    analysis_name = "VSPAEROSweep";\n');
% fprintf(fid,'    SetDoubleAnalysisInput(analysis_name, "AlphaStart", { -5.0 });\n');
% fprintf(fid,'    SetDoubleAnalysisInput(analysis_name, "AlphaEnd", { 5.0 });\n');
% fprintf(fid,'    SetIntAnalysisInput(analysis_name, "AlphaNpts", { 18 });\n');
% fprintf(fid,'    ExecAnalysis(analysis_name);\n');

fprintf(fid,'}\n');


fclose(fid);

end