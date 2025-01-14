Attribute VB_Name = "Module1"
Sub QuarterlyStockAnalysis()
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim ticker As String
    Dim openPrice As Double, closePrice As Double
    Dim totalVolume As Double
    Dim outputRow As Long

    Dim maxIncrease As Double, maxDecrease As Double, maxVolume As Double
    Dim maxIncreaseTicker As String, maxDecreaseTicker As String, maxVolumeTicker As String

    For Each ws In ThisWorkbook.Sheets
        If ws.Name Like "Q*" Then
            lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

            Dim currentTicker As String
            Dim firstRow As Long, lastRowTicker As Long
            Dim i As Long

            firstRow = 2
            outputRow = 2
            maxIncrease = -1
            maxDecrease = 1
            maxVolume = 0
            maxIncreaseTicker = ""
            maxDecreaseTicker = ""
            maxVolumeTicker = ""

            ws.Range("I1:L1").Value = Array("Ticker", "Quarterly Change", "Percentage Change", "Total Volume")

            For i = 2 To lastRow + 1
                If ws.Cells(i, 1).Value <> ws.Cells(firstRow, 1).Value Or i > lastRow Then

                    currentTicker = ws.Cells(firstRow, 1).Value
                    openPrice = ws.Cells(firstRow, 3).Value
                    closePrice = ws.Cells(i - 1, 6).Value
                    totalVolume = Application.WorksheetFunction.Sum(ws.Range(ws.Cells(firstRow, 7), ws.Cells(i - 1, 7)))

                    ws.Cells(outputRow, 9).Value = currentTicker
                    ws.Cells(outputRow, 10).Value = closePrice - openPrice
                    If openPrice <> 0 Then
                        ws.Cells(outputRow, 11).Value = (closePrice - openPrice) / openPrice
                    Else
                        ws.Cells(outputRow, 11).Value = 0
                    End If
                    ws.Cells(outputRow, 12).Value = totalVolume

                    If ws.Cells(outputRow, 10).Value > 0 Then
                        ws.Cells(outputRow, 10).Interior.ColorIndex = 4
                    ElseIf ws.Cells(outputRow, 10).Value < 0 Then
                        ws.Cells(outputRow, 10).Interior.ColorIndex = 3
                    End If

                    If ws.Cells(outputRow, 11).Value > maxIncrease Then
                        maxIncrease = ws.Cells(outputRow, 11).Value
                        maxIncreaseTicker = currentTicker
                    End If

                    If ws.Cells(outputRow, 11).Value < maxDecrease Then
                        maxDecrease = ws.Cells(outputRow, 11).Value
                        maxDecreaseTicker = currentTicker
                    End If

                    If totalVolume > maxVolume Then
                        maxVolume = totalVolume
                        maxVolumeTicker = currentTicker
                    End If

                    outputRow = outputRow + 1

                    firstRow = i
                End If
            Next i

            ws.Range("O1:Q1").Value = Array("Category", "Ticker", "Value")
            ws.Cells(2, 15).Value = "Greatest % Increase"
            ws.Cells(2, 16).Value = maxIncreaseTicker
            ws.Cells(2, 17).Value = maxIncrease

            ws.Cells(3, 15).Value = "Greatest % Decrease"
            ws.Cells(3, 16).Value = maxDecreaseTicker
            ws.Cells(3, 17).Value = maxDecrease

            ws.Cells(4, 15).Value = "Greatest Total Volume"
            ws.Cells(4, 16).Value = maxVolumeTicker
            ws.Cells(4, 17).Value = maxVolume
        End If
    Next ws

    MsgBox "Quarterly stock analysis completed!"
End Sub
