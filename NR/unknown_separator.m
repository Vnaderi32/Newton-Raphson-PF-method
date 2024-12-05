function [V,delta]=unknown_separator(unknown_values,V,delta,V_unknown_indices,delta_unknown_indices)
    %Defining the delta participation in unknown_values
    delta_unknown_new = unknown_values(1:length(delta_unknown_indices));

    %Defining the V participation in unknown_values
    V_unknown_new = unknown_values(length(delta_unknown_indices)+1:end);
    
    %Exctracting the V new arguments and putting in the original V vector
    for k = 1:length(V_unknown_indices)
        i = V_unknown_indices(k);
        V(i)=V_unknown_new(k);
    end
    
    %Exctracting the delta new arguments and putting in the original delta vector
    for k = 1:length(delta_unknown_indices)
        i = delta_unknown_indices(k);
        delta(i)=delta_unknown_new(k);
    end
end