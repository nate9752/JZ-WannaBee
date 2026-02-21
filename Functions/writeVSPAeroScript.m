function  writeVSPAeroScript(aircraft, degenName, alphas, mach)
% writeVSPAeroscript(aircraft, degenName, 'none', alphas, mach)
%
%   - This function will use the generated geom file and specify the
%   conditions for VSP_aero to run its sims.
%
%%%

filename = strcat(degenName, '.vspaero');
scriptFileID = fullfile(pwd, filename);
fid = fopen(scriptFileID,'w');

fprintf(fid,'SolverType = 1 \n\n');   % <-- REQUIRED for polars
fprintf(fid,' Sref = 1.000000 \n');
fprintf(fid,' Cref = 1.000000 \n');
fprintf(fid,' Bref = 1.000000 \n');
fprintf(fid,' X_cg = 0.000000 \n');
fprintf(fid,' Y_cg = 0.000000 \n');
fprintf(fid,' Z_cg = 0.000000 \n');

% fprintf(fid,' Mach = %f \n', mach);
% fprintf(fid,' AoA =');
% 
% for i = 1:length(alphas)
%     if i < length(alphas)
%         fprintf(fid,' %f,',alphas(i));
%     else
%         fprintf(fid,' %f \n', alphas(i));
%     end
% end

fprintf(fid, ' MachStart = 0.0\n');
fprintf(fid, ' MachEnd = 0.0\n');
fprintf(fid, ' MachNpts = 1\n');
fprintf(fid, ' AlphaStart = 0\n');
fprintf(fid, ' AlphaEnd = 6\n');
fprintf(fid, ' AlphaNpts = 7\n');




fprintf(fid, 'Beta = 0.000000 \n');
% fprintf(fid, 'Vinf = 0.000000 \n');
fprintf(fid, 'Rho = 0.002377 \n');
% fprintf(fid, 'ReCref = 0.000000 \n');
fprintf(fid, 'ClMax = -1.000000 \n');
fprintf(fid, 'MaxTurningAngle = -1.000000 \n');
fprintf(fid, 'Symmetry = Y \n');
fprintf(fid, 'FarDist = -1.000000 \n');
fprintf(fid, 'NumWakeNodes = 64 \n');
fprintf(fid, 'WakeIters = 5 \n');

fprintf(fid, 'Preconditioner = Matrix \n');
fprintf(fid, 'Karman-Tsien Correction = N \n');
fprintf(fid, 'Stability Type = 0 \n');
fprintf(fid, 'NumberOfQuadTrees = 7 \n');

fclose(fid);

end