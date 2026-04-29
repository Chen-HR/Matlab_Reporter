# Matlab Reporter

A lightweight, object-oriented utility package for generating CSV tables and Markdown reports in MATLAB. This package is designed for general-purpose use and has no external dependencies.

## Core Components

The package resides in the `reporter` namespace:

1. **`reporter.TableBuilder`**: Manages tabular data.
2. **`reporter.ReportBuilder`**: Manages Markdown document structure.

## Quick Start Guide

```matlab
% 1. CSV Generation
tb = reporter.TableBuilder(["ID", "Value"]);
tb.addRow({1, 10.5});
tb.addRow({1, 10.5});
tb.addRow({1, 10.5});
tb.exportCSV("data.csv");

% 2. Markdown Generation
rb = reporter.ReportBuilder("Report.md");
rb.addHeading("System Report", 1);
rb.addText("Export Time: " + string(datetime("now")));
rb.addTable(tb);
rb.exportMarkdown();
```
