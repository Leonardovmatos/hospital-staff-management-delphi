unit uDataModuleConnection;

interface

uses
  System.SysUtils, System.Classes, System.IniFiles, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PGDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.PG, Data.DB,
  FireDAC.Comp.Client;

type
  TdmConnection = class(TDataModule)
    FDConnection: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
  private
    function GetConfigFileName: string;
    procedure LoadConnectionParameters;
  public
    procedure Connect;
    procedure Disconnect;
  end;

var
  dmConnection: TdmConnection;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmConnection }

procedure TdmConnection.Connect;
begin
    if FDConnection.Connected then
      Exit;

    LoadConnectionParameters;
    FDConnection.Connected := True;
end;

procedure TdmConnection.Disconnect;
begin
    if FDConnection.Connected then
      FDConnection.Connected := False;
end;

function TdmConnection.GetConfigFileName: string;
begin
    Result := TPath.Combine(ExtractFilePath(ParamStr(0)),'config.ini');
end;

procedure TdmConnection.LoadConnectionParameters;
var
  LIniFile: TIniFile;
  LConfigFileName: string;
begin
    LConfigFileName := GetConfigFileName;


    if not FileExists(LConfigFileName) then
      raise Exception.Create('Arquivo de configuração não encontrado: ' +LConfigFileName);

    LIniFile := TIniFile.Create(LConfigFileName);
    try
      FDConnection.Close;
      FDConnection.Params.Clear;

      FDConnection.Params.Values['DriverID'] := 'PG';
      FDConnection.Params.Values['Server'] :=
        LIniFile.ReadString('DATABASE', 'Server', '127.0.0.1');


      FDConnection.Params.Values['Port'] :=
        LIniFile.ReadString('DATABASE', 'Port', '5432');


      FDConnection.Params.Values['Database'] :=
        LIniFile.ReadString('DATABASE', 'Database', '');


      FDConnection.Params.Values['User_Name'] :=
        LIniFile.ReadString('DATABASE', 'User_Name', '');


      FDConnection.Params.Values['Password'] :=
        LIniFile.ReadString('DATABASE', 'Password', '');


      FDConnection.Params.Values['CharacterSet'] :=
        LIniFile.ReadString('DATABASE', 'CharacterSet', 'UTF8');


      FDConnection.LoginPrompt := False;


      if FDConnection.Params.Values['Database'] = '' then
        raise Exception.Create(
          'O nome do banco de dados não foi informado no config.ini.'
        );
    finally
      LIniFile.Free;
    end;

end;

end.
