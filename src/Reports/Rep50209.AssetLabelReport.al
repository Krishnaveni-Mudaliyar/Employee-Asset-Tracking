report 50209 "Asset Label Report"
{
    ApplicationArea = All;
    Caption = 'Asset Labels';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = LabelRDLC;
    dataset
    {
        dataitem(FixedAsset; "Fixed Asset")
        {
            RequestFilterFields = "No.", "Asset Category Code", "IT Location Code", "IT Asset Status";

            column(AssetNo; "No.") { }
            column(Description; Description) { }
            column(AssetTagNo; "IT Asset Tag No.") { }
            column(SerialNo; "IT Serial No.") { }
            column(BarCodeValue; BarcodeValue) { }
            column(BarcodeText; BarcodeText) { }

            trigger OnAfterGetRecord()
            var
                BarcodeFontProvider: Interface "Barcode Font Provider";
                BarcodeSymbology: Enum "Barcode Symbology";
            begin
                BarcodeValue := "IT Asset Tag No.";
                if BarcodeValue = '' then
                    BarcodeValue := "No.";

                BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
                BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
                BarcodeFontProvider.ValidateInput(BarcodeValue, BarcodeSymbology);
                BarcodeText := BarcodeFontProvider.EncodeFont(BarcodeValue, BarcodeSymbology);
            end;
        }
    }
    rendering
    {
        layout(LabelRDLC)
        {
            Type = RDLC;
            LayoutFile = 'src\Report Layouts\AssetLabelReport.rdl';
            Caption = 'Asset Label (RDLC)';
        }
    }

    var
        BarcodeValue: Text;
        BarcodeText: Text;
}