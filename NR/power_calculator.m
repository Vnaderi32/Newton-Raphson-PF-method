function [P_cal,Q_cal]= power_calculator(V,delta,numberOfBuses,Y_mag,Y_ang,tilda_p_indices,tilda_q_indices)
    %defining the vector of P_cal and Q_cal
    P_cal_indices=tilda_p_indices;
    Q_cal_indices=tilda_q_indices;
    
    %Creating empty P and Q calculated to use in Sum
    P_cal = zeros(length(P_cal_indices), 1);
    Q_cal = zeros(length(Q_cal_indices), 1);

    % Compute only for the specified indices
    for k = 1:length(P_cal_indices)
        i = P_cal_indices(k); % Extract index from P_cal_indices
        P_cal(k) = 0; % Initialize for this specific index
        for j = 1:numberOfBuses
            P_cal(k) = P_cal(k) + V(i) * V(j) * Y_mag(i,j) * cos(delta(i) - delta(j) - Y_ang(i,j));
        end
    end

    % Compute only for the specified indices
    for k = 1:length(Q_cal_indices)
    i = Q_cal_indices(k); % Extract index from Q_cal_indices
    Q_cal(k) = 0; % Initialize for this specific index
        for j = 1:numberOfBuses
            Q_cal(k) = Q_cal(k) + V(i) * V(j) * Y_mag(i,j) * sin(delta(i) - delta(j) - Y_ang(i,j));
        end
    end
end