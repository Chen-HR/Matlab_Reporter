classdef MermaidDiscreteXYChartBuilder < reporter.MermaidXYChartBuilder
    %MERMAIDDISCRETEXYCHARTBUILDER XY Chart with categorical X-axis.
    
    properties
        Categories (1,:) string
    end
    
    methods
        function obj = MermaidDiscreteXYChartBuilder(title, xAxisTitle, yAxisTitle, categories)
            arguments
                title      (1,1) string
                xAxisTitle (1,1) string
                yAxisTitle (1,1) string
                categories (1,:) string
            end
            obj@reporter.MermaidXYChartBuilder(title, xAxisTitle, yAxisTitle);
            obj.Categories = categories;
        end
        
        function code = generateMermaidCode(obj)
            catStrs = arrayfun(@(x) obj.formatText(x), obj.Categories);
            xAxisStr = "x-axis " + obj.formatText(obj.XAxisTitle) + " [""" + strjoin(catStrs, """, """) + """]";
            
            code = "xychart" + newline + ...
                   "    title " + obj.formatText(obj.Title) + newline + ...
                   "    " + xAxisStr + newline + ...
                   "    " + obj.formatYAxis() + newline + ...
                   obj.formatSeries();
        end
    end
end