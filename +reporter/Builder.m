classdef Builder < handle
    % BUILDER A flexible data accumulation and reporting class.
    % Collects simulation results and exports them to CSV or Markdown formats.
    
    properties (SetAccess = private)
        Columns (1,:) string
        DataRows (:,:) cell
    end
    
    methods
        function obj = Builder(columns)
            % BUILDER Constructor
            arguments
                columns (1,:) string
            end
            obj.Columns = columns;
            obj.DataRows = cell(0, length(columns));
        end
        
        function addRow(obj, varargin)
            % ADDROW Appends a new row of data. 
            % Number of arguments must match the number of columns.
            if nargin - 1 ~= length(obj.Columns)
                error('report:Builder:ArgumentMismatch', ...
                      'Expected %d arguments, but got %d.', length(obj.Columns), nargin - 1);
            end
            
            newRow = cell(1, length(obj.Columns));
            for i = 1:(nargin - 1)
                newRow{i} = varargin{i};
            end
            
            obj.DataRows = [obj.DataRows; newRow];
        end
        
        function clearData(obj)
            % CLEARDATA Removes all accumulated rows but keeps column definitions.
            obj.DataRows = cell(0, length(obj.Columns));
        end
        
        function exportCSV(obj, filePath)
            % EXPORTCSV Exports the accumulated data to a CSV file.
            arguments
                obj (1,1) report.Builder
                filePath (1,1) string
            end
            
            if isempty(obj.DataRows)
                warning('report:Builder:EmptyData', 'No data to export.');
                return;
            end
            
            tbl = cell2table(obj.DataRows, 'VariableNames', cellstr(obj.Columns));
            writetable(tbl, filePath, 'Encoding', 'UTF-8');
        end
        
        function exportMarkdown(obj, filePath)
            % EXPORTMARKDOWN Exports the accumulated data to a Markdown table.
            arguments
                obj (1,1) report.Builder
                filePath (1,1) string
            end
            
            if isempty(obj.DataRows)
                warning('report:Builder:EmptyData', 'No data to export.');
                return;
            end
            
            fid = fopen(filePath, 'w', 'n', 'UTF-8');
            if fid == -1
                error('report:Builder:FileError', 'Cannot open file for writing: %s', filePath);
            end
            
            % Write Header
            headerStr = strjoin(obj.Columns, " | ");
            fprintf(fid, '| %s |\n', headerStr);
            
            % Write Separator
            sepStr = strjoin(repmat("---", 1, length(obj.Columns)), " | ");
            fprintf(fid, '| %s |\n', sepStr);
            
            % Write Data Rows
            [numRows, numCols] = size(obj.DataRows);
            for r = 1:numRows
                rowStrs = strings(1, numCols);
                for c = 1:numCols
                    val = obj.DataRows{r, c};
                    if ischar(val) || isstring(val)
                        rowStrs(c) = string(val);
                    elseif isinteger(val) || (isnumeric(val) && mod(val, 1) == 0)
                        rowStrs(c) = sprintf('%d', val);
                    elseif isnumeric(val)
                        rowStrs(c) = sprintf('%.6f', val);
                    else
                        rowStrs(c) = string(val);
                    end
                end
                fprintf(fid, '| %s |\n', strjoin(rowStrs, " | "));
            end
            
            fclose(fid);
        end
    end
end