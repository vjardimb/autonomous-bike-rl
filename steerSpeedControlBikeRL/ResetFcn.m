function in = bikeResetFcn(in, path_n_points, path_max_dim, cvx_hull_n_points, ref_v_lims)

% randomly generate 20 points in the 2D
points = rand(cvx_hull_n_points, 2)*path_max_dim;

% Perform Convex Hull
k = convhull(points(:, 1), points(:, 2));

% Initialize input to the spline generator
spline_param = linspace(0,2*pi,length(k)); 
spl_points = [points(k,1), points(k,2)];

% Compute spline 2D points
pp = spline(spline_param, spl_points');
yy = ppval(pp, linspace(0,2*pi,path_n_points));

% Transpose spline points coordinates
random_path = yy';

% Randomly select the initial point
initialPointIndex = randi(size(random_path, 1));

initialPoint = random_path(initialPointIndex, :);

% Translate all points to align the initial point to (0, 0)
translatedPath = random_path - initialPoint;

% Rotate all points to align the second point with y-coordinate equal to 0
angle = atan2( ...
    translatedPath(mod(initialPointIndex + 1, size(translatedPath, 1)) + 1, 2), ...
    translatedPath(mod(initialPointIndex + 1, size(translatedPath, 1)) + 1, 1) ...
    );
rotationMatrix = [cos(-angle), -sin(-angle); sin(-angle), cos(-angle)];
rotatedPath = (rotationMatrix * translatedPath')';

% Reorder the path points with the zero-index point as the first point
transformedPath = circshift(rotatedPath, [1 - initialPointIndex, 0]);

% change path turning direction
if rand(1) < 0.5
    transformedPath(:, 2) = -transformedPath(:, 2);
end

% Calculate the orientation reference for each point
orientationReference = atan2(transformedPath(2:end, 2) - transformedPath(1:end-1, 2), transformedPath(2:end, 1) - transformedPath(1:end-1, 1));
orientationReference(path_n_points) = atan2( ...
    transformedPath(1, 2) - transformedPath(path_n_points, 2), ...
    transformedPath(1, 1) - transformedPath(path_n_points, 1) ...
    );

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