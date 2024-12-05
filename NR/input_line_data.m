function L_input = input_line_data(numberOfLines)
    clc;
    % Define empty columns for the table
    Line = (1:numberOfLines)';
    From_Bus = NaN(numberOfLines, 1);                          % Column for started bus
    To_Bus = NaN(numberOfLines, 1);                            % Column for ended bus
    R_pu = NaN(numberOfLines, 1);                              % Column for R of the lines
    X_pu = NaN(numberOfLines, 1);                              % Column for X of the lines
    B_pu = NaN(numberOfLines, 1);                              % Column for B of the lines
    G_pu = NaN(numberOfLines, 1);                              % Column for G of the lines
    Type = strings(numberOfLines, 1);                       % Empty string column for 'Type'
    tap_ratio_ang_deg=NaN(numberOfLines, 1);                   % Column for tap ratio angle of the lines(in degree)
    phase_shifter_ang_deg = NaN(numberOfLines, 1);             % Column for phase shifter angle of the lines(in degree)
    controller = repmat(missing, numberOfLines, 1);
    step = NaN(numberOfLines, 1);            % NaN for unknown values in 'V'
    step_min = NaN(numberOfLines, 1);        % NaN for unknown values in 'delta'
    step_max = NaN(numberOfLines, 1);            % NaN for unknown values in 'P'
    
    L=table(Line,From_Bus,To_Bus,R_pu,X_pu,B_pu,G_pu,Type,tap_ratio_ang_deg,phase_shifter_ang_deg,controller,step,step_min,step_max);
    filename = 'Input_Line_Data.xlsx';
     writetable(L, filename, 'Sheet', 1, 'Range', 'A1');
    
    % Instructions for the user
    fprintf('An Excel file named "Input_Line_Data.xlsx" has been created.\n');
    fprintf('Input requested data of the lines\n');
    fprintf('In column type, consider L for Lines and T for Transformers\n');
    fprintf('When done, return here and PRESS ANY KEY to continue.\n');
    pause;
    clc;

    % Read data back into MATLAB
    L_input = readtable(filename);
    
    % Convert Type to uppercase to ensure case-insensitivity
    L_input.Type = upper(L_input.Type);
    L_input.controller = upper(L_input.controller);
    
end