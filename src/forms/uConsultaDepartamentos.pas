unit uConsultaDepartamentos;

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
  Vcl.Grids,
  Vcl.DBGrids,
  Data.DB,
  FireDAC.Comp.Client,
  uDepartamentoService, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, ppDB, ppDBPipe,
  ppParameter, ppDesignLayer, ppBands, ppCtrls, ppVar, ppPrnabl, ppClass,
  ppCache, ppComm, ppRelatv, ppProd, ppReport, FireDAC.Comp.DataSet, Vcl.Mask;

type
  TFrmConsultaDepartamentos = class(TForm)
    pnlTopo: TPanel;
    lblPesquisa: TLabel;
    btnPesquisar: TBitBtn;
    dsConsultaDepartamentos: TDataSource;
    qryConsultaDepartamentos: TFDQuery;
    pnlRodape: TPanel;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnSair: TBitBtn;
    edtTotalRegistros: TEdit;
    edtPesquisar: TMaskEdit;
    grdConsultaDepartamentos: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtPesquisaKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
    procedure grdConsultaDepartamentosDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure qryConsultaDepartamentosAfterOpen(DataSet: TDataSet);
  private
    FDepartamentoService: TDepartamentoService;

    procedure Pesquisar;
    procedure AtualizarTotalRegistros;
    function ExisteRegistroSelecionado: Boolean;
    function ObterDepartamentoSelecionadoId: Integer;
    procedure AbrirCadastroParaInclusao;
    procedure AbrirCadastroParaEdicao;
  end;

implementation

uses
  uDataModuleConnection,
  uDepartamentoRepository,
  uCadastroDepartamentos;

{$R *.dfm}

procedure TFrmConsultaDepartamentos.FormCreate(Sender: TObject);
begin
  FDepartamentoService := TDepartamentoService.Create(
                          TDepartamentoRepository.Create(dmConnection.FDConnection),
                          dmConnection.FDConnection);
end;

procedure TFrmConsultaDepartamentos.FormDestroy(Sender: TObject);
begin
    FDepartamentoService.Free;
end;

procedure TFrmConsultaDepartamentos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    case Key of
        VK_RETURN          : Perform(WM_NEXTDLGCTL,0,0);
    end;
end;

procedure TFrmConsultaDepartamentos.FormShow(Sender: TObject);
begin
    Pesquisar;
end;

procedure TFrmConsultaDepartamentos.btnPesquisarClick(Sender: TObject);
begin
    Pesquisar;
end;

procedure TFrmConsultaDepartamentos.Pesquisar;
begin
    try
      FDepartamentoService.Listar(Trim(edtPesquisar.Text),qryConsultaDepartamentos);

      AtualizarTotalRegistros;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
end;

procedure TFrmConsultaDepartamentos.qryConsultaDepartamentosAfterOpen(DataSet: TDataSet);
begin
    qryConsultaDepartamentos
      .FieldByName('id_departamento')
      .DisplayLabel := 'Código';

    qryConsultaDepartamentos
      .FieldByName('nm_departamento')
      .DisplayLabel := 'Departamento';

    qryConsultaDepartamentos
      .FieldByName('local')
      .DisplayLabel := 'Local';
end;

procedure TFrmConsultaDepartamentos.AtualizarTotalRegistros;
begin
    edtTotalRegistros.Text := qryConsultaDepartamentos.RecordCount.ToString;
end;

function TFrmConsultaDepartamentos.ExisteRegistroSelecionado: Boolean;
begin
    Result := not qryConsultaDepartamentos.IsEmpty;
end;

function TFrmConsultaDepartamentos.ObterDepartamentoSelecionadoId: Integer;
begin
    if not ExisteRegistroSelecionado then
      raise Exception.Create('Selecione um departamento.');

    Result := qryConsultaDepartamentos.FieldByName('id_departamento').AsInteger;
end;

procedure TFrmConsultaDepartamentos.btnNovoClick(Sender: TObject);
begin
    AbrirCadastroParaInclusao;
end;

procedure TFrmConsultaDepartamentos.AbrirCadastroParaInclusao;
var
  Formulario: TfrmCadastroDepartamentos;
begin
    Formulario := TfrmCadastroDepartamentos.Create(Self);
    try
      Formulario.AbrirParaInclusao;

      if Formulario.ShowModal = mrOk then
        Pesquisar;
    finally
      Formulario.Free;
    end;
end;

procedure TFrmConsultaDepartamentos.btnAlterarClick(Sender: TObject);
begin
    if not ExisteRegistroSelecionado then
    begin
      ShowMessage('Selecione um departamento para alterar.');
      Exit;
    end;

    AbrirCadastroParaEdicao;
end;

procedure TFrmConsultaDepartamentos.AbrirCadastroParaEdicao;
var
  Formulario: TfrmCadastroDepartamentos;
begin
    Formulario := TfrmCadastroDepartamentos.Create(Self);
    try
      Formulario.AbrirParaEdicao(ObterDepartamentoSelecionadoId);

      if Formulario.ShowModal = mrOk then
        Pesquisar;
    finally
      Formulario.Free;
    end;
end;

procedure TFrmConsultaDepartamentos.btnExcluirClick(Sender: TObject);
var
  LDepartamentoId: Integer;
begin
    if not ExisteRegistroSelecionado then
    begin
      ShowMessage('Selecione um departamento para excluir.');
      Exit;
    end;

    if MessageDlg('Deseja realmente excluir o departamento selecionado?',
      mtConfirmation,[mbYes, mbNo],0) <> mrYes then
      Exit;

    LDepartamentoId := ObterDepartamentoSelecionadoId;

    try
      FDepartamentoService.Excluir(LDepartamentoId);

      ShowMessage('Departamento excluído com sucesso.');
      Pesquisar;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
end;

procedure TFrmConsultaDepartamentos.btnSairClick(Sender: TObject);
begin
    Close;
end;

procedure TFrmConsultaDepartamentos.edtPesquisaKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
begin
    if Key = VK_RETURN then
    begin
      Pesquisar;
      Key := 0;
    end;
end;

procedure TFrmConsultaDepartamentos.grdConsultaDepartamentosDblClick(Sender: TObject);
begin
    btnAlterarClick(Sender);
end;

end.
