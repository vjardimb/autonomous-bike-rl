% Load the existing Simulink model
modelFile = 'BlueBikeSimulator.slx';
load_system(modelFile);

% Loop through each reference point and add a red sphere marker
for i = 1:length(ref_x)
    % Define the block name for each marker
    markerBlockName = ['Marker', num2str(i)];
    
    % Check if the marker block already exists in the model
    if ~bdIsLoaded(markerBlockName)
        % If not, add a new Joint block (marker)
        add_block('simscape/Multibody/Joints & Constraints/Joint', [modelFile, '/', markerBlockName]);
        
        % Set the position of the marker based on the reference point
        set_param([modelFile, '/', markerBlockName], 'Position', [ref_x(i), ref_y(i), 0]);
        
        % Set the visual appearance to a small red ball
        set_param([modelFile, '/', markerBlockName], 'Visual/Appearance', 'Small red ball');
        
        % Connect the marker to the relevant frame or body in the model
        % Modify the following line based on your model structure
        connect_line = add_line(modelFile, ['Bike', '/1'], markerBlockName);
    end
end

% Save the updated model
save_system(modelFile);

% Close the Simulink model
close_system(modelFile);