classdef MermaidContinuousXYChartBuilder < reporter.MermaidXYChartBuilder
    %MERMAIDCONTINUOUSXYCHARTBUILDER XY Chart with numeric range X-axis.
    
    properties
        XMin (1,1) double = 0
        XMax (1,1) double = 0
    end
    
    methods
        function obj = MermaidContinuousXYChartBuilder(xMin, xMax, xAxisTitle, yAxisTitle, title)
            arguments
                xMin       (1,1) double = 0
                xMax       (1,1) double = 0
                xAxisTitle (1,1) string = ""
                yAxisTitle (1,1) string = ""
                title      (1,1) string = ""
            end
            obj@reporter.MermaidXYChartBuilder(xAxisTitle, yAxisTitle, title);
            obj.XMin = xMin;
            obj.XMax = xMax;
        end
        
        function str = formatXAxis(obj)
            str = "x-axis";
            if obj.XAxisTitle ~= "" || obj.XMin ~= obj.XMax
                if obj.XAxisTitle ~= ""
                    str = str + " """ + obj.XAxisTitle + """";
                end
                if obj.XMin ~= obj.XMax && obj.XMin < obj.XMax
                    str = str + " " + string(obj.XMin) + " --> " + string(obj.XMax);
                end
            else
                str = "%% " + str;
            end
        end
    end
end