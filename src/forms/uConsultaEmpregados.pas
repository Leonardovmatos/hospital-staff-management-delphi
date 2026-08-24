unit uConsultaEmpregados;

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
  Vcl.DBCtrls,
  Data.DB,
  FireDAC.Comp.Client,
  uEmpregadoService,
  uFiltroEmpregado, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Mask;

type
  TfrmConsultaEmpregados = class(TForm)
    pnlTopo: TPanel;
    lblNome: TLabel;
    edtNome: TMaskEdit;
    lblDepartamento: TLabel;
    cbbDepartamento: TDBLookupComboBox;
    dsDepartamentosFiltro: TDataSource;
    qryDepartamentosFiltro: TFDQuery;
    btnPesquisar: TBitBtn;
    grdConsultaEmpregados: TDBGrid;
    dsConsultaEmpregados: TDataSource;
    qryConsultaEmpregados: TFDQuery;
    pnlRodape: TPanel;
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    btnSair: TBitBtn;
    lblTotalRegistros: TLabel;
    edtTotalRegistros: TEdit;
    btnRelatorio: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
    procedure edtNomeKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
    procedure grdConsultaEmpregadosDblClick(Sender: TObject);
    procedure qryConsultaEmpregadosAfterOpen(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnRelatorioClick(Sender: TObject);
  private
    FEmpregadoService: TEmpregadoService;

    procedure Pesquisar;
    procedure CarregarDepartamentosFiltro;
    procedure AtualizarTotalRegistros;
    function CriarFiltro: TFiltroEmpregado;
    function ExisteRegistroSelecionado: Boolean;
    function ObterEmpregadoSelecionadoId: Integer;
    procedure AbrirCadastroParaInclusao;
    procedure AbrirCadastroParaEdicao;
  end;

implementation

uses
  uDataModuleConnection,
  uEmpregadoRepository,
  uCadastroEmpregados,
  uRelatorioEmpregados;

{$R *.dfm}

procedure TfrmConsultaEmpregados.FormCreate(Sender: TObject);
begin
    FEmpregadoService := TEmpregadoService.Create(
                         TEmpregadoRepository.Create(dmConnection.FDConnection),
                         dmConnection.FDConnection);
end;

procedure TfrmConsultaEmpregados.FormDestroy(Sender: TObject);
begin
    FEmpregadoService.Free;
end;

procedure TfrmConsultaEmpregados.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    case Key of
        VK_RETURN          : Perform(WM_NEXTDLGCTL,0,0);
    end;
end;

procedure TfrmConsultaEmpregados.FormShow(Sender: TObject);
begin
    CarregarDepartamentosFiltro;
    Pesquisar;
    edtNome.SetFocus;
end;

procedure TfrmConsultaEmpregados.CarregarDepartamentosFiltro;
begin
    qryDepartamentosFiltro.Close;
    qryDepartamentosFiltro.SQL.Text :=
      '   SELECT id_departamento, nm_departamento '+
      '     FROM departamentos                    '+
      ' ORDER BY nm_departamento                  ';
    qryDepartamentosFiltro.Open;
end;

function TfrmConsultaEmpregados.CriarFiltro: TFiltroEmpregado;
begin
    Result := TFiltroEmpregado.Create;
    Result.Nome := Trim(edtNome.Text);

    if cbbDepartamento.KeyValue <> Null then
      Result.DepartamentoId := cbbDepartamento.KeyValue
    else
      Result.DepartamentoId := 0;
end;

procedure TfrmConsultaEmpregados.Pesquisar;
var
  Filtro: TFiltroEmpregado;
begin
    Filtro := CriarFiltro;
    try
      try
        FEmpregadoService.Listar(Filtro,qryConsultaEmpregados);

        AtualizarTotalRegistros;
      except
        on E: Exception do
          ShowMessage(E.Message);
      end;
    finally
      Filtro.Free;
    end;
end;

procedure TfrmConsultaEmpregados.qryConsultaEmpregadosAfterOpen(DataSet: TDataSet);
begin
    qryConsultaEmpregados
      .FieldByName('id_empregado')
      .DisplayLabel := 'Código';

    qryConsultaEmpregados
      .FieldByName('cod_departamento')
      .Visible := False;

    qryConsultaEmpregados
      .FieldByName('cod_emp_funcao')
      .Visible := False;

    qryConsultaEmpregados
      .FieldByName('nm_empregado')
      .DisplayLabel := 'Nome';

    qryConsultaEmpregados
      .FieldByName('nm_funcao')
      .DisplayLabel := 'Função';

    qryConsultaEmpregados
      .FieldByName('data_admissao')
      .DisplayLabel := 'Admissão';

    qryConsultaEmpregados
      .FieldByName('salario')
      .DisplayLabel := 'Salário';

    qryConsultaEmpregados
      .FieldByName('comissao')
      .DisplayLabel := 'Comissão';

    qryConsultaEmpregados
      .FieldByName('nm_departamento')
      .DisplayLabel := 'Departamento';

    qryConsultaEmpregados
      .FieldByName('local')
      .DisplayLabel := 'Local';

    (qryConsultaEmpregados
      .FieldByName('salario') as TNumericField)
      .DisplayFormat := '#,##0.00';

    (qryConsultaEmpregados
      .FieldByName('comissao') as TNumericField)
      .DisplayFormat := '#,##0.00';

    (qryConsultaEmpregados
      .FieldByName('data_admissao') as TDateTimeField)
      .DisplayFormat := 'dd/mm/yyyy';
end;

procedure TfrmConsultaEmpregados.AtualizarTotalRegistros;
begin
    edtTotalRegistros.Text := qryConsultaEmpregados.RecordCount.ToString;
end;

function TfrmConsultaEmpregados.ExisteRegistroSelecionado: Boolean;
begin
    Result := not qryConsultaEmpregados.IsEmpty;
end;

function TfrmConsultaEmpregados.ObterEmpregadoSelecionadoId: Integer;
begin
    if not ExisteRegistroSelecionado then
      raise Exception.Create('Selecione um empregado.');

    Result := qryConsultaEmpregados
      .FieldByName('id_empregado')
      .AsInteger;
end;

procedure TfrmConsultaEmpregados.btnPesquisarClick(Sender: TObject);
begin
    Pesquisar;
end;

procedure TfrmConsultaEmpregados.btnRelatorioClick(Sender: TObject);
var
  Formulario: TRelatorioEmpregados;
  Filtro: TFiltroEmpregado;
begin
    Filtro := CriarFiltro;
    Formulario := TRelatorioEmpregados.Create(Self);
    try
      Formulario.ExibirRelatorio(Filtro);
    finally
      Formulario.Free;
      Filtro.Free;
    end;
end;

procedure TfrmConsultaEmpregados.btnNovoClick(Sender: TObject);
begin
    AbrirCadastroParaInclusao;
end;

procedure TfrmConsultaEmpregados.AbrirCadastroParaInclusao;
var
  Formulario: TfrmCadastroEmpregado;
begin
    Formulario := TfrmCadastroEmpregado.Create(Self);
    try
      Formulario.AbrirParaInclusao;

      if Formulario.ShowModal = mrOk then
        Pesquisar;
    finally
      Formulario.Free;
    end;
end;

procedure TfrmConsultaEmpregados.btnAlterarClick(Sender: TObject);
begin
    if not ExisteRegistroSelecionado then
    begin
      ShowMessage('Selecione um empregado para alterar.');
      Exit;
    end;

    AbrirCadastroParaEdicao;
end;

procedure TfrmConsultaEmpregados.AbrirCadastroParaEdicao;
var
  Formulario: TfrmCadastroEmpregado;
begin
    Formulario := TfrmCadastroEmpregado.Create(Self);
    try
      Formulario.AbrirParaEdicao(ObterEmpregadoSelecionadoId);

      if Formulario.ShowModal = mrOk then
        Pesquisar;
    finally
      Formulario.Free;
    end;
end;

procedure TfrmConsultaEmpregados.btnExcluirClick(Sender: TObject);
var
  LEmpregadoId: Integer;
begin
    if not ExisteRegistroSelecionado then
    begin
      ShowMessage('Selecione um empregado para excluir.');
      Exit;
    end;

    if MessageDlg('Deseja realmente excluir o empregado selecionado?',
      mtConfirmation,[mbYes, mbNo],0) <> mrYes then
      Exit;

    LEmpregadoId := ObterEmpregadoSelecionadoId;

    try
      FEmpregadoService.Excluir(LEmpregadoId);

      ShowMessage('Empregado excluído com sucesso.');
      Pesquisar;
    except
      on E: Exception do
        ShowMessage(E.Message);
    end;
end;

procedure TfrmConsultaEmpregados.btnSairClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmConsultaEmpregados.edtNomeKeyDown(Sender: TObject;var Key: Word;Shift: TShiftState);
begin
    if Key = VK_RETURN then
    begin
      Pesquisar;
      Key := 0;
    end;
end;

procedure TfrmConsultaEmpregados.grdConsultaEmpregadosDblClick(Sender: TObject);
begin
    btnAlterarClick(Sender);
end;

end.
