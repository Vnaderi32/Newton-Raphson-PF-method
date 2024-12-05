function [J]=Jacobian(P_cal,Q_cal,delta_unknown_indices,V_unknown_indices,delta,V,numberOfBuses,Y_mag,Y_ang,tilda_p_indices,tilda_q_indices)
    %% Build submatrixes
    J1 = zeros(size(P_cal,1),size(delta_unknown_indices,1));
    J2 = zeros(size(P_cal,1),size(V_unknown_indices,1));
    J3 = zeros(size(Q_cal,1),size(delta_unknown_indices,1));
    J4 = zeros(size(Q_cal,1),size(V_unknown_indices,1));
    
    %% J1 [dP/ddelta]

    P_cal_indices=tilda_p_indices;

    for k = 1:length(P_cal_indices)
    i = P_cal_indices(k);
        for m = 1:length(delta_unknown_indices)
        j = delta_unknown_indices(m);
            if i ~= j
                % Compute elements off-diagonal
                J1(k,m)= V(i)*V(j)*Y_mag(i,j)*sin(delta(i)-delta(j)-Y_ang(i,j)); 
            else
                % Compute elements diagonal
                J1(k, m) = 0;
                for n= 1:numberOfBuses
                    if i~=n
                        J1(k,m)= J1(k,m)-V(i)*V(n)*Y_mag(i,n)*sin(delta(i)-delta(n)-Y_ang(i,n));
                    end
                end
            end
        end
    end

    %% J2 [dP/dV]
    
    for k = 1:length(P_cal_indices)
    i = P_cal_indices(k);
        for m = 1:length(V_unknown_indices)
        j = V_unknown_indices(m);
            if i ~= j
                % Compute elements off-diagonal
                J2(k,m)= V(i)*Y_mag(i,j)*cos(delta(i)-delta(j)-Y_ang(i,j)); 
            else
                J2(k,m) = 0;
                for n= 1:numberOfBuses
                    if i~=n
                        J2(k,m)= J2(k,m)+V(n)*Y_mag(i,n)*cos(delta(i)-delta(n)-Y_ang(i,n));
                    else
                        J2(k,m)= J2(k,m)+2*V(i)*Y_mag(i,i)*cos(delta(i)-delta(i)-Y_ang(i,i));
                    end
                end
            end
        end
    end
    

    %% J3 [dQ/ddelta]
    Q_cal_indices=tilda_q_indices;
    
    for k = 1:length(Q_cal_indices)
    i = Q_cal_indices(k);
        for m = 1:length(delta_unknown_indices)
        j = delta_unknown_indices(m);
            if i ~= j
                % Compute elements off-diagonal
                J3(k,m)= -V(i)*V(j)*Y_mag(i,j)*cos(delta(i)-delta(j)-Y_ang(i,j)); 
            else
                % Compute elements diagonal
                J3(k,m) = 0;
                for n= 1:numberOfBuses
                    if i~=n
                        J3(k,m)= J3(k,m)+V(i)*V(n)*Y_mag(i,n)*cos(delta(i)-delta(n)-Y_ang(i,n));
                    end
                end
            end
        end
    end
    
    %% J4 [dQ/dV]
    
    for k = 1:length(Q_cal_indices)
    i = Q_cal_indices(k);
        for m = 1:length(V_unknown_indices)
        j = V_unknown_indices(m);
            if i ~= j
                % Compute elements off-diagonal
                J4(k,m)= V(i)*Y_mag(i,j)*sin(delta(i)-delta(j)-Y_ang(i,j)); 
            else
                % Compute elements diagonal
                J4(k,m) = 0;
                for n= 1:numberOfBuses
                    if i~=n
                        J4(k,m)= J4(k,m)+V(n)*Y_mag(i,n)*sin(delta(i)-delta(n)-Y_ang(i,n));
                    else
                        J4(k,m)= J4(k,m)+2*V(i)*Y_mag(i,i)*sin(delta(i)-delta(i)-Y_ang(i,i));
                    end
                end
            end
        end
    end
    
    %% Adding up
    J= [J1 J2; J3 J4];
end