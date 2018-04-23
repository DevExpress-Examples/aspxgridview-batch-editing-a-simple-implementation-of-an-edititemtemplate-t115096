<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v14.1, Version=14.1.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">
        function Grid_BatchEditStartEditing(s, e) {
            var productNameColumn = s.GetColumnByField("C1");
            if (!e.rowValues.hasOwnProperty(productNameColumn.index))
                return;
            var cellInfo = e.rowValues[productNameColumn.index];
            C1spinEdit.SetValue(cellInfo.value);
            if (e.focusedColumn === productNameColumn)
                C1spinEdit.SetFocus();
        }
        function Grid_BatchEditEndEditing(s, e) {
            var productNameColumn = s.GetColumnByField("C1");
            if (!e.rowValues.hasOwnProperty(productNameColumn.index))
                return;
            var cellInfo = e.rowValues[productNameColumn.index];
            cellInfo.value = C1spinEdit.GetValue();
            cellInfo.text = C1spinEdit.GetText();
            C1spinEdit.SetValue(null);
        }
        function Grid_BatchEditRowValidating(s, e) {
            var productNameColumn = s.GetColumnByField("C1");
            var cellValidationInfo = e.validationInfo[productNameColumn.index];
            if (!cellValidationInfo) return;
            var value = cellValidationInfo.value;
            if (!ASPxClientUtils.IsExists(value) || ASPxClientUtils.Trim(value) === "") {
                cellValidationInfo.isValid = false;
                cellValidationInfo.errorText = "C1 is required";
            }
        }

        var preventEndEditOnLostFocus = false;
        function C1spinEdit_KeyDown(s, e) {
            var keyCode = ASPxClientUtils.GetKeyCode(e.htmlEvent);
            if (keyCode !== 9 && keyCode !== 13) return; 
            var moveActionName = e.htmlEvent.shiftKey ? "MoveFocusBackward" : "MoveFocusForward";
            if (grid.batchEditApi[moveActionName]()) {
                ASPxClientUtils.PreventEventAndBubble(e.htmlEvent);
                preventEndEditOnLostFocus = true;
            }
        }
        function C1spinEdit_LostFocus(s, e) {
            if (!preventEndEditOnLostFocus)
                grid.batchEditApi.EndEdit();
            preventEndEditOnLostFocus = false;
        }
    </script>

</head>
<body>
    <form id="frmMain" runat="server">
        <dx:ASPxGridView ID="Grid" runat="server" KeyFieldName="ID" OnBatchUpdate="Grid_BatchUpdate" Width="600"
            OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting" ClientInstanceName="grid">
            <ClientSideEvents BatchEditStartEditing="Grid_BatchEditStartEditing" BatchEditEndEditing="Grid_BatchEditEndEditing"
                BatchEditRowValidating="Grid_BatchEditRowValidating" />
            <Columns>
                <dx:GridViewCommandColumn Width="70" ShowNewButtonInHeader="true" ShowDeleteButton="true" />
                <dx:GridViewDataColumn  Width="100" FieldName="C1">
                    <EditItemTemplate>
                        <dx:ASPxSpinEdit ID="C1_spinEdit" runat="server" ClientInstanceName="C1spinEdit" Width="100%">
                            <ClientSideEvents KeyDown="C1spinEdit_KeyDown" LostFocus="C1spinEdit_LostFocus" />
                        </dx:ASPxSpinEdit>
                    </EditItemTemplate>
                </dx:GridViewDataColumn>
                <dx:GridViewDataSpinEditColumn  Width="100" FieldName="C2"/>
                <dx:GridViewDataTextColumn Width="100" FieldName="C3" />
                <dx:GridViewDataCheckColumn Width="100" FieldName="C4" />
                <dx:GridViewDataDateColumn Width="100" FieldName="C5" />
            </Columns>
            <SettingsEditing Mode="Batch" />
        </dx:ASPxGridView>
    </form>
</body>
</html>
