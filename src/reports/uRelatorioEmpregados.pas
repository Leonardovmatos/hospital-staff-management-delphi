unit uRelatorioEmpregados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, ppPrnabl, ppClass, ppCtrls,
  ppBands, ppCache, ppDesignLayer, ppParameter, ppDB, ppDBPipe, ppComm,
  ppRelatv, ppProd, ppReport, uFiltroEmpregado;

type
  TRelatorioEmpregados = class(TForm)
    qryRelatorioEmpregados: TFDQuery;
    dsRelatorioEmpregados: TDataSource;
    pprEmpregados: TppReport;
    pplEmpregados: TppDBPipeline;
    ppParameterList1: TppParameterList;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppHeaderBand1: TppHeaderBand;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    plblTitulo: TppLabel;
    plblNome: TppLabel;
    plblFuncao: TppLabel;
    plblDepartamento: TppLabel;
    plblLocal: TppLabel;
    plblAdmissao: TppLabel;
    plblSalario: TppLabel;
    plblComissao: TppLabel;
    dlblNome: TppDBText;
    dlblFuncao: TppDBText;
    dlblDepartamento: TppDBText;
    dlblLocal: TppDBText;
    dlblAdmissao: TppDBText;
    dlblSalario: TppDBText;
    dlblComissao: TppDBText;
    plblTotal: TppLabel;
    ppDBCalc1: TppDBCalc;
    procedure FormCreate(Sender: TObject);
  private
    procedure MontarConsulta(const AFiltro: TFiltroEmpregado);
  public
    procedure ExibirRelatorio(const AFiltro: TFiltroEmpregado);
  public
    { Public declarations }
  end;

var
  RelatorioEmpregados: TRelatorioEmpregados;

implementation

{$R *.dfm}

uses
  uDataModuleConnection;

procedure TRelatorioEmpregados.ExibirRelatorio(const AFiltro: TFiltroEmpregado);
begin
   if not Assigned(AFiltro) then
      raise Exception.Create('Filtro de relatório não informado.');

    MontarConsulta(AFiltro);

    if qryRelatorioEmpregados.IsEmpty then
    begin
      ShowMessage('Não há empregados para exibir no relatório.');
      Exit;
    end;

    pprEmpregados.PrintReport;
end;

procedure TRelatorioEmpregados.FormCreate(Sender: TObject);
begin
    qryRelatorioEmpregados.Connection := dmConnection.FDConnection;
end;

procedure TRelatorioEmpregados.MontarConsulta(const AFiltro: TFiltroEmpregado);
begin
    qryRelatorioEmpregados.Close;
    qryRelatorioEmpregados.SQL.Text :=
      '     SELECT                                                                  '+
      '            e.nm_empregado,                                                  '+
      '            e.nm_funcao,                                                     '+
      '            e.data_admissao,                                                 '+
      '            e.salario,                                                       '+
      '            e.comissao,                                                      '+
      '            d.nm_departamento,                                               '+
      '            d.local                                                          '+
      '       FROM empregados e                                                     '+
      ' INNER JOIN departamentos d                                                  '+
      '         ON d.id_departamento = e.cod_departamento                           '+
      '      WHERE UPPER(e.nm_empregado) LIKE UPPER(:NOME)                          '+
      '        AND (:DEPARTAMENTO_ID = 0 OR e.cod_departamento = :DEPARTAMENTO_ID)  '+
      '   ORDER BY d.nm_departamento, e.nm_empregado                                ';

    qryRelatorioEmpregados.ParamByName('NOME').AsString             := '%' + Trim(AFiltro.Nome) + '%';
    qryRelatorioEmpregados.ParamByName('DEPARTAMENTO_ID').AsInteger := AFiltro.DepartamentoId;

    qryRelatorioEmpregados.Open;
end;

end.
