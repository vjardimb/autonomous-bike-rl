function in = SimplebikeResetFcn(in, path_n_points, path_max_dim, cvx_hull_n_points, ref_v_lims)

randAngle = -(30*pi/180) + 2*(30*pi/180)*rand(1);

transformedPath = zeros(path_n_points, 2);
transformedPath(:, 1) = linspace(0, 100, path_n_points);
transformedPath(:, 2) = transformedPath(:, 1) * tan(randAngle);

% Calculate the orientation reference for each point
orientationReference = randAngle*ones(path_n_points, 1);

% Time vector
time = 0:1:(length(transformedPath)-1);

% Convert arrays to timeseries (debug reasons)
ref_x_ts = timeseries(transformedPath(:, 1), time, 'Name', 'X Reference');
ref_y_ts = timeseries(transformedPath(:, 2), time, 'Name', 'Y Reference');

% Generate a speed reference between disired limits
ref_v = ref_v_lims(1) + (ref_v_lims(2) - ref_v_lims(1))*rand(1,1);

% Update variables
in = in.setVariable('ref_x',transformedPath(:, 1));
in = in.setVariable('ref_y',transformedPath(:, 2));
in = in.setVariable('ref_theta',unwrap(orientationReference));
in = in.setVariable('ref_x_ts',ref_x_ts);
in = in.setVariable('ref_y_ts',ref_y_ts);
in = in.setVariable('ref_v',ref_v);