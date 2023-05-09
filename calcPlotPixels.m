function plotPara = calcPlotPixels(posInfo,options)
    arguments
        posInfo
        options.resNum (1,1) double = 20
    end
    nn = length(posInfo.phi);
    theta_list_original = sort(unique(posInfo.theta),'ascend');
    theta_list = zeros(1,length(theta_list_original)+1);
    for ii = 1:length(theta_list_original)
        if theta_list_original(ii) <= 70
            theta_list(ii) = theta_list_original(ii);
        else
            theta_list(ii) = (theta_list_original(ii) + theta_list_original(ii-1)) / 2;
        end
    end
    theta_list(end) = 90;
    resNum = options.resNum;
    patchPoints = zeros(2*resNum,3,nn);
    for ii = 1:nn
        % datapoints in the lower range
        if posInfo.theta(ii) <= 70
            phi_temp = [posInfo.phi(ii)-5; posInfo.phi(ii)+5; posInfo.phi(ii)+5; posInfo.phi(ii)-5];
            kk = find(theta_list_original == posInfo.theta(ii));
            theta_temp = [theta_list(kk); theta_list(kk); theta_list(kk+1); theta_list(kk+1)];
    
            phi = [linspace(phi_temp(1),phi_temp(2),resNum)'; linspace(phi_temp(3),phi_temp(4),resNum)'];
            theta = [linspace(theta_temp(1),theta_temp(2),resNum)'; linspace(theta_temp(3),theta_temp(4),resNum)'];
            [x,y,z] = sph2cart(phi.*degree, theta.*degree, ones(size(phi)));
            patchPoints(:,:,ii) = [x,y,z];
        else
            switch find(theta_list_original == posInfo.theta(ii))
                case 17
                    jj = floor(posInfo.phi(ii) / 22.5);
                    kk = find(theta_list_original == posInfo.theta(ii));
                    phi = [linspace(22.5*jj,22.5*(jj+1),resNum)'; linspace(22.5*(jj+1),22.5*jj,resNum)'];
                    theta = [linspace(theta_list(kk),theta_list(kk),resNum)'; linspace(theta_list(kk+1),theta_list(kk+1),resNum)'];
                    [x,y,z] = sph2cart(phi.*degree, theta.*degree, ones(size(phi)));
                    patchPoints(:,:,ii) = [x,y,z];
                case 18
                    jj = floor(posInfo.phi(ii) / 30);
                    kk = find(theta_list_original == posInfo.theta(ii));
                    phi = [linspace(30*jj,30*(jj+1),resNum)'; linspace(30*(jj+1),30*jj,resNum)'];
                    theta = [linspace(theta_list(kk),theta_list(kk),resNum)'; linspace(theta_list(kk+1),theta_list(kk+1),resNum)'];
                    [x,y,z] = sph2cart(phi.*degree, theta.*degree, ones(size(phi)));
                    patchPoints(:,:,ii) = [x,y,z];
                case 19
                    jj = floor(posInfo.phi(ii) / 90);
                    kk = find(theta_list_original == posInfo.theta(ii));
                    phi = [linspace(90*jj,90*(jj+1),resNum)'; linspace(90*(jj+1),90*jj,resNum)'];
                    theta = [linspace(theta_list(kk),theta_list(kk),resNum)'; linspace(theta_list(kk+1),theta_list(kk+1),resNum)'];
                    [x,y,z] = sph2cart(phi.*degree, theta.*degree, ones(size(phi)));
                    patchPoints(:,:,ii) = [x,y,z];
            end
        end
    end
    plotPara.x = squeeze(patchPoints(:,1,:));
    plotPara.y = squeeze(patchPoints(:,2,:));
    plotPara.z = squeeze(patchPoints(:,3,:));
end