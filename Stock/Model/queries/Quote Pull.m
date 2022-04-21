(StockQuote as text) as table =>

let
    Source = Csv.Document(Web.Contents("https://query1.finance.yahoo.com/v7/finance/download/"&StockQuote&"?period1=1642550400&period2=1650326400&interval=1wk&events=history&includeAdjustedClose=true"),[Delimiter=",", Columns=7, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Date", type date}, {"Open", type number}, {"High", type number}, {"Low", type number}, {"Close", type number}, {"Adj Close", type number}, {"Volume", Int64.Type}})
in
    #"Changed Type"