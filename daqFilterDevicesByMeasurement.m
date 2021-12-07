        function filteredDevices = daqFilterDevicesByMeasurement(~, devices, measurementTypes)
        %daqFilterDevicesByMeasurement Filter DAQ device array by measurement type
        %  devices is a DAQ device info array
        %  measurementTypes is a cell array of measurement types, for example {'Voltage, 'Current'}
        %  filteredDevices is the filtered DAQ device info array

        % Logical array indicating if device has any of the measurement types provided
        hasMeasurementArray = false(numel(devices), 1);

        % Go through each device and subsystem and see if it has any of the measurement types provided
        for ii = 1:numel(devices)
            % Get array of available subsystems for the current device
            subsystems = [devices(ii).Subsystems];
            hasMeasurement = false;
            for jj = 1:numel(subsystems)
                % Get cell array of available measurement types for the current subsystem
                measurements = subsystems(jj).MeasurementTypesAvailable;
                for kk = 1:numel(measurementTypes)
                    hasMeasurement = hasMeasurement || ...
                        any(strcmp(measurements, measurementTypes{kk}));
                end
            end
            hasMeasurementArray(ii) = hasMeasurement;
        end
        filteredDevices = devices(hasMeasurementArray);
        end