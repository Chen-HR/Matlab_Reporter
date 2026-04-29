classdef ReportBuilder < handle
    %REPORTBUILDER Constructs a Markdown report document programmatically.
    
    properties (SetAccess = private)
        FilePath (1,1) string
        Content (:,1) string
    end
    
    methods
        function obj = ReportBuilder(filePath)
            arguments
                filePath (1,1) string
            end
            obj.FilePath = filePath;
            obj.Content = [];
        end
        
        function addHeading(obj, text, level)
            arguments
                obj
                text (1,1) string
                level (1,1) double {mustBeInteger, mustBeInRange(level, 1, 6)} = 1
            end
            prefix = repmat('#', 1, level);
            obj.Content(end+1) = prefix + " " + text + newline;
        end
        
        function addText(obj, text)
            arguments
                obj
                text (1,1) string
            end
            obj.Content(end+1) = text + newline;
        end
        
        function addTable(obj, tableBuilder)
            arguments
                obj
                tableBuilder (1,1) reporter.TableBuilder
            end
            
            headerStr = "| " + strjoin(tableBuilder.Headers, " | ") + " |";
            sepStr = "| " + strjoin(repmat("---", 1, length(tableBuilder.Headers)), " | ") + " |";
            
            obj.Content(end+1) = headerStr;
            obj.Content(end+1) = sepStr;
            
            for i = 1:size(tableBuilder.Rows, 1)
                strRow = cellfun(@(x) string(x), tableBuilder.Rows(i, :));
                rowStr = "| " + strjoin(strRow, " | ") + " |";
                obj.Content(end+1) = rowStr;
            end
            obj.Content(end+1) = "";
        end
        
        function exportMarkdown(obj)
            fid = fopen(obj.FilePath, 'w', 'n', 'UTF-8');
            if fid == -1
                error('reporter:ReportBuilder:FileAccessError', ...
                      'Cannot open file for writing: %s', obj.FilePath);
            end
            
            try
                for i = 1:length(obj.Content)
                    fprintf(fid, '%s\n', obj.Content(i));
                end
            catch ME
                fclose(fid);
                rethrow(ME);
            end
            fclose(fid);
        end
    end
end