# Matlab Reporter

A lightweight, object-oriented utility package for generating CSV tables and Markdown reports (with embedded Mermaid.js XY charts) in MATLAB. This package is designed for general-purpose reporting and has no external dependencies.

## Core Components

The package resides in the `reporter` namespace:

1. **`reporter.ReportBuilder`**: Structural engine for building and managing Markdown document composition.
2. **`reporter.TableBuilder`**: Utility for constructing tabular data and exporting to CSV or Markdown formats.
3. **`reporter.MermaidXYChartBuilder`**: Abstract base class for generating Mermaid `xychart-beta` code blocks.
   - **`reporter.MermaidDiscreteXYChartBuilder`**: Implementation for charts with categorical (discrete) X-axis labels.
   - **`reporter.MermaidContinuousXYChartBuilder`**: Implementation for charts with numerical range (continuous) X-axis.

## Quick Start Guide

### 1. Table and Document Generation

```matlab
% Initialize Table
tb = reporter.TableBuilder(["ID", "Metric", "Score"]);
tb.addRow({1, "Latency", 10.5});
tb.addRow({2, "Throughput", 95.2});
tb.addRow({3, "Packet Loss", 0.02});

% Export standalone CSV
tb.exportCSV("data.csv");

% Initialize Report
rb = reporter.ReportBuilder();
rb.addHeading("System Performance Report", 1);
rb.addText("Generated on: " + string(datetime("now", "Format", "yyyy-MM-dd HH:mm:ss")));

% Embed Table in Markdown
rb.addTable(tb);
rb.exportMarkdown("Report.md");
```

### 2. Embedded Mermaid XY Charts

The package supports generating nested `xychart-beta` configurations directly into Markdown reports.

#### Discrete (Categorical) X-Axis Chart

Use `MermaidDiscreteXYChartBuilder` when X-axis labels represent fixed categories.

```matlab
categories = ["Jan", "Feb", "Mar", "Apr", "May"];
chart = reporter.MermaidDiscreteXYChartBuilder(categories, "Months", "Revenue ($)", "Monthly Sales");

% Add series data (type, label, data array)
chart.addBar("Product A", [100; 120; 115; 130; 145]);
chart.addLine("Product B", [80; 95; 110; 105; 125]);

% Embed in report
rb = reporter.ReportBuilder();
rb.addHeading("Sales Performance", 2);
rb.addMermaidXYChart(chart);
rb.exportMarkdown("Sales_Report.md");
```

#### Continuous (Numerical Range) X-Axis Chart

Use `MermaidContinuousXYChartBuilder` when X-axis represents a numeric range (e.g., lower bound to upper bound).

```matlab
xMin = 0;
xMax = 100;
chart = reporter.MermaidContinuousXYChartBuilder(xMin, xMax, "Distance (m)", "Signal Strength (dBm)", "Path Loss");
chart.setYAxisRange(-100, 0); % Set custom Y-axis limits

chart.addLine("Tx 1", [-20; -45; -60; -75; -90]);

rb = reporter.ReportBuilder();
rb.addHeading("RF Signal Analysis", 2);
rb.addMermaidXYChart(chart);
rb.exportMarkdown("RF_Report.md");
```

## Complete Integration Example

The following example demonstrates how to integrate tables, text, headings, and dynamic discrete XY charts into a single unified Markdown report.

```matlab
% 1. Prepare Table Data
tb = reporter.TableBuilder(["Station", "Temperature (C)", "Status"]);
tb.addRow({"North-01", 23.4, "Optimal"});
tb.addRow({"South-02", 28.1, "Warning"});
tb.addRow({"West-03", 19.5, "Optimal"});

% 2. Prepare Chart Data
categories = ["08:00", "12:00", "16:00", "20:00"];
chart = reporter.MermaidDiscreteXYChartBuilder(categories, "Time of Day", "Temp (C)", "Daily Temperature Variations");
chart.addLine("North-01", [20.1; 23.4; 22.8; 19.8]);
chart.addLine("South-02", [24.5; 28.1; 27.3; 25.0]);

% 3. Compose Report
rb = reporter.ReportBuilder();
rb.addHeading("Environmental Monitoring Summary", 1);
rb.addText("This document provides telemetry updates across remote weather monitoring station systems.");

rb.addHeading("Latest Readings", 2);
rb.addTable(tb);

rb.addHeading("Temperature Trends", 2);
rb.addMermaidXYChart(chart);

% 4. Save file
rb.exportMarkdown("Environmental_Report.md");
```
