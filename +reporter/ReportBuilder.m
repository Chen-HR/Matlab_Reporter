classdef ReportBuilder < handle
    %REPORTBUILDER Constructs a Markdown report document programmatically.
    
    properties (SetAccess = private)
        % FilePath (1,1) string
        Content (:,1) string
    end
    
    methods % Initialize
        function obj = ReportBuilder()
            obj.Content = [];
        end
    end

    methods % Row
        function addLines(obj, lines)
            arguments
                obj
                lines (:,1) string
            end
            obj.Content = [obj.Content; lines];
        end
        function addLine(obj, line)
            arguments
                obj
                line (1,1) string = ""
            end
            obj.Content(end+1) = line;
        end
        
        function addText(obj, text)
            arguments
                obj
                text (1,1) string
            end
            obj.addLine(text);
            obj.addLine();
        end
        
        function addHeading(obj, text, level)
            arguments
                obj
                text (1,1) string
                level (1,1) double {mustBeInteger, mustBeInRange(level, 1, 6)} = 1
            end
            obj.addLine(repmat('#', 1, level) + " " + text);
            obj.addLine();
        end
        
        function addTable(obj, tableBuilder)
            arguments
                obj
                tableBuilder (1,1) reporter.TableBuilder
            end
            obj.addLines(tableBuilder.exportCodeLines_Markdown());
            obj.addLine();
        end
        
        function addMermaidXYChart(obj, chartBuilder)
            % ADDMERMAIDXYCHART Embeds a Mermaid XY Chart into the document.
            arguments
                obj
                chartBuilder (1,1) reporter.MermaidXYChartBuilder
            end
            obj.addLine("```mermaid");
            obj.addLines(chartBuilder.exportCodeLines());
            obj.addLine("```");
            obj.addLine();
        end
    end

    methods % Export
        function exportMarkdown(obj, filePath)
            arguments
                obj
                filePath (1,1) string
            end
            fid = fopen(filePath, 'w', 'n', 'UTF-8');
            if fid == -1
                error('reporter:ReportBuilder:FileAccessError', ...
                      'Cannot open file for writing: %s', filePath);
            end
            
            try
                fprintf(fid, "%s", strjoin(obj.Content, newline));
            catch ME
                fclose(fid);
                rethrow(ME);
            end
            fclose(fid);
        end
    end
end