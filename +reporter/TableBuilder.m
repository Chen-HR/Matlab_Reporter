classdef TableBuilder < handle
    %TABLEBUILDER Utility class for constructing and exporting tabular data.
    
    properties (SetAccess = private)
        Headers (1,:) string
        Rows (:,:) cell
    end
    
    methods
        function obj = TableBuilder(headers)
            arguments
                headers (1,:) string
            end
            obj.Headers = headers;
            obj.Rows = {};
        end
        
        function addRow(obj, rowData)
            arguments
                obj
                rowData (1,:) cell
            end
            if length(rowData) ~= length(obj.Headers)
                error('reporter:TableBuilder:DimensionMismatch', ...
                      'Row data length (%d) must match headers length (%d).', ...
                      length(rowData), length(obj.Headers));
            end
            obj.Rows(end+1, :) = rowData;
        end
    end

    methods % Export
        function lines = exportCodeLines_CSV(obj)
            lines = [strjoin(obj.Headers, ',')];
            for i = 1:size(obj.Rows, 1)
                lines(end+1) = strjoin(cellfun(@(x) string(x), obj.Rows(i, :)), ',');
            end
        end
        function lines = exportCodeLines_Markdown(obj)
            lines = ["| " + strjoin(obj.Headers, " | ") + " |"; "| " + strjoin(repmat("---", 1, length(obj.Headers)), " | ") + " |"];
            for i = 1:size(obj.Rows, 1)
                lines(end+1) = "| " + strjoin(cellfun(@(x) string(x), obj.Rows(i, :)), " | ") + " |";
            end
        end
        
        function exportCSV(obj, filePath)
            arguments
                obj
                filePath (1,1) string
            end
            
            fid = fopen(filePath, 'w', 'n', 'UTF-8');
            if fid == -1
                error('reporter:TableBuilder:FileAccessError', ...
                      'Cannot open file for writing: %s', filePath);
            end
            
            try
                fprintf(fid, "%s", obj.exportCodeLines_CSV());
            catch ME
                fclose(fid);
                rethrow(ME);
            end
            fclose(fid);
        end
        function exportMarkdown(obj, filePath)
            arguments
                obj
                filePath (1,1) string
            end
            
            fid = fopen(filePath, 'w', 'n', 'UTF-8');
            if fid == -1
                error('reporter:TableBuilder:FileAccessError', ...
                      'Cannot open file for writing: %s', filePath);
            end
            
            try
                fprintf(fid, "%s", obj.exportCodeLines_Markdown());
            catch ME
                fclose(fid);
                rethrow(ME);
            end
            fclose(fid);
        end
    end
end