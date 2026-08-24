unit uDepartamentoRepository;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uDepartamento,
  uIDepartamentoRepository;

type
  TDepartamentoRepository = class(
    TInterfacedObject,
    IDepartamentoRepository
  )
  private
    FConnection: TFDConnection;

    function CriarQuery: TFDQuery;
  public
    constructor Create(const AConnection: TFDConnection);
    procedure Listar(const AFiltroNome: string;const AQuery: TFDQuery);
    function ObterPorId(const AId: Integer): TDepartamento;
    procedure Inserir(const ADepartamento: TDepartamento);
    procedure Atualizar(const ADepartamento: TDepartamento);
    procedure Excluir(const AId: Integer);
    function ExisteEmpregadoVinculado(const AId: Integer): Boolean;
  end;

implementation

constructor TDepartamentoRepository.Create(const AConnection: TFDConnection);
begin
    inherited Create;
    FConnection := AConnection;
end;

function TDepartamentoRepository.CriarQuery: TFDQuery;
begin
    Result := TFDQuery.Create(nil);
    Result.Connection := FConnection;
end;

procedure TDepartamentoRepository.Listar(const AFiltroNome: string;const AQuery: TFDQuery);
begin
    AQuery.Close;
    AQuery.SQL.Text :=
      '   SELECT                                          '+
      '          id_departamento,                         '+
      '          nm_departamento,                         '+
      '          local                                    '+
      '     FROM departamentos                            '+
      '    WHERE UPPER(nm_departamento) LIKE UPPER(:NOME) '+
      ' ORDER BY nm_departamento                          ';

    AQuery.ParamByName('NOME').AsString := '%' + Trim(AFiltroNome) + '%';
    AQuery.Open;
end;

function TDepartamentoRepository.ObterPorId(const AId: Integer): TDepartamento;
var
  LQuery: TFDQuery;
begin
    Result := nil;
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
        ' SELECT                        '+
        '        id_departamento,       '+
        '        nm_departamento,       '+
        '        local                  '+
        '   FROM departamentos          '+
        '  WHERE id_departamento = :ID  ';
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.Open;

      if not LQuery.IsEmpty then
      begin
        Result := TDepartamento.Create;
        Result.Id := LQuery.FieldByName('id_departamento').AsInteger;
        Result.Nome := LQuery.FieldByName('nm_departamento').AsString;
        Result.Local := LQuery.FieldByName('local').AsString;
      end;
    finally
      LQuery.Free;
    end;
end;

procedure TDepartamentoRepository.Inserir(const ADepartamento: TDepartamento);
var
  LQuery: TFDQuery;
begin
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
        ' INSERT INTO departamentos (   '+
        '             nm_departamento,  '+
        '             local             '+
        ')    VALUES (                  '+
        '             :NOME,            '+
        '             :LOCAL            '+
        ')                              ';
      LQuery.ParamByName('NOME').AsString := ADepartamento.Nome;
      LQuery.ParamByName('LOCAL').AsString := ADepartamento.Local;

      LQuery.ExecSQL;
    finally
      LQuery.Free;
    end;
end;

procedure TDepartamentoRepository.Atualizar(const ADepartamento: TDepartamento);
var
  LQuery: TFDQuery;
begin
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
        '   UPDATE departamentos            '+
        '      SET                          '+
        '          nm_departamento = :NOME, '+
        '          local = :LOCAL           '+
        '    WHERE id_departamento = :ID    ';
      LQuery.ParamByName('ID').AsInteger := ADepartamento.Id;
      LQuery.ParamByName('NOME').AsString := ADepartamento.Nome;
      LQuery.ParamByName('LOCAL').AsString := ADepartamento.Local;

      LQuery.ExecSQL;
    finally
      LQuery.Free;
    end;
end;

procedure TDepartamentoRepository.Excluir(const AId: Integer);
var
  LQuery: TFDQuery;
begin
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
        ' DELETE FROM departamentos         '+
        '       WHERE id_departamento = :ID ';
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.ExecSQL;
    finally
      LQuery.Free;
    end;
end;

function TDepartamentoRepository.ExisteEmpregadoVinculado(const AId: Integer): Boolean;
var
  LQuery: TFDQuery;
begin
    LQuery := CriarQuery;
    try
      LQuery.SQL.Text :=
        '   SELECT 1                      '+
        '     FROM empregados             '+
        '    WHERE cod_departamento = :ID '+
        '    LIMIT 1                      ';
      LQuery.ParamByName('ID').AsInteger := AId;
      LQuery.Open;

      Result := not LQuery.IsEmpty;
    finally
      LQuery.Free;
    end;
end;

end.