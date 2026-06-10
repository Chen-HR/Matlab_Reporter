classdef MermaidDiscreteXYChartBuilder < reporter.MermaidXYChartBuilder
    %MERMAIDDISCRETEXYCHARTBUILDER XY Chart with categorical X-axis.
    
    properties
        Categories (1,:) string
    end
    
    methods
        function obj = MermaidDiscreteXYChartBuilder(categories, xAxisTitle, yAxisTitle, title)
            arguments
                categories (1,:) string
                xAxisTitle (1,1) string = ""
                yAxisTitle (1,1) string = ""
                title      (1,1) string = ""
            end
            obj@reporter.MermaidXYChartBuilder(xAxisTitle, yAxisTitle, title);
            obj.Categories = categories;
        end
        
        function str = formatXAxis(obj)
            str = "x-axis";
            if obj.XAxisTitle ~= ""
                str = str + " """ + obj.XAxisTitle + """";
            end
            catData = "[" + strjoin("""" + obj.Categories + """", ", ") + "]";
            str = str + " " + catData;
        end
    end
end