unit uEmpregadoRepository;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uEmpregado,
  uFiltroEmpregado,
  uIEmpregadoRepository;

type
  TEmpregadoRepository = class(
    TInterfacedObject,
    IEmpregadoRepository
  )
  private
    FConnection: TFDConnection;

    function CriarQuery: TFDQuery;
  public
    constructor Create(const AConnection: TFDConnection);
    procedure Listar(const AFiltro: TFiltroEmpregado;const AQuery: TFDQuery);
    function ObterPorId(const AId: Integer): TEmpregado;
    procedure Inserir(const AEmpregado: TEmpregado);
    procedure Atualizar(const AEmpregado: TEmpregado);
    procedure Excluir(const AId: Integer);
  end;

implementation

constructor TEmpregadoRepository.Create(const AConnection: TFDConnection);
begin
    inherited Create;

    if not Assigned(AConnection) then
      raise Exception.Create('Conexão com o banco de dados não informada.');

    FConnection := AConnection;
end;

function TEmpregadoRepository.CriarQuery: TFDQuery;
begin
    Result := TFDQuery.Create(nil);
    Result.Connection := FConnection;
end;

procedure TEmpregadoRepository.Listar(const AFiltro: TFiltroEmpregado;const AQuery: TFDQuery);
begin
    AQuery.Close;
    AQuery.SQL.Text :=
      '     SELECT                                                                  '+
      '  e.id_empregado,                                                            '+
      '  e.cod_departamento,                                                        '+
      '  e.cod_emp_funcao,                                                          '+
      '  e.nm_empregado,                                                            '+
      '  e.nm_funcao,                                                               '+
      '  e.data_admissao,                                                           '+
      '  e.salario,                                                                 '+
      '  e.comissao,                                                                '+
      '  d.nm_departamento,                                                         '+
      '  d.local                                                                    '+
      '       FROM empregados e                                                     '+
      ' INNER JOIN departamentos d                                                  '+
      '         ON d.id_departamento = e.cod_departamento                           '+
      'WHERE UPPER(e.nm_empregado) LIKE UPPER(:NOME)                                '+
      '        AND (:DEPARTAMENTO_ID = 0 OR e.cod_departamento = :DEPARTAMENTO_ID)  '+
      '   ORDER BY e.nm_empregado                                                   ';

    AQuery.ParamByName('NOME').AsString := '%' + Trim(AFiltro.Nome) + '%';
    AQuery.ParamByName('DEPARTAMENTO_ID').AsInteger := AFiltro.DepartamentoId;
    AQuery.Open;
end;

function TEmpregadoRepository.ObterPorId(const AId: Integer): TEmpregado;
var
  LQuery: TFDQuery;
begin
    Result := nil;
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
        '       SELECT                                        '+
        '              e.id_empregado,                        '+
        '              e.cod_departamento,                    '+
        '              e.cod_emp_funcao,                      '+
        '              e.nm_empregado,                        '+
        '              e.nm_funcao,                           '+
        '              e.data_admissao,                       '+
        '              e.salario,                             '+
        '              e.comissao,                            '+
        '              d.nm_departamento,                     '+
        '              d.local                                '+
        '         FROM empregados e                           '+
        '   INNER JOIN departamentos d                        '+
        '           ON d.id_departamento = e.cod_departamento '+
        '        WHERE e.id_empregado = :ID                   ';

      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.Open;

      if not LQuery.IsEmpty then
      begin
        Result := TEmpregado.Create;

        Result.Id :=
          LQuery.FieldByName('id_empregado').AsInteger;

        Result.Departamento.Id :=
          LQuery.FieldByName('cod_departamento').AsInteger;

        Result.Departamento.Nome :=
          LQuery.FieldByName('nm_departamento').AsString;

        Result.Departamento.Local :=
          LQuery.FieldByName('local').AsString;

        Result.CodigoFuncao :=
          LQuery.FieldByName('cod_emp_funcao').AsInteger;

        Result.Nome :=
          LQuery.FieldByName('nm_empregado').AsString;

        Result.NomeFuncao :=
          LQuery.FieldByName('nm_funcao').AsString;

        if not LQuery.FieldByName('data_admissao').IsNull then
          Result.DataAdmissao :=
            LQuery.FieldByName('data_admissao').AsDateTime;

        if not LQuery.FieldByName('salario').IsNull then
          Result.Salario :=
            LQuery.FieldByName('salario').AsCurrency;

        if not LQuery.FieldByName('comissao').IsNull then
          Result.Comissao :=
            LQuery.FieldByName('comissao').AsCurrency;
      end;
    finally
      LQuery.Free;
    end;
end;

procedure TEmpregadoRepository.Inserir(const AEmpregado: TEmpregado);
var
  LQuery: TFDQuery;
begin
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
        '   INSERT INTO empregados (      '+
        '               cod_departamento, '+
        '               cod_emp_funcao,   '+
        '               nm_empregado,     '+
        '               nm_funcao,        '+
        '               data_admissao,    '+
        '               salario,          '+
        '               comissao          '+
        ')      VALUES (                  '+
        '               :DEPARTAMENTO_ID, '+
        '               :CODIGO_FUNCAO,   '+
        '               :NOME,            '+
        '               :NOME_FUNCAO,     '+
        '               :DATA_ADMISSAO,   '+
        '               :SALARIO,         '+
        '               :COMISSAO         '+
        ')                                ';

      LQuery.ParamByName('DEPARTAMENTO_ID').AsInteger :=
        AEmpregado.Departamento.Id;

      LQuery.ParamByName('CODIGO_FUNCAO').AsInteger :=
        AEmpregado.CodigoFuncao;

      LQuery.ParamByName('NOME').AsString :=
        AEmpregado.Nome;

      LQuery.ParamByName('NOME_FUNCAO').AsString :=
        AEmpregado.NomeFuncao;

      LQuery.ParamByName('DATA_ADMISSAO').AsDateTime :=
        AEmpregado.DataAdmissao;

      LQuery.ParamByName('SALARIO').AsCurrency :=
        AEmpregado.Salario;

      LQuery.ParamByName('COMISSAO').AsCurrency :=
        AEmpregado.Comissao;

      LQuery.ExecSQL;
    finally
      LQuery.Free;
    end;
end;

procedure TEmpregadoRepository.Atualizar(const AEmpregado: TEmpregado);
var
  LQuery: TFDQuery;
begin
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
            'UPDATE empregados                            '+
        '       SET                                       '+
        '           cod_departamento = :DEPARTAMENTO_ID,  '+
        '           cod_emp_funcao = :CODIGO_FUNCAO,      '+
        '           nm_empregado = :NOME,                 '+
        '           nm_funcao = :NOME_FUNCAO,             '+
        '           data_admissao = :DATA_ADMISSAO,       '+
        '           salario = :SALARIO,                   '+
        '           comissao = :COMISSAO                  '+
        '     WHERE id_empregado = :ID                    ';

      LQuery.ParamByName('ID').AsInteger :=
        AEmpregado.Id;

      LQuery.ParamByName('DEPARTAMENTO_ID').AsInteger :=
        AEmpregado.Departamento.Id;

      LQuery.ParamByName('CODIGO_FUNCAO').AsInteger :=
        AEmpregado.CodigoFuncao;

      LQuery.ParamByName('NOME').AsString :=
        AEmpregado.Nome;

      LQuery.ParamByName('NOME_FUNCAO').AsString :=
        AEmpregado.NomeFuncao;

      LQuery.ParamByName('DATA_ADMISSAO').AsDateTime :=
        AEmpregado.DataAdmissao;

      LQuery.ParamByName('SALARIO').AsCurrency :=
        AEmpregado.Salario;

      LQuery.ParamByName('COMISSAO').AsCurrency :=
        AEmpregado.Comissao;

      LQuery.ExecSQL;
    finally
      LQuery.Free;
    end;
end;

procedure TEmpregadoRepository.Excluir(const AId: Integer);
var
  LQuery: TFDQuery;
begin
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
        ' DELETE FROM empregados          '+
        '       WHERE id_empregado = :ID  ';

      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;
    finally
      LQuery.Free;
    end;
end;

end.