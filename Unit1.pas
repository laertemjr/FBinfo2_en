unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Data.DB, StrUtils, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Consts,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBWrapper, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, FireDAC.Comp.UI, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Winapi.ShellAPI;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    lblFBserver: TLabel;
    Label3: TLabel;
    lbODS: TLabel;
    Label4: TLabel;
    lbFBv: TLabel;
    lblPorta: TLabel;
    lblPS: TLabel;
    Label5: TLabel;
    lblDialetoSQL: TLabel;
    edtBD: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    FDConnection1: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDIBInfo1: TFDIBInfo;
    lblFBPath: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure conectParams();
    procedure FormActivate(Sender: TObject);
    procedure clean();
    function verifySpaces(path:string) : string;
  private
    { Private declarations }
    const port:array[0..3] of string = ('3055', '3030','3025', '3015');
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  // To use with FDIBInfo1.GetVersion()
  rVer : TIBInfo.TVersion;
  rConf : TIBInfo.TConfig;

implementation

uses uGlobal;
{$R *.dfm}

{
•  Servidor Firebird 5.0: port 3055, compatible with version 4.0
•	Servidor Firebird 3.0: port 3030
•	Servidor Firebird 2.5: port 3025, compatible with versions 2.1, 2.0
•	Servidor Firebird 1.5: port 3015, compatible with version 1.0
}

procedure TForm1.FormActivate(Sender: TObject);
begin
   // Parameters required to use FDIBInfo1
   FDIBInfo1.DriverLink := FDPhysFBDriverLink1;
   FDIBInfo1.Host := '127.0.0.1';
   FDIBInfo1.Protocol := ipTCPIP;
   clean;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i, x:integer;
  s, pathExe, pathBD, pathTXT, vODS, vODS_temp :string;
  parametros:PChar;
begin
  clean;
  OpenDialog1.Filter := 'Firebird databases|*.GDB;*.FDB;';

  if OpenDialog1.Execute then
  begin
    for i:= 0 to High(port) do
    begin
    try
      edtBD.Text := OpenDialog1.FileName;
      s := UpperCase(RightStr(edtBD.Text,3));
      if (s <> 'FDB') AND (s <> 'GDB')then
      begin
        ShowMessage('It´s not a Firebird database.');
        edtBD.Text := EmptyStr;
        Break;
      end;

      conectParams;
      // DB path
      FDConnection1.Params.Add('Database=' + edtBD.Text);
      // Port
      FDConnection1.Params.Add('Port=' + port[i]);
      FDIBInfo1.Port := StrToInt(port[i]);
      FDConnection1.Connected := True;
      lblPorta.Caption := 'Port: ' + port[i];

      FDIBInfo1.UserName := 'sysdba';
      FDIBInfo1.Password := 'masterkey';
      FDIBInfo1.GetVersion(rVer);
      lblFBserver.Caption := rVer.FServerStr;

      FDIBInfo1.UserName := 'sysdba';
      FDIBInfo1.Password := 'masterkey';
      FDIBInfo1.GetConfig(rConf);
      lblFBPath.Caption  := rConf.FServerPath;

      s := lblFBPath.Caption;
      if (Pos('3_',s) <> 0) or (Pos('4_',s) <> 0) or (Pos('5_',s) <> 0) then
         pathExe := lblFBPath.Caption + 'gstat.exe'
      else
         pathExe := lblFBPath.Caption + 'bin\gstat.exe';

      pathBD  := edtBD.Text;
      pathTXT := ExtractFilePath(Application.ExeName) + 'out.txt';
      pathExe := verifySpaces(pathExe);
      pathBD  := verifySpaces(pathBD);
      pathTXT := verifySpaces(pathTXT);

      {ShellExecute(0, nil, 'cmd.exe', PChar('/C ' + pathExe + ' -h -user SYSDBA -pass masterkey '
       + pathBD + ' > C:\Users\usuario\out.txt'), PChar(pathExe), SW_HIDE);}
      try
         parametros := PChar('/C ' + pathExe + ' -h -user SYSDBA -pass masterkey ' + pathBD + ' > ' + pathTXT);
         x := ShellExecuteAndWait(0, '', 'cmd.exe', parametros, PChar(pathExe), SW_HIDE, True);
      except
         on E:Exception do
         // Log('Error: '+E.Message);
      end;

      Memo1.Lines.LoadFromFile(pathTXT);

      for x := 0 to Pred(Memo1.Lines.Count) do
      begin
         if (Memo1.Lines.Strings[x].Contains('ODS') = True) then
            lbODS.Caption := RemoveSpaces(Memo1.Lines.Strings[x]);

         if (Memo1.Lines.Strings[x].Contains('Page size') = True) then
            lblPS.Caption := RemoveSpaces(Memo1.Lines.Strings[x]) + ' bytes';

         if (Memo1.Lines.Strings[x].Contains('Database dialect') = True) then
            lblDialetoSQL.Caption := RemoveSpaces(Memo1.Lines.Strings[x]);
      end;

      vODS_temp := lbODS.Caption;
      vODS := RightStr(vODS_temp, Length(vODS_temp)-12);

       // Identify Firebird version based on ODS
      if vODS = '13.1' then lbFBv.Caption := 'Firebird 5.0'
         else if vODS = '13.0' then lbFBv.Caption := 'Firebird 4.0'
            else if vODS = '12.0' then lbFBv.Caption := 'Firebird 3.0'
               else if vODS = '11.2' then lbFBv.Caption := 'Firebird 2.5'
                  else if vODS = '11.1' then lbFBv.Caption := 'Firebird 2.1'
                     else if vODS = '11.0' then lbFBv.Caption := 'Firebird 2.0'
                        else if vODS = '10.1' then lbFBv.Caption := 'Firebird 1.5'
                           else if vODS = '10.0' then lbFBv.Caption := 'Firebird 1.0'
                              else lbFBv.Caption := 'Unknown Firebird version';

      FDConnection1.Connected := False;
      Break;
    except
      if i = High(port) then
      begin
        ShowMessage('Unable to connect to database');
        clean;
      end;
      continue;
    end;
    end;
  end
  else
  begin
    edtBD.Text := EmptyStr;
    OpenDialog1.FileName := EmptyStr;
  end;
end;

procedure TForm1.conectParams;
begin
   FDConnection1.Params.Clear;
   // DriverName
   FDConnection1.DriverName := 'FB';
   // DriverID
   FDConnection1.Params.Add('DriverID=FB');
   // Usuário
   FDConnection1.Params.Add('User_Name=SYSDBA');
   // PassWord
   FDConnection1.Params.Add('Password=masterkey');
   // Protocolo
   FDConnection1.Params.Add('Protocol=TCPIP');
   // Servidor
   FDConnection1.Params.Add('Server=127.0.0.1');
   // CharacterSet
   FDConnection1.Params.Add('CharacterSet=WIN1252');
   // Login Prompt
   FDConnection1.LoginPrompt := False;
   // SQL Dialect
   //FDConnection1.Params.Add('SQLDialect=3');
end;

procedure TForm1.clean;
begin
   edtBD.Text := EmptyStr;
   lblFBserver.Caption := EmptyStr;
   lbODS.Caption := EmptyStr;
   lbFBv.Caption := EmptyStr;
   lblPorta.Caption := EmptyStr;
   lblPS.Caption := EmptyStr;
   lblDialetoSQL.Caption := EmptyStr;
   lblFBPath.Caption := EmptyStr;
   Memo1.Clear;
end;

// If it is a long path (with space characters), wrap it in double quotes.
function TForm1.verifySpaces(path:string) : string;
begin
   if Pos(' ', path) > 0 then
   begin
      path := AnsiQuotedStr(path, Char(34));
      Result := path;
   end
   else
      Result := path;
end;

end.
