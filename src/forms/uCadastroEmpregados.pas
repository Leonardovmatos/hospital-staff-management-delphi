unit uCadastroEmpregados;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.Buttons,
  Vcl.ExtCtrls,
  Vcl.DBCtrls,
  Vcl.ComCtrls,
  Data.DB,
  FireDAC.Comp.Client,
  uEmpregado,
  uEmpregadoService, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TfrmCadastroEmpregado = class(TForm)
    pnlTopo: TPanel;
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    lblNome: TLabel;
    edtNome: TEdit;
    lblCodigoFuncao: TLabel;
    edtCodigoFuncao: TEdit;
    lblNomeFuncao: TLabel;
    edtNomeFuncao: TEdit;
    lblDataAdmissao: TLabel;
    dtpDataAdmissao: TDateTimePicker;
    lblSalario: TLabel;
    edtSalario: TEdit;
    lblComissao: TLabel;
    edtComissao: TEdit;
    lblDepartamento: TLabel;
    cbbDepartamento: TDBLookupComboBox;
    dsDepartamentos: TDataSource;
    qryDepartamentos: TFDQuery;
    pnlRodape: TPanel;
    btnGravar: TBitBtn;
    btnCancelar: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FEmpregadoService: TEmpregadoService;
    FEmpregadoId: Integer;
    FModoEdicao: Boolean;

    procedure CarregarDepartamentos;
    procedure LimparCampos;
    procedure CarregarEmpregado;
    function MontarEmpregado: TEmpregado;
    procedure PreencherCampos(const AEmpregado: TEmpregado);
  public
    procedure AbrirParaInclusao;
    procedure AbrirParaEdicao(const AEmpregadoId: Integer);
  end;

implementation

uses
  uDataModuleConnection,
  uEmpregadoRepository;

{$R *.dfm}

procedure TfrmCadastroEmpregado.FormCreate(Sender: TObject);
begin
    FEmpregadoService := TEmpregadoService.Create(
                         TEmpregadoRepository.Create(dmConnection.FDConnection),
                         dmConnection.FDConnection);

    FEmpregadoId := 0;
    FModoEdicao := False;
end;

procedure TfrmCadastroEmpregado.FormDestroy(Sender: TObject);
begin
    FEmpregadoService.Free;
end;

procedure TfrmCadastroEmpregado.AbrirParaInclusao;
begin
    FEmpregadoId := 0;
    FModoEdicao := False;

    Caption := 'Novo Empregado';
end;

procedure TfrmCadastroEmpregado.AbrirParaEdicao(const AEmpregadoId: Integer);
begin
    FEmpregadoId := AEmpregadoId;
    FModoEdicao := True;

    Caption := 'Alterar Empregado';
end;

procedure TfrmCadastroEmpregado.FormShow(Sender: TObject);
begin
    CarregarDepartamentos;
    LimparCampos;

    if FModoEdicao then
      CarregarEmpregado;

    edtNome.SetFocus;
end;

procedure TfrmCadastroEmpregado.CarregarDepartamentos;
begin
    qryDepartamentos.Close;
    qryDepartamentos.SQL.Text :=
      '   SELECT id_departamento, nm_departamento '+
      '     FROM departamentos                    '+
      ' ORDER BY nm_departamento                  ';
    qryDepartamentos.Open;
end;

procedure TfrmCadastroEmpregado.LimparCampos;
begin
    edtCodigo.Clear;
    edtNome.Clear;
    edtCodigoFuncao.Clear;
    edtNomeFuncao.Clear;
    edtSalario.Text := '0';
    edtComissao.Text := '0';
    dtpDataAdmissao.Date := Date;
    cbbDepartamento.KeyValue := Null;
end;

procedure TfrmCadastroEmpregado.CarregarEmpregado;
var
  LEmpregado: TEmpregado;
begin
    LEmpregado := FEmpregadoService.ObterPorId(FEmpregadoId);
    try
      PreencherCampos(LEmpregado);
    finally
      LEmpregado.Free;
    end;
end;

procedure TfrmCadastroEmpregado.PreencherCampos(const AEmpregado: TEmpregado);
begin
    edtCodigo.Text := AEmpregado.Id.ToString;
    edtNome.Text := AEmpregado.Nome;
    edtCodigoFuncao.Text := AEmpregado.CodigoFuncao.ToString;
    edtNomeFuncao.Text := AEmpregado.NomeFuncao;
    dtpDataAdmissao.Date := AEmpregado.DataAdmissao;
    edtSalario.Text := CurrToStr(AEmpregado.Salario);
    edtComissao.Text := CurrToStr(AEmpregado.Comissao);
    cbbDepartamento.KeyValue := AEmpregado.Departamento.Id;
end;

function TfrmCadastroEmpregado.MontarEmpregado: TEmpregado;
begin
    Result := TEmpregado.Create;

    Result.Id := FEmpregadoId;
    Result.Nome := Trim(edtNome.Text);
    Result.CodigoFuncao := StrToIntDef(edtCodigoFuncao.Text, 0);
    Result.NomeFuncao := Trim(edtNomeFuncao.Text);
    Result.DataAdmissao := dtpDataAdmissao.Date;
    Result.Salario := StrToCurrDef(edtSalario.Text, 0);
    Result.Comissao := StrToCurrDef(edtComissao.Text, 0);

    if cbbDepartamento.KeyValue <> Null then
      Result.Departamento.Id := cbbDepartamento.KeyValue
    else
      Result.Departamento.Id := 0;
end;

procedure TfrmCadastroEmpregado.btnGravarClick(Sender: TObject);
var
  LEmpregado: TEmpregado;
begin
    LEmpregado := MontarEmpregado;
    try
      FEmpregadoService.Salvar(LEmpregado);

      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;

    LEmpregado.Free;
end;

procedure TfrmCadastroEmpregado.btnCancelarClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TfrmCadastroEmpregado.FormKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
begin
    case Key of
      VK_ESCAPE:
        ModalResult := mrCancel;

      VK_F10:
        btnGravarClick(Sender);
    end;
end;

end.
