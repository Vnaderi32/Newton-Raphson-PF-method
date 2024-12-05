function T_input = input_bus_data(numberOfBuses)
    % Function to create and process bus data, returning the unknowns vector

    % Define empty columns for the table
    Bus = (1:numberOfBuses)';             % Column for bus numbers
    Type = strings(numberOfBuses, 1);     % Empty string column for 'Type'
    V = NaN(numberOfBuses, 1);            % NaN for unknown values in 'V'
    delta = NaN(numberOfBuses, 1);        % NaN for unknown values in 'delta'
    P = NaN(numberOfBuses, 1);            % NaN for unknown values in 'P'
    Q = NaN(numberOfBuses, 1);            % NaN for unknown values in 'Q'
    
    % Create the table and save it as an Excel file
    T = table(Bus, Type, V, delta, P, Q);
    filename = 'Input_Bus_Data.xlsx';
    writetable(T, filename, 'Sheet', 1, 'Range', 'A1');
    
    % Instructions for the user
    fprintf('An Excel file named "Input_Bus_Data.xlsx" has been created.\n');
    fprintf('Input data for each bus type:\n');
    fprintf('- For "PV" buses: Insert values for V and P.\n');
    fprintf('- For "PQ" buses: Insert values for P and Q.\n');
    fprintf('- For "Slack" buses: Insert values for V and delta.\n');
    fprintf('When done, return here and PRESS ANY KEY to continue.\n');
    pause;
    clc;
    % Read data back into MATLAB
    T_input = readtable(filename);
    
    % Convert Type to uppercase to ensure case-insensitivity
    T_input.Type = upper(T_input.Type);
    
    % Check each bus for required values based on its type
    for i = 1:height(T_input)
        busType = T_input.Type{i};
        
        switch busType
            case 'PV'
                % Check if V and P are provided
                if isnan(T_input.V(i)) || isnan(T_input.P(i))
                    fprintf('Warning: PV bus %d is missing V or P.\n', T_input.Bus(i));
                end
            case 'PQ'
                % Check if P and Q are provided
                if isnan(T_input.P(i)) || isnan(T_input.Q(i))
                    fprintf('Warning: PQ bus %d is missing P or Q.\n', T_input.Bus(i));
                end
            case 'SLACK'
                % Check if V and delta are provided
                if isnan(T_input.V(i)) || isnan(T_input.delta(i))
                    fprintf('Warning: Slack bus %d is missing V or delta.\n', T_input.Bus(i));
                end
            otherwise
                fprintf('Warning: Bus %d has an invalid or unspecified type.\n', T_input.Bus(i));
        end
    end
end