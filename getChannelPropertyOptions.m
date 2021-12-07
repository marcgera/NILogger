        function [items, itemsData] = getChannelPropertyOptions(~, subsystem, propertyName)
        %getChannelPropertyOptions Get options available for a DAQ channel property
        %  Returns items and itemsData for displaying options in a dropdown component
        %  subsystem is the DAQ subsystem handle corresponding to the DAQ channel
        %  propertyName is channel property name as a character array, and can be
        %    'TerminalConfig', or 'Coupling', or 'Range'.
        %  items is a cell array of possible property values, for example {'DC', 'AC'}
        %  itemsData is [] (empty) for 'TerminalConfig' and 'Coupling', and is a cell array of
        %     available ranges for 'Range', for example {[-10 10], [-1 1]}

        switch propertyName
            case 'TerminalConfig'
                items = cellstr(string(subsystem.TerminalConfigsAvailable));
                itemsData = [];
            case 'Coupling'
                items = cellstr(string(subsystem.CouplingsAvailable));
                itemsData = [];
            case 'Range'
                numRanges = numel(subsystem.RangesAvailable);
                items = strings(numRanges,1);
                itemsData = cell(numRanges,1);
                for ii = 1:numRanges
                    range = subsystem.RangesAvailable(ii);
                    items(ii) = sprintf('%.2f to %.2f', range.Min, range.Max);
                    itemsData{ii} = [range.Min range.Max];
                end
                items = cellstr(items);
            case 'ExcitationSource'
                items = {'Internal','External','None'};
                itemsData = [];
        end