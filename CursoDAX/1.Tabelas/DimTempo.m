let
    Source = #date(2022,1,1),
    Custom1 = List.Dates(Source,Number.From(DateTime.LocalNow()) - Number.From(Source),#duration(1,0,0,0)),
    #"Converted to Table" = Table.FromList(Custom1, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Columns" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Data"}}),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Renamed Columns", {{"Data", type date}}, "pt-BR"),
    #"Inserted Year" = Table.AddColumn(#"Changed Type with Locale", "Year", each Date.Year([Data]), Int64.Type),
    #"Inserted Month" = Table.AddColumn(#"Inserted Year", "Month", each Date.Month([Data]), Int64.Type),
    #"Inserted Month Name" = Table.AddColumn(#"Inserted Month", "Month Name", each Date.MonthName([Data]), type text),
    #"Inserted Quarter" = Table.AddColumn(#"Inserted Month Name", "Quarter", each Date.QuarterOfYear([Data]), Int64.Type),
    #"Inserted Day" = Table.AddColumn(#"Inserted Quarter", "Day", each Date.Day([Data]), Int64.Type),
    #"Inserted Day Name" = Table.AddColumn(#"Inserted Day", "Day Name", each Date.DayOfWeekName([Data]), type text),
    #"Renamed Columns1" = Table.RenameColumns(#"Inserted Day Name",{{"Year", "Ano"}, {"Month", "Mes"}, {"Month Name", "Mes por Extenso"}, {"Quarter", "Quatrimestre"}, {"Day", "Dia"}, {"Day Name", "Dia por Extenso"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns1", "Id", each [Ano] * 100 +[Dia]),
    #"Added Custom1" = Table.AddColumn(#"Added Custom", "MesAbr", each Date.ToText([Data],"MMM")),
    #"Inserted Merged Column" = Table.AddColumn(#"Added Custom1", "Mes-Ano", each Text.Combine({[MesAbr], "-", Text.From([Ano], "pt-BR")}), type text)
in
    #"Inserted Merged Column"