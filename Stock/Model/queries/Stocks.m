let
    Source = Excel.Workbook(File.Contents("C:\Users\jerem\Desktop\Stocks to watch list companies.xlsx"), null, true),
    Stocks_Sheet = Source{[Item="Stocks",Kind="Sheet"]}[Data],
    #"Changed Type" = Table.TransformColumnTypes(Stocks_Sheet,{{"Column1", type text}, {"Column2", type any}, {"Column3", type date}, {"Column4", type any}, {"Column5", type any}, {"Column6", type any}, {"Column7", type date}, {"Column8", type date}}),
    #"Promoted Headers" = Table.PromoteHeaders(#"Changed Type", [PromoteAllScalars=true]),
    #"Changed Type1" = Table.TransformColumnTypes(#"Promoted Headers",{{"Stock", type text}, {"Target $", type number}, {"10/13/2020", type date}, {"11/4/2020", type number}, {"11/24/2020", type number}, {"12/22/2020", type number}, {"12/24/2020", type date}, {"12/29/2020", type date}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type1",{"Target $", "10/13/2020", "11/4/2020", "11/24/2020", "12/22/2020", "12/24/2020", "12/29/2020"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Removed Columns", "Pull", each #"Quote Pull"([Stock])),
    #"Expanded Pull" = Table.ExpandTableColumn(#"Invoked Custom Function", "Pull", {"Date", "Open", "High", "Low", "Close", "Adj Close", "Volume"}, {"Date", "Open", "High", "Low", "Close", "Adj Close", "Volume"}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Expanded Pull",{{"Date", type date}, {"Open", Currency.Type}, {"High", Currency.Type}, {"Low", Currency.Type}, {"Close", Currency.Type}, {"Adj Close", Currency.Type}, {"Volume", Int64.Type}})
in
    #"Changed Type2"