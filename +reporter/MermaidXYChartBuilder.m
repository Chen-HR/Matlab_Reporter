classdef (Abstract) MermaidXYChartBuilder < handle
    %MERMAIDXYCHARTBUILDER Abstract base class for generating Mermaid xychart-beta code.
    
    properties (SetAccess = protected)
        Indent     (1,1) string = "  "
        Series     (1,:) struct % Fields: type (line/bar), label, data (double array)
        
        XAxisTitle (1,1) string = ""
        
        YAxisTitle (1,1) string = ""
        YMin       (1,1) double = 0
        YMax       (1,1) double = 0
        
        Title      (1,1) string = ""
    end
    
    methods % Initialize
        function obj = MermaidXYChartBuilder(xAxisTitle, yAxisTitle, title)
            arguments
                xAxisTitle (1,1) string = ""
                yAxisTitle (1,1) string = ""
                title      (1,1) string = ""
            end
            obj.Title = title;
            obj.XAxisTitle = xAxisTitle;
            obj.YAxisTitle = yAxisTitle;
            obj.Series = struct('type', {}, 'label', {}, 'data', {});
        end
        
        function setIndent(obj, indent)
            arguments
                obj
                indent (1,1) string
            end
            obj.Indent = indent;
        end

        function setYAxisRange(obj, yMin, yMax)
            arguments
                obj
                yMin (1,1) double
                yMax (1,1) double
            end
            % check min < max
            if yMin < yMax
                obj.YMin = yMin;
                obj.YMax = yMax;
            else
                error('reporter.MermaidXYChartBuilder.setYAxisRange: Invalid range');
            end
        end
    end

    methods % Row
        function addRow(obj, type, label, data)
            arguments
                obj
                type (1,1) string
                label (1,1) string
                data (:,1) double
            end
            obj.Series(end+1) = struct('type', type, 'label', label, 'data', data);
        end
        
        function addBar(obj, label, data)
            arguments
                obj
                label (1,1) string
                data (:,1) double
            end
            obj.addRow("bar", label, data);
        end
        
        function addPoint(obj, label, data)
            arguments
                obj
                label (1,1) string
                data (:,1) double
            end
            obj.addRow("point", label, data);
        end
        
        function addLine(obj, label, data)
            arguments
                obj
                label (1,1) string
                data (:,1) double
            end
            obj.addRow("line", label, data);
        end
    end

    methods % Export
        function lines = exportCodeLines(obj)
            lines = ["xychart-beta"; obj.Indent + [obj.formatTitle(); obj.formatXAxis(); obj.formatYAxis(); obj.formatSeries()]];
        end
        function exportMermaid(obj, filePath)
            % EXPORTMERMAID Writes the Mermaid code block to a standalone file.
            arguments
                obj
                filePath (1,1) string
            end
            fid = fopen(filePath, 'w', 'n', 'UTF-8');
            if fid == -1, error("Cannot open file for writing."); end
            fprintf(fid, "%s", strjoin(obj.exportCodeLines(), newline));
            fclose(fid);
        end
    end
    
    methods (Abstract)
        str = formatXAxis(obj)
    end
    
    methods (Access = protected) % Format
        function str = formatTitle(obj)
            str = "title";
            if obj.Title ~= ""
                str = str + " """ + obj.Title + """";
            else
                str = "%% " + str;
            end
        end

        function str = formatYAxis(obj)
            str = "y-axis";
            if obj.YAxisTitle ~= "" || obj.YMin ~= obj.YMax
                if obj.YAxisTitle ~= ""
                    str = str + " """ + obj.YAxisTitle + """";
                end
                if obj.YMin ~= obj.YMax && obj.YMin < obj.YMax
                    str = str + " " + string(obj.YMin) + " --> " + string(obj.YMax);
                end
            else
                str = "%% " + str;
            end
        end
        
        function lines = formatSeries(obj)
            lines = strings(length(obj.Series), 1);
            for i = 1:length(obj.Series)
                s = obj.Series(i);
                lines(i) = s.type + " """ + s.label + """ " + "[" + strjoin(string(s.data), ", ") + "]";
            end
            % str = strjoin(lines, newline);
        end
    end
end