classdef MermaidContinuousXYChartBuilder < reporter.MermaidXYChartBuilder
    %MERMAIDCONTINUOUSXYCHARTBUILDER XY Chart with numeric range X-axis.
    
    properties
        XMin (1,1) double
        XMax (1,1) double
    end
    
    methods
        function obj = MermaidContinuousXYChartBuilder(title, xAxisTitle, yAxisTitle, xMin, xMax)
            arguments
                title      (1,1) string
                xAxisTitle (1,1) string
                yAxisTitle (1,1) string
                xMin       (1,1) double
                xMax       (1,1) double
            end
            obj@reporter.MermaidXYChartBuilder(title, xAxisTitle, yAxisTitle);
            obj.XMin = xMin;
            obj.XMax = xMax;
        end
        
        function code = generateMermaidCode(obj)
            xAxisStr = "x-axis " + obj.formatText(obj.XAxisTitle) + " " + string(obj.XMin) + " --> " + string(obj.XMax);
            
            code = "xychart" + newline + ...
                   "    title " + obj.formatText(obj.Title) + newline + ...
                   "    " + xAxisStr + newline + ...
                   "    " + obj.formatYAxis() + newline + ...
                   obj.formatSeries();
        end
    end
end