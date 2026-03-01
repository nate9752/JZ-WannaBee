function  writeVSPscript(filename,aircraft)
% writeVSPscript(filename,aircraft)
%
%   - This function will use the generated geom features from sizing and
%   build a geom file for openVSP to run.
%
%%%

%% Load Aircraft Geom Data

geom = aircraft.geom;

% Wing
wing_b = geom.wing.b;
wing_cr = geom.wing.cr;
wing_ct = geom.wing.ct;
wing_L = geom.wing.Lam_w;
wing_tc = geom.wing.tc_w;
wing_xloc = geom.wing.nose2LE;

% Fuselage
fus_d = geom.fuselage.diam_fuselage;
fus_l = geom.fuselage.lf;

% Horz Tail
htail_b = geom.horztail.span;
htail_cr = geom.horztail.rootchord;
htail_ct = geom.horztail.tipchord;
htail_L = geom.horztail.Lam_ht;
htail_tc = geom.horztail.tc_ht;
htail_xloc = geom.horztail.Lh + wing_xloc;

% Vert Tail
vtail_b = geom.verttail.span;
vtail_cr = geom.verttail.rootchord;
vtail_ct = geom.verttail.tipchord;
vtail_L = geom.verttail.Lam_vt;
vtail_tc = geom.verttail.tc_vt;
vtail_xloc = geom.verttail.Lv + wing_xloc;



%% Write VSP File

if exist([filename '.vspscript'],'file')
    delete([filename '.vspscript']);
end

fid = fopen(strcat(filename,'.vspscript'),'w');

fprintf(fid,'// Auto-generated OpenVSP script\n');
fprintf(fid,'void main()\n');
fprintf(fid,'{\n');

% Clear model
fprintf(fid,'    ClearVSPModel();\n');

% Set Wing Params
fprintf(fid,'    string wing_id = AddGeom("WING");\n');
fprintf(fid,'    SetGeomName(wing_id,"WING");\n');
fprintf(fid,'    Update();\n');
fprintf(fid,'    SetParmVal(wing_id, "TotalSpan", "WingGeom", %f);\n', wing_b);
fprintf(fid,'    SetParmVal(wing_id, "Root_Chord", "XSec_1", %f);\n', wing_cr);
fprintf(fid,'    SetParmVal(wing_id, "Tip_Chord", "XSec_1", %f);\n', wing_ct);
fprintf(fid,'    SetParmVal(wing_id, "Sweep", "XSec_1", %f);\n', wing_L);
fprintf(fid,'    SetParmVal(wing_id, "X_Rel_Location", "XForm", %f);\n', wing_xloc);
fprintf(fid,'    SetParmVal(wing_id, "ThickChord", "XSecCurve_0", %f);\n', wing_tc);
fprintf(fid,'    Update();\n');

% Set Fuselage
% fprintf(fid,'    string fus_id = AddGeom("POD");\n');
% fprintf(fid,'    SetGeomName(fus_id,"FUSELAGE");\n');
% fprintf(fid,'    Update();\n');
% fprintf(fid,'    SetParmVal(fus_id, "Length", "Design", %f);\n', fus_l);
% fprintf(fid,'    SetParmVal(fus_id, "FineRatio", "Design", %f);\n', fus_l/fus_d);
% fprintf(fid,'    Update();\n');

% Set Horz Tail
fprintf(fid,'    string htail_id = AddGeom("WING");\n');
fprintf(fid,'    SetGeomName(htail_id,"HorizontalTail");\n');
fprintf(fid,'    Update();\n');
fprintf(fid,'    SetParmVal(htail_id, "TotalSpan", "WingGeom", %f);\n', htail_b);
fprintf(fid,'    SetParmVal(htail_id, "Root_Chord", "XSec_1", %f);\n', htail_cr);
fprintf(fid,'    SetParmVal(htail_id, "Tip_Chord", "XSec_1", %f);\n', htail_ct);
fprintf(fid,'    SetParmVal(htail_id, "Sweep", "XSec_1", %f);\n', htail_L);
fprintf(fid,'    SetParmVal(htail_id, "X_Rel_Location", "XForm", %f);\n', htail_xloc);
fprintf(fid,'    SetParmVal(htail_id, "ThickChord", "XSecCurve_0", %f);\n', htail_tc);
fprintf(fid,'    Update();\n');

% Set Vert Tail
fprintf(fid,'    string vtail_id = AddGeom("WING");\n');
fprintf(fid,'    SetGeomName(vtail_id,"VerticalTail");\n');
fprintf(fid,'    Update();\n');
% fprintf(fid,'    SetParmVal(vtail_id, "Sym_Planar_Flag","XForm",0);\n');
fprintf(fid,'    SetParmVal(vtail_id, "TotalSpan", "WingGeom", %f);\n', vtail_b);
fprintf(fid,'    SetParmVal(vtail_id, "Root_Chord", "XSec_1", %f);\n', vtail_cr);
fprintf(fid,'    SetParmVal(vtail_id, "Tip_Chord", "XSec_1", %f);\n', vtail_ct);
fprintf(fid,'    SetParmVal(vtail_id, "Sweep", "XSec_1", %f);\n', vtail_L);
fprintf(fid,'    SetParmVal(vtail_id, "X_Rel_Location", "XForm", %f);\n', vtail_xloc);
fprintf(fid,'    SetParmVal(vtail_id, "X_Rel_Rotation","XForm",90);\n');
fprintf(fid,'    SetParmVal(vtail_id, "ThickChord", "XSecCurve_0", %f);\n', vtail_tc);
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


% Pick geometries
fprintf(fid,'array<int> geom_set;\n');
fprintf(fid,'geom_set.push_back(SET_ALL);\n');
fprintf(fid,'SetIntAnalysisInput(analysis_name, "GeomSet", geom_set);\n');


% Use wing as reference
fprintf(fid,'SetVSPAERORefWingID(wing_id);\n');

% fprintf(fid,'SetIntAnalysisInput(analysis_name, "UseRefGeom", 1);\n');
% fprintf(fid,'array<string> ref_geom;\n');
% fprintf(fid,'ref_geom.push_back("WING");\n');   % wing only
% fprintf(fid,'SetStringAnalysisInput(analysis_name, "RefGeom", ref_geom);\n');

% fprintf(fid,'array<int> ref_flag;\n');
% fprintf(fid,'ref_flag.push_back(1);\n');
% fprintf(fid,'ref_flag.push_back(0);\n');
% fprintf(fid,'ref_flag.push_back(0);\n');
% fprintf(fid,'SetIntAnalysisInput(analysis_name, "RefFlag", ref_flag);\n');
% fprintf(fid,'array<string> wid = FindGeomsWithName("WING");\n');
% fprintf(fid,'SetStringAnalysisInput(analysis_name, "WingID", wid);\n');




% AoA sweep
fprintf(fid,'array<double> alpha_start; alpha_start.push_back(-5.0);\n');
fprintf(fid,'SetDoubleAnalysisInput(analysis_name, "AlphaStart", alpha_start);\n');

fprintf(fid,'array<double> alpha_end; alpha_end.push_back(15);\n');
fprintf(fid,'SetDoubleAnalysisInput(analysis_name, "AlphaEnd", alpha_end);\n');

fprintf(fid,'array<int> alpha_pts; alpha_pts.push_back(21);\n');
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