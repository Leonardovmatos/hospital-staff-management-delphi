unit uPrincipal_HIS;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Buttons;

type
  TfrmPrincipal = class(TForm)
    tvPrincipal: TTreeView;
    mnuPrincipal: TMainMenu;
    mniArquivo: TMenuItem;
    mniSair: TMenuItem;
    mniConsultas: TMenuItem;
    mniConsultaEmpregados: TMenuItem;
    mniConsultaDepartamentos: TMenuItem;
    procedure tvPrincipalDblClick(Sender: TObject);
    procedure mniConsultaEmpregadosClick(Sender: TObject);
    procedure mniConsultaDepartamentosClick(Sender: TObject);
    procedure mniSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
    uDataModuleConnection,
    uConsultaDepartamentos,
    uConsultaEmpregados;

{$R *.dfm}

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
    ExitProcess(0);
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
    try
      dmConnection.Connect;
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao conectar ao banco de dados.' + sLineBreak + E.Message);
        Close;
      end;
    end;
end;

procedure TfrmPrincipal.mniConsultaDepartamentosClick(Sender: TObject);
var
  Formulario: TfrmConsultaDepartamentos;
begin
    Formulario := TfrmConsultaDepartamentos.Create(Self);
    try
      Formulario.ShowModal;
    finally
      Formulario.Free;
    end;
end;

procedure TfrmPrincipal.mniConsultaEmpregadosClick(Sender: TObject);
var
  Formulario: TfrmConsultaEmpregados;
begin
    Formulario := TfrmConsultaEmpregados.Create(Self);
    try
      Formulario.ShowModal;
    finally
      Formulario.Free;
    end;
end;

procedure TfrmPrincipal.mniSairClick(Sender: TObject);
begin
    Self.Close;
end;

procedure TfrmPrincipal.tvPrincipalDblClick(Sender: TObject);
begin
    case tvPrincipal.Selected.SelectedIndex of
      21 : mniConsultaEmpregadosClick(Sender);
      22 : mniConsultaDepartamentosClick(Sender);
    end;
end;

end.
