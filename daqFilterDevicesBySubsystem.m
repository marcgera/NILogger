function filteredDevices = daqFilterDevicesBySubsystem(~, devices, subsystemTypes)
%daqFilterDevicesBySubsystem Filter DAQ device array by subsystem
%type
%  devices is a DAQ device info array subsystemTypes is a cell
%  array of DAQ subsystem types, for example {'AnalogInput,
%  'AnalogOutput'} filteredDevices is the filtered DAQ device info
%  array

% Logical array indicating if device has any of the subsystem types
% provided
hasSubsystemArray = false(numel(devices), 1);

% Go through each device and see if it has any of the subsystem
% types provided
for ii = 1:numel(devices)
    hasSubsystem = false;
    for jj = 1:numel(subsystemTypes)
        hasSubsystem = hasSubsystem || ...
            any(strcmp({devices(ii).Subsystems.SubsystemType}, subsystemTypes{jj}));
    end
    hasSubsystemArray(ii) = hasSubsystem;
end
filteredDevices = devices(hasSubsystemArray);
end