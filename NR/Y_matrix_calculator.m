function [Y] = Y_matrix_calculator (numberOfBuses,numberOfLines,L_input)
    Y = complex(zeros(numberOfBuses)); % Initialize as a zero matrix with complex numbers

% Loop through each line or transformer
for i = 1:numberOfLines
    % Ensure bus indices are integers
    from = round(L_input.From_Bus(i));
    to = round(L_input.To_Bus(i));
    
    % Ensure valid indices
    if isnan(from) || isnan(to) || from <= 0 || to <= 0
        fprintf('Error: Invalid bus indices for line %d\n', i);
        continue;
    end
    
    % Retrieve line data
    r = L_input.R_pu(i);
    x = L_input.X_pu(i);
    b = L_input.B_pu(i) / 2; % Shunt admittance (half at each end)
    
    % Check for invalid impedance
    if isnan(r) || isnan(x) || (r == 0 && x == 0)
        fprintf('Error: Invalid impedance for line %d\n', i);
        continue;
    end
    
    % Calculate line admittance
    z = r + 1j * x; % Impedance
    y_line = 1 / z; % Admittance
    y_shunt = 1j * b; % Shunt admittance
    
    % Update Y-matrix
    if strcmp(L_input.Type{i}, 'L') % Line
        Y(from, from) = Y(from, from) + y_line + y_shunt;
        Y(to, to) = Y(to, to) + y_line + y_shunt;
        Y(from, to) = Y(from, to) - y_line;
        Y(to, from) = Y(to, from) - y_line;
    elseif strcmp(L_input.Type{i}, 'T') % Transformer
        % Handle transformer-specific calculations
        tap_ratio = L_input.tap_ratio_ang_deg(i);
        if isnan(tap_ratio)
            tap_ratio = 1.0;
        end
        Y(from, from) = Y(from, from) + y_line + y_shunt;
        Y(to, to) = (Y(to, to) + y_line + y_shunt)/(tap_ratio*conj(tap_ratio));
        Y(from, to) = Y(from, to) - y_line / tap_ratio;
        Y(to, from) = Y(to, from) - y_line / conj(tap_ratio);
    end
end

% Display the Y-matrix
disp('Final Y-admittance matrix:');
disp(Y);
end