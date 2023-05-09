function drpList = drpSimCone(posInfo, eulerAngle, faceting, fitting_para)
    arguments
        posInfo (1,1) struct  % column 1 for phi, column 2 for theta
        eulerAngle (1,3) double = [0,0,0]
        faceting (1,3) double = [1,0,0]
        fitting_para (1,6) double = [1,0.7,25,4,0.8,8]
    end
    
    eu1 = eulerAngle(1);
    eu2 = eulerAngle(2);
    eu3 = eulerAngle(3);
    rot_facet = normr(rotate_facet(eu1,eu2,eu3,faceting));
    i_Main = fitting_para(1);
    i_facet = fitting_para(2);
    sd_Main = fitting_para(3);
    sd_facet = fitting_para(4);

    cauchy = @(p,x) p(1) ./ ((1+((x)./p(2)).^2));
    
    vec_DRP = zeros(3,length(posInfo.phi));
    nn = length(posInfo.phi);
    for idx = 1:nn
        tmp_vec = thph2vec(45+posInfo.theta(idx)/2, posInfo.phi(idx));
        vec_DRP(:,idx) = normr(tmp_vec);  % vec_DRP in size of nx3
    end
    
    drpList = zeros(1,nn);
    % major reflectance peak simulation
    for ii = 1:length(rot_facet)
        ref_a1 = rot_facet(ii,:);
        ref = [0 0 -1] - 2 * dot([0 0 -1], ref_a1) * ref_a1;
        tmp_thph = vec2thph(ref);
        tmp_theta = tmp_thph(1);
        dPh=abs(posInfo.phi - tmp_thph(2));
        dPh=abs(dPh - 360 * (dPh>180)); 
        peakDist=acosd(sind(posInfo.theta)*sind(tmp_theta)+cosd(posInfo.theta)*cosd(tmp_theta).*cosd(dPh));
        drpList = max(drpList, cauchy([i_Main, sd_Main], peakDist));
    end
    
    % great circle band simulation
    for ii = 1:size(rot_facet,1)
        for jj = 1:size(rot_facet,1)
            if ii == jj
                continue
            end
            vec_1 = rot_facet(ii,:);
            vec_2 = rot_facet(jj,:);
            if all(vec_1 - vec_2 < 1e-3) || all(vec_1 + vec_2 < 1e-3)
                continue
            end
            gcnorm = normr(cross(vec_1, vec_2));
            peakDistb=zeros(size(drpList));
            peakDista=zeros(size(drpList));
            bandDist=zeros(size(drpList));
            for mm = 1:nn
                peakDista(mm) = acosd(dot(vec_1, vec_DRP(:,mm)));
                peakDistb(mm) = acosd(dot(vec_2, vec_DRP(:,mm)));
                bandDist(mm) = asind(dot(gcnorm, vec_DRP(:,mm)));
            end
    %         peakDist = bandDist; % + min(peakDista, peakDistb).^2.5;
            drpList = max(drpList, cauchy([i_facet, sd_facet], bandDist));
        end
    end    
end