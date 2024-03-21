{
}
unit userscript;

var
    slData: TStringList;

function Initialize: integer;
begin
    slData := TStringList.Create;
end;

function Process(e: IInterface): integer;
var
    i: integer;
    s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature: string;
    m, subRecord1, subRecord1M, subRecord2, subRecord2M, subRecord3, subRecord3M, subRecord4, subRecord4M: IInterface;
begin
    // skip item if the selection is the master
    m := Master(e);
    if not Assigned(m) then m := e;
    //if not Assigned(m) then Exit;

    s := '';

    // the current plugin the processing record exists in
    sCurrentPlugin := GetFileName(e);
    //slData.Add('Current Plugin: ' + sCurrentPlugin);

    // the master of the current record
    sMasterPlugin := GetFileName(MasterOrSelf(e));
    sEditorID := EditorID(MasterOrSelf(e));
    sSignature := Signature(e);
    //slData.Add('Master Plugin: ' + sMasterPlugin);
    //slData.Add('EditorID: ' + sEditorID);
    //slData.Add('Record Type: ' + sSignature);

    // add additional elements here
    // "FULL - Name"
    AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'FULL');
    // "DESC - Description"
    AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'DESC');
    if sSignature = 'ACTI' then begin
        // "RNAM - Activate Text Override"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'RNAM');
    end else
    if sSignature = 'BOOK' then begin
        // "CNAM - Description"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'CNAM');
    end else
    if sSignature = 'FLOR' then begin
        // "RNAM - Activate Text Override"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'RNAM');
    end else
    if sSignature = 'GMST' then begin
        // "DATA - Value" \ "Bool"
        //AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'DATA\Bool');
        // "DATA - Value" \ "Float"
        //AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'DATA\Float');
        // "DATA - Value" \ "Int"
        //AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'DATA\Int');
        // "DATA - Value" \ "Name"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'DATA\Name');
    end else
    if sSignature = 'INFO' then begin
        // "Responses" \ i "Response" \ "NAM1 - Response Text"
        if ElementExists (e, 'Responses') then begin
            subRecord1 := ElementByName(e, 'Responses');
            subRecord1M := ElementByName(e, 'Responses');
            for i:= 0 to ElementCount(subRecord1) - 1 do begin
                subRecord2 := ElementByIndex(subRecord1, i);
                subRecord2M := ElementByIndex(subRecord1M, i);
                AddDataByPath(subRecord2, subRecord2M, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'NAM1');
            end;
        end;
        // "RNAM - Prompt"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'RNAM');
    end else
    if sSignature = 'MESG' then begin
    // "Menu Buttons" \ i "Menu Button" \ "ITXT - Button Text"
        if ElementExists (e, 'Menu Buttons') then begin
            subRecord1 := ElementByName(e, 'Menu Buttons');
            subRecord1M := ElementByName(m, 'Menu Buttons');
            for i := 0 to ElementCount(subRecord1) - 1 do begin
                subRecord2 := ElementByIndex(subRecord1, i);
                subRecord2M := ElementByIndex(subRecord1M, i);
                AddDataByPath(subRecord2, subRecord2M, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'ITXT');
            end;
        end;
    end else
    if sSignature = 'MGEF' then begin
        // "DNAM - Magic Item Description"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'DNAM');
    end else
    if sSignature = 'NPC_' then begin
        // "SHRT - Short Name"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'SHRT');
    end else
    if sSignature = 'PERK' then begin
        // "Effects (sorted) \ i "Effect" \ "Function Parameters" \ "EPFD - Data" \ "Text"
        if ElementExists (e, 'Effects') then begin
            subRecord1 := ElementByName(e, 'Effects');
            subRecord1M := ElementByName(e, 'Effects');
            for i:= 0 to ElementCount(subRecord1) - 1 do begin
                subRecord2 := ElementByIndex(subRecord1, i);
                subRecord2M := ElementByIndex(subRecord1M, i);
                AddDataByPath(subRecord2, subRecord2M, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'EPFD\Text');
            end;
        end;
    end else
    if sSignature = 'QUST' then begin
        // "Stages (sorted)" \ i "Stage" \ "Log Entries" \ i "Log Entry" \ "CNAM - Log Entry"
        if ElementExists (e, 'Stages') then begin
            subRecord1 := ElementByName(e, 'Effects');
            subRecord1M := ElementByName(e, 'Effects');
            for i:= 0 to ElementCount(subRecord1) - 1 do begin
                subRecord2 := ElementByIndex(subRecord1, i);
                subRecord2M := ElementByIndex(subRecord1M, i);
                if ElementExists (e, 'Log Entries') then begin
                    subRecord3 := ElementByName(subRecord2, 'Log Entries');
                    subRecord3M := ElementByName(subRecord2M, 'Log Entries');
                    for i:= 0 to ElementCount(subRecord3) - 1 do begin
                        subRecord4 := ElementByIndex(subRecord3, i);
                        subRecord4M := ElementByIndex(subRecord3M, i);
                        AddDataByPath(subRecord4, subRecord4M, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'CNAM');
                    end;
                end;
            end;
        end;
        // "NNAM - Description"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'NNAM');
    end else
    if sSignature = 'REGN' then begin
        // "Region Data Entries (sorted)" \ i "Region Data Entry" \ "RDMP - Map Name"
        if ElementExists (e, 'Effects') then begin
            subRecord1 := ElementByName(e, 'Effects');
            subRecord1M := ElementByName(e, 'Effects');
            for i:= 0 to ElementCount(subRecord1) - 1 do begin
                subRecord2 := ElementByIndex(subRecord1, i);
                subRecord2M := ElementByIndex(subRecord1M, i);
                AddDataByPath(subRecord2, subRecord2M, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'RDMP');
            end;
        end;
    end else
    if sSignature = 'WOOP' then begin
        // "TNAM - Translation"
        AddDataByPath(e, m, s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, 'TNAM');
    end
end;

procedure AddDataByPath(e, m: IInterface; s, sCurrentPlugin, sMasterPlugin, sEditorID, sSignature, path: string);
begin
    if not ElementExists(e, path) then Exit;
    slData.Add('[STRING]');
    slData.Add('Current Plugin: ' + sCurrentPlugin);
    slData.Add('Master Plugin: ' + sMasterPlugin);
    slData.Add('EditorID: ' + sEditorID);
    slData.Add('Record Type: ' + sSignature);
    slData.Add('Data Type: ' + path);
    s := GetElementEditValues(m, path);
    s := StringReplace(s, #13#10, '\n', [rfReplaceAll]);
    //s := StringReplace(s, #9, '\t', [rfReplaceAll]);
    slData.Add('Master Value: ' + s);
    s := GetElementEditValues(e, path);
    s := StringReplace(s, #13#10, '\n', [rfReplaceAll]);
    //s := StringReplace(s, #9, '\t', [rfReplaceAll]);
    slData.Add('Current Value: ' + s);
    slData.Add('');
end;

function Finalize: integer;
var
    dlgSave: TSaveDialog;
begin
    //AddMessage(slData.Text);
    if (slData.Count > 0) then begin
 
        // ask for file to export to
        dlgSave := TSaveDialog.Create(nil);
        dlgSave.Options := dlgSave.Options + [ofOverwritePrompt];
        dlgSave.Filter := 'Text files (*.txt)|*.txt';
        dlgSave.InitialDir := ProgramPath;
        dlgSave.FileName := 'DSDifyer Output.txt';
        if dlgSave.Execute then
            slData.SaveToFile(dlgSave.FileName);
        dlgSave.Free;
 
    end;
    slData.Free;
end;

end.
