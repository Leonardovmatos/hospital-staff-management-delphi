unit uCadastroDepartamentos;

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
  uDepartamento,
  uDepartamentoService;

type
  TfrmCadastroDepartamentos = class(TForm)
    lblCodigo: TLabel;
    edtCodigo: TEdit;
    lblNome: TLabel;
    edtNome: TEdit;
    lblLocal: TLabel;
    edtLocal: TEdit;
    pnlRodape: TPanel;
    lblTitulo: TLabel;
    btnGravar: TBitBtn;
    btnCancelar: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FDepartamentoService: TDepartamentoService;
    FDepartamentoId: Integer;
    FModoEdicao: Boolean;

    procedure LimparCampos;
    procedure CarregarDepartamento;
    function MontarDepartamento: TDepartamento;
    procedure PreencherCampos(const ADepartamento: TDepartamento);
  public
    procedure AbrirParaInclusao;
    procedure AbrirParaEdicao(const ADepartamentoId: Integer);
  end;

implementation

uses
  uDataModuleConnection,
  uDepartamentoRepository;

{$R *.dfm}

procedure TfrmCadastroDepartamentos.FormCreate(Sender: TObject);
begin
    FDepartamentoService := TDepartamentoService.Create(
                            TDepartamentoRepository.Create(dmConnection.FDConnection),
                            dmConnection.FDConnection);

    FDepartamentoId := 0;
    FModoEdicao := False;
end;

procedure TfrmCadastroDepartamentos.FormDestroy(Sender: TObject);
begin
    FDepartamentoService.Free;
end;

procedure TfrmCadastroDepartamentos.AbrirParaInclusao;
begin
    FDepartamentoId := 0;
    FModoEdicao := False;

    Caption := 'Novo Departamento';
    lblTitulo.Caption := 'Cadastro de Departamento';
end;

procedure TfrmCadastroDepartamentos.AbrirParaEdicao(const ADepartamentoId: Integer);
begin
    FDepartamentoId := ADepartamentoId;
    FModoEdicao := True;

    Caption := 'Alterar Departamento';
    lblTitulo.Caption := 'Alteração de Departamento';
end;

procedure TfrmCadastroDepartamentos.FormShow(Sender: TObject);
begin
    LimparCampos;

    if FModoEdicao then
      CarregarDepartamento;

    edtNome.SetFocus;
end;

procedure TfrmCadastroDepartamentos.LimparCampos;
begin
    edtCodigo.Clear;
    edtNome.Clear;
    edtLocal.Clear;
end;

procedure TfrmCadastroDepartamentos.CarregarDepartamento;
var
  LDepartamento: TDepartamento;
begin
    LDepartamento := FDepartamentoService.ObterPorId(FDepartamentoId);
    try
      PreencherCampos(LDepartamento);
    finally
      LDepartamento.Free;
    end;
end;

procedure TfrmCadastroDepartamentos.PreencherCampos(const ADepartamento: TDepartamento);
begin
    edtCodigo.Text  := ADepartamento.Id.ToString;
    edtNome.Text    := ADepartamento.Nome;
    edtLocal.Text   := ADepartamento.Local;
end;

function TfrmCadastroDepartamentos.MontarDepartamento: TDepartamento;
begin
    Result := TDepartamento.Create;

    Result.Id     := FDepartamentoId;
    Result.Nome   := Trim(edtNome.Text);
    Result.Local  := Trim(edtLocal.Text);
end;

procedure TfrmCadastroDepartamentos.btnGravarClick(Sender: TObject);
var
  LDepartamento: TDepartamento;
begin
    LDepartamento := MontarDepartamento;
    try
      FDepartamentoService.Salvar(LDepartamento);

      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;

    LDepartamento.Free;
end;

procedure TfrmCadastroDepartamentos.btnCancelarClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TfrmCadastroDepartamentos.FormKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
begin
    case Key of
      VK_ESCAPE:
        ModalResult := mrCancel;

      VK_F10:
        btnGravarClick(Sender);
    end;
end;

end.
