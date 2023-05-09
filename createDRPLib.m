function drpLib = createDRPLib(posInfo, ang_res, options)
% this function requires MTEX package for generation of orientation library
    arguments
        posInfo (1,1) struct
        ang_res (1,1) double 
        options.verbose (1,1) logical = 1
        options.crystalSymmetry (1,:) string = 'cubic'
        options.faceting (1,3) double = [1, 0, 0]
        options.fitting_para (1,6) double = [4,1,12,3,3,6]
    end
    cs = crystalSymmetry(options.crystalSymmetry);
    ori = equispacedSO3Grid(cs,'resolution',ang_res);
    nn = length(ori.phi1);
    drpLib.drpList = zeros(nn,length(posInfo.phi));
    drpLib.eulerList = zeros(nn,3);
    for ii = 1:nn
        eulerAngle = [ori(ii).phi1, ori(ii).Phi, ori(ii).phi2]./degree;
        drpLib.drpList(ii,:) = drpSimCone(posInfo, eulerAngle, options.faceting, options.fitting_para);
        drpLib.eulerList(ii,:) = eulerAngle;  % in degree
        if options.verbose
            workbar(ii/nn,sprintf("processing %d / %d DRPs",[ii nn]));
        end
    end
end