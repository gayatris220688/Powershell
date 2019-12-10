#Constructs dynamic HTML content for the Consumption scanner #
Function Get-HtmlContentForConsumptionInfo{
    param($datatable)

    [string]$htmlcontent = $null;

    if($null -ne $datatable)
    {
        foreach($row in $datatable)
        {
            $item = $null;
            $item = "<tr style='border: 1px solid black;font-size: small'>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.ResourceName) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.ResourceGroupName) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.ResourceType) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.ResourceLocation) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.UnitsConsumption) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.BillBeforeTax) + "</td>" +
                    "</tr>";

            if($item)
            {
                $htmlcontent+=$item;
            }
        }
    }

    return $htmlcontent;
}

#Constructs dynamic HTML content for the Log viewer #
Function Get-HtmlContentForLogsViewer{
    param($logsdata)

    [string]$htmlcontent = $null;

    if($null -ne $logsdata)
    {
        foreach($row in $logsdata)
        {
            $item = $null;
            $item = "<tr style='border: 1px solid black;font-size: small'>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.ResourceId) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.ResourceGroupName) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.OperationName) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.Status) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.EventBy) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.ApiRestMethod) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.Level) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.IPAddr) + "</td>" +
                    "<td style='border: 1px solid black;font-size: small''>"+ $($row.EventTime) + "</td>" +
                    "</tr>";

            if($item)
            {
                $htmlcontent+=$item;
            }
        }
    }

    return $htmlcontent;

}
