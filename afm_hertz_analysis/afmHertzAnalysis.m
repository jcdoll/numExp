% afmHertzAnalysis.m
% Overview:
% Fits Hertz elastic contact theory to the contact of a pyramidal indentor
% with a sample, e.g. a microfabricated cantilever on an atomic force
% microscope. Returns the estimated elastic modulus of the sample
% and the measured spring constant of the sample.
%
% Although this code is written for a pyramidal indentor, I would
% strongly recommend performing experiments with a spherical indentor,
% e.g. a glass bead glued to the tip of the cantilever. This provides
% more reliable results in my experience.
%
% Requires at least two input text files with displacement (nm) in
% the first column and segmented photodiode output (V) in the second.
% Calculates the AFM optical lever sensitivity (nm/V) from the slope
% of the calibration curve (which must be measured on a hard sample)
% and then uses the spring constant (N/m) to generate a F-d curve
% (N vs. nm).
%
% I haven't used this code much personally and wrote it to help with
% another project, so buyer beware.
%
% by Joey Doll and James Norman
% Stanford Microsystems Lab, 2007-2008
%
% History:
% 09/01/2007 - initial version: JCD
% 11/01/2007 - added dialog box prompts for multiple data files, and
%               spring constant. : JJN
% 07/20/2008 - Refactored to a single file and improved readability.
%              Rewrote contact point finder so that it uses the pull off
%              force rather than snap in and works in liquid. Still lots
%              of room for testing and improvement: JCD

function afmHertzAnalysis()

close all
clear all

% Constants
nu = 0.5; % Poisson ratio for sample (0.5 = incompressible)
alpha = 30*(pi/180); % Tip angle in radians
    
    % Plot the data, save to a PNG
    function pretty_plot(x_data, y_data, x_fit, y_fit, y_label, file_name)
        figure;
        hold on;
        plot(x_data, y_data, 'b-', 'LineWidth', 3);
        plot(x_fit, y_fit, 'r-', 'LineWidth', 2);
        hold off;
        xlabel('Indentation depth (nm)');
        ylabel(y_label);
        print('-dpng','-r300', file_name);
    end

    function fit_indices = find_fit_indices(displacement, voltage)
    % Determine where to start fitting a line/parabola to the data.
    % We test every point on the 'push' stroke as a candidate contact
    % point. We iterate across each point and try fitting a straight line
    % along the flat region before contact and the mostly linear portion
    % after contact. We then choose the point which minimizes the norm of
    % the residual error.
    %
    % This method should be robust and work for both dry and wet samples.
    
        max_voltage_index = find(voltage == max(voltage));
        push_indices = 1:max_voltage_index;
        
        displacement_push = displacement(push_indices);
        voltage_push = voltage(push_indices);
        total_error = zeros(max_voltage_index, 1);
        
        for middle_index = 1:max_voltage_index;
            [p1, s1] = polyfit(displacement_push(1:middle_index), voltage_push(1:middle_index), 1);
            error1 = s1.normr;
            
            [p2, s2] = polyfit(displacement_push(middle_index+1:end), voltage_push(middle_index+1:end), 1);
            error2 = s2.normr;

            total_error(middle_index) = error1 + error2;
        end
        
        start_fit_index = find(total_error == min(total_error));
        fit_indices = start_fit_index:max_voltage_index;
    end

    function volts_per_newton = afm_sensitivity(displacement, voltage, k)
    % afm_sensitivity  Calculate AFM sensitivity (V/N) from a calibration curve
    %   afm_sensitivity(displacement, voltage, k) calculates the sensitivity
    %   in volts per newton for given displacement (units of nanometers) and
    %   voltage (units of volts) vectors from the AFM and a given spring
    %   constant.

        voltage = voltage - voltage(1);
        fit_indices = find_fit_indices(displacement, voltage);
        displacement = displacement(fit_indices(1)) - displacement;

        % Fit the line
        p = polyfit(displacement(fit_indices), voltage(fit_indices), 1);
        fitLine = polyval(p, displacement(fit_indices));

        % p(1) is the slope of the line in V/nm, convert to m.
        voltsPerMeter = p(1)*1e9;
        volts_per_newton = voltsPerMeter / k;

        % Plot the calibration data with the straight line fit overlayed
        pretty_plot(displacement, voltage, ...
            displacement(fit_indices), fitLine, 'T-B Voltage (V)', 'Calibration')
    end

    function spring_constant = sample_spring_constant(displacement, force)
    % Fit a first order line to the F-D data to get the effective spring
    % constant of the sample.

        % Find the fit indices
        fit_indices = find_fit_indices(displacement, force);
        displacement = displacement(fit_indices(1)) - displacement;

        % Find the sample spring constant
        p = polyfit(displacement(fit_indices), force(fit_indices), 1);
        fitLine = polyval(p, displacement(fit_indices));
        pretty_plot(displacement, force, displacement(fit_indices), ...
            fitLine, 'Force (N)', 'SpringConstant');

        spring_constant = p(2);
    end


    function modulus = sample_elastic_modulus(displacement, force)
    % sample_elastic_modulus  Calculate elastic modulus with Hertz model
    % from AFM data

        % Find the fit indices
        fit_indices = find_fit_indices(displacement, force);
        displacement = displacement(fit_indices(1)) - displacement;

        % Find the sample modulus (Hertz).
        p = polyfit(displacement(fit_indices).^2, force(fit_indices), 1);
        A = p(1);
        C = p(2);
        fitLine = polyval([A 0 C], displacement(fit_indices));

        pretty_plot(displacement, force, displacement(fit_indices), ...
            fitLine, 'Force (N)', 'Elastic Modulus');

        % Calculate the modulus from A. Conversion factor (1e9)^2
        modulus = 1e18*pi*(1-nu^2)/(2*tan(alpha)) * C;
    end

% Prompt for the cantilever spring constant
k = str2double(cell2mat(inputdlg('Enter Cantilever spring constant')));

% Prompt for the calibration files
[calibration_file_name, calibration_path]=uigetfile('*.*','Open Calibration files','MultiSelect','on');
if ~iscell(calibration_file_name)
    calibration_file_name={calibration_file_name}; % if only 1 file is loaded place in cell array
end

% Calculate system sensitivity based upon the average of measurements
for ii = 1:length(calibration_file_name)
    calibration_data = load([ calibration_path calibration_file_name{ii} ]);
    calibration_displacement = calibration_data(:,1);
    calibration_voltage = calibration_data(:,2);
    sensitivity(ii) = afm_sensitivity(calibration_displacement, calibration_voltage, k);
end
volts_per_newton = mean(sensitivity);

% Prompt for the actual measurement file
[file_name, path]=uigetfile('*.*','Open Force-Displacement files','MultiSelect','on');
if ~iscell(file_name)
    file_name={file_name};
end

length(file_name)
% Calculate the modulus of the sample
for ii = 1:length(file_name)
    loadedData = load([path file_name{ii} ]);
    displacement = loadedData(:,1);
    voltage = loadedData(:,2);
    
    % Convert voltage to force. Shift to zero force baseline.
    force = voltage/volts_per_newton;
    force = force - force(1);
    
    spring_constant(ii) = sample_spring_constant(displacement, force);
    modulus(ii) = sample_elastic_modulus(displacement, force);
end

% Return the results
spring_constant
modulus

% Print the mean and STD of the modulus
mean_spring_constant = mean(spring_constant)
std_spring_constant = std(spring_constant)

mean_modulus = mean(modulus)
std_modulus = std(modulus)

end
