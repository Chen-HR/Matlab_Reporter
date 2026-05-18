classdef (Abstract) MermaidXYChartBuilder < handle
    %MERMAIDXYCHARTBUILDER Abstract base class for generating Mermaid xychart-beta code.
    
    properties (SetAccess = protected)
        Title      (1,1) string
        XAxisTitle (1,1) string
        YAxisTitle (1,1) string
        YMin       (1,1) double
        YMax       (1,1) double
        UseYRange  (1,1) logical = false
        Series     (:,1) struct % Fields: type (line/bar), label, data (double array)
    end
    
    methods
        function obj = MermaidXYChartBuilder(title, xAxisTitle, yAxisTitle)
            arguments
                title      (1,1) string
                xAxisTitle (1,1) string
                yAxisTitle (1,1) string
            end
            obj.Title = title;
            obj.XAxisTitle = xAxisTitle;
            obj.YAxisTitle = yAxisTitle;
            obj.Series = struct('type', {}, 'label', {}, 'data', {});
        end
        
        function setYAxisRange(obj, yMin, yMax)
            arguments
                obj
                yMin (1,1) double
                yMax (1,1) double
            end
            obj.YMin = yMin;
            obj.YMax = yMax;
            obj.UseYRange = true;
        end
        
        function addBar(obj, label, data)
            arguments
                obj
                label (1,1) string
                data (:,1) double
            end
            obj.Series(end+1) = struct('type', "bar", 'label', label, 'data', data);
        end
        
        function addLine(obj, label, data)
            arguments
                obj
                label (1,1) string
                data (:,1) double
            end
            obj.Series(end+1) = struct('type', "line", 'label', label, 'data', data);
        end
        
        function exportMermaid(obj, filePath)
            % EXPORTMERMAID Writes the Mermaid code block to a standalone file.
            arguments
                obj
                filePath (1,1) string
            end
            fid = fopen(filePath, 'w', 'n', 'UTF-8');
            if fid == -1, error("Cannot open file for writing."); end
            fprintf(fid, "```mermaid\n%s\n```", obj.generateMermaidCode());
            fclose(fid);
        end
    end
    
    methods (Abstract)
        % GENERATEMERMAIDCODE Internal logic to construct the DSL string.
        code = generateMermaidCode(obj)
    end
    
    methods (Access = protected)
        function str = formatText(~, text)
            % Wraps text in quotes if it contains spaces or special characters.
            if contains(text, " ") || text == ""
                str = """" + text + """";
            else
                str = text;
            end
        end
        
        function str = formatYAxis(obj)
            str = "y-axis " + obj.formatText(obj.YAxisTitle);
            if obj.UseYRange
                str = str + " " + string(obj.YMin) + " --> " + string(obj.YMax);
            end
        end
        
        function str = formatSeries(obj)
            lines = [];
            for i = 1:length(obj.Series)
                s = obj.Series(i);
                dataStr = "[" + strjoin(string(s.data), ", ") + "]";
                % Mermaid xychart line/bar syntax: line "Label" [data]
                lines = [lines; "    " + s.type + " " + obj.formatText(s.label) + " " + dataStr];
            end
            str = strjoin(lines, newline);
        end
    end
end