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
wing_xloc = geom.wing.nose2LE;
wing = aircraft.geom.wing;

% Fuselage
fus_d = geom.fuselage.diam_fuselage;
fus_l = geom.fuselage.lf;

% Horz Tail
htail_xloc = geom.horztail.Lh + wing_xloc;
htail = aircraft.geom.horztail;

% Vert Tail
vtail_xloc = geom.verttail.Lv + wing_xloc;
vtail = aircraft.geom.verttail;



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

fprintf(fid,'    SetParmVal(wing_id, "X_Rel_Location", "XForm", %f);\n', wing_xloc);
fprintf(fid,'    SetParmVal(wing_id, "ThickChord", "XSecCurve_0", %f);\n', wing.section(1).airfoil.tc);
fprintf(fid,'    SetParmVal(wing_id, "Camber", "XSecCurve_0", %f);\n', wing.section(1).airfoil.camber);
fprintf(fid,'    SetParmVal(wing_id, "CamberLoc", "XSecCurve_0", %f);\n', wing.section(1).airfoil.camberLoc);

if aircraft.geom.wing.sections >= 1
fprintf(fid,'    SetParmVal(wing_id, "Span", "XSec_1", %f);\n', wing.y(2));
fprintf(fid,'    SetParmVal(wing_id, "Root_Chord", "XSec_1", %f);\n', wing.c(1));
fprintf(fid,'    SetParmVal(wing_id, "Tip_Chord", "XSec_1", %f);\n', wing.c(2));
fprintf(fid,'    SetParmVal(wing_id, "Sweep", "XSec_1", %f);\n', wing.section(1).sweep);
end

if aircraft.geom.wing.sections >= 2
fprintf(fid,'    InsertXSec( wing_id, 1, XS_FOUR_SERIES );\n');
fprintf(fid,'    Update();\n');
fprintf(fid,'    SetParmVal(wing_id, "Span", "XSec_2", %f);\n', wing.y(3));
fprintf(fid,'    SetParmVal(wing_id, "Root_Chord", "XSec_2", %f);\n', wing.c(2));
fprintf(fid,'    SetParmVal(wing_id, "Tip_Chord", "XSec_2", %f);\n', wing.c(3));
fprintf(fid,'    SetParmVal(wing_id, "Sweep", "XSec_2", %f);\n', wing.section(2).sweep);
end

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

fprintf(fid,'    SetParmVal(htail_id, "X_Rel_Location", "XForm", %f);\n', htail_xloc);
fprintf(fid,'    SetParmVal(htail_id, "ThickChord", "XSecCurve_0", %f);\n', htail.section(1).airfoil.tc);
if aircraft.geom.horztail.sections >= 1
fprintf(fid,'    SetParmVal(htail_id, "Span", "XSec_1", %f);\n', htail.y(2));
fprintf(fid,'    SetParmVal(htail_id, "Root_Chord", "XSec_1", %f);\n', htail.c(1));
fprintf(fid,'    SetParmVal(htail_id, "Tip_Chord", "XSec_1", %f);\n', htail.c(2));
fprintf(fid,'    SetParmVal(htail_id, "Sweep", "XSec_1", %f);\n', htail.section(1).sweep);
end
fprintf(fid,'    Update();\n');


% Set Vert Tail
fprintf(fid,'    string vtail_id = AddGeom("WING");\n');
fprintf(fid,'    SetGeomName(vtail_id,"VerticalTail");\n');
fprintf(fid,'    Update();\n');

fprintf(fid,'    SetParmVal(vtail_id, "X_Rel_Location", "XForm", %f);\n', vtail_xloc);
fprintf(fid,'    SetParmVal(vtail_id, "X_Rel_Rotation","XForm",90);\n');
fprintf(fid,'    SetParmVal(vtail_id, "ThickChord", "XSecCurve_0", %f);\n', vtail.section(1).airfoil.tc);
if aircraft.geom.verttail.sections >= 1
fprintf(fid,'    SetParmVal(vtail_id, "Span", "XSec_1", %f);\n', vtail.y(2));
fprintf(fid,'    SetParmVal(vtail_id, "Root_Chord", "XSec_1", %f);\n', vtail.c(1));
fprintf(fid,'    SetParmVal(vtail_id, "Tip_Chord", "XSec_1", %f);\n', vtail.c(2));
fprintf(fid,'    SetParmVal(vtail_id, "Sweep", "XSec_1", %f);\n', vtail.section(1).sweep);
end
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