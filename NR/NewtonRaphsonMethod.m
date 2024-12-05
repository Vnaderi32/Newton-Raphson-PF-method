clc;
clear;
close all;
%% Input Bus data

% Specify the number of buses
numberOfBuses = input('Please enter number of buses: ');
clc;

% Specify the number of lines
numberOfLines = input('Please enter number of lines: ');
clc;

% Specify the tolerance(epsilon) for the solution
epsilon = input('Please enter the tolerance(epsilon) for the solution: ');
clc;

%Fetching the Bus Data from user
T_input = input_bus_data(numberOfBuses);

% Identify unknown delta and V indices
delta_unknown_indices = find(isnan(T_input.delta));  % Indices for NaN in delta
V_unknown_indices = find(isnan(T_input.V));  % Indices for NaN in V
    
% Initialize delta unknowns to 0
T_input.delta(delta_unknown_indices) = 0;
    
% Initialize V unknowns to 1
T_input.V(V_unknown_indices) = 1;
    
% Create the unknowns vector with initial values (vertical format)
unknown_values = [T_input.delta(delta_unknown_indices); T_input.V(V_unknown_indices)];
    
% Display the initialized unknowns vector
disp('Initialized vector of unknowns (deltas followed by Vs):');
disp(unknown_values);

%Exctracting tilda P incides for table
tilda_p_indices = find(~isnan(T_input.P));

%Putting P column inputed by the user
tilda_powers = T_input.P(tilda_p_indices);

%Exctracting tilda Q incides for table
tilda_q_indices = find(~isnan(T_input.Q));

%Putting Q column inputed by the user after P
tilda_powers = [tilda_powers;T_input.Q(tilda_q_indices)];

%exctract V and delta vectors for computing power
V=T_input.V;
delta=T_input.delta;
    
%% Y_Matrix Input

%Receive the line data from the user
L_input = input_line_data(numberOfLines);

%Compute Y_Admittance Matrix
Y = Y_matrix_calculator(numberOfBuses,numberOfLines,L_input);

% Computing Y_mag and Y_ang
Y_mag = abs(Y);
Y_ang = angle(Y);

%% Newton Raphson Power Flow Method

flag=0;
iteration=0;
maxIter=3;
while flag==0 || iteration < maxIter 
    %% Power Calculations
    [P_cal,Q_cal]= power_calculator(V,delta,numberOfBuses,Y_mag,Y_ang,tilda_p_indices,tilda_q_indices); 
    calculated_powers=[P_cal;Q_cal];
    mismatches = tilda_powers - calculated_powers;
    tolerance = norm(mismatches);
    if tolerance > epsilon
        iteration = iteration + 1;
        %% Jacobian Matrix
        J=Jacobian(P_cal,Q_cal,delta_unknown_indices,V_unknown_indices,delta,V,numberOfBuses,Y_mag,Y_ang,tilda_p_indices,tilda_q_indices);
        %% dx calculation
        dx = J\mismatches;
        %% New unknowns
        unknown_values = unknown_values + dx;
        %% Exctract new V and delta vectors
        [V,delta]=unknown_separator(unknown_values,V,delta,V_unknown_indices,delta_unknown_indices);    
    else
        flag = 1;
    end
end
%% Showing the results
    clc;
    fprintf('Number of iteration: %d\n',iteration);
    fprintf('Unknowns:\n');
    disp(unknown_values)
    for i=1:numberOfBuses
        fprintf('V%d:',i);
        disp(V(i))
        fprintf('\n');
        fprintf('delta%d:',i);
        disp(delta(i))
        fprintf('\n');
    end