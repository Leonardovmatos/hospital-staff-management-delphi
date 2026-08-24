unit uDepartamentoService;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uDepartamento,
  uIDepartamentoRepository;

type
  TDepartamentoService = class
  private
    FRepository: IDepartamentoRepository;
    FConnection: TFDConnection;

    procedure Validar(const ADepartamento: TDepartamento);
    procedure IniciarTransacao;
    procedure ConfirmarTransacao;
    procedure DesfazerTransacao;
  public
    constructor Create(const ARepository: IDepartamentoRepository;const AConnection: TFDConnection);
    procedure Listar(const AFiltroNome: string;const AQuery: TFDQuery);
    function ObterPorId(const AId: Integer): TDepartamento;
    procedure Salvar(const ADepartamento: TDepartamento);
    procedure Excluir(const AId: Integer);
  end;

implementation

constructor TDepartamentoService.Create(const ARepository: IDepartamentoRepository;const AConnection: TFDConnection);
begin
    inherited Create;
    FRepository := ARepository;
    FConnection := AConnection;
end;

procedure TDepartamentoService.Validar(const ADepartamento: TDepartamento);
begin
    if not Assigned(ADepartamento) then
      raise Exception.Create('Departamento não informado.');

    if Trim(ADepartamento.Nome) = '' then
      raise Exception.Create('Informe o nome do departamento.');

    if Trim(ADepartamento.Local) = '' then
      raise Exception.Create('Informe o local do departamento.');
end;

procedure TDepartamentoService.IniciarTransacao;
begin
    if not FConnection.InTransaction then
      FConnection.StartTransaction;
end;

procedure TDepartamentoService.ConfirmarTransacao;
begin
    if FConnection.InTransaction then
      FConnection.Commit;
end;

procedure TDepartamentoService.DesfazerTransacao;
begin
    if FConnection.InTransaction then
      FConnection.Rollback;
end;

procedure TDepartamentoService.Listar(const AFiltroNome: string;const AQuery: TFDQuery);
begin
    FRepository.Listar(AFiltroNome, AQuery);
end;

function TDepartamentoService.ObterPorId(const AId: Integer): TDepartamento;
begin
    if AId <= 0 then
      raise Exception.Create('Código de departamento inválido.');

    Result := FRepository.ObterPorId(AId);

    if not Assigned(Result) then
      raise Exception.Create('Departamento não encontrado.');
end;

procedure TDepartamentoService.Salvar(const ADepartamento: TDepartamento);
begin
    Validar(ADepartamento);

    IniciarTransacao;
    try
      if ADepartamento.Id = 0 then
        FRepository.Inserir(ADepartamento)
      else
        FRepository.Atualizar(ADepartamento);

      ConfirmarTransacao;
    except
      DesfazerTransacao;
      raise;
    end;
end;

procedure TDepartamentoService.Excluir(const AId: Integer);
begin
    if AId <= 0 then
      raise Exception.Create('Código de departamento inválido.');

    if FRepository.ExisteEmpregadoVinculado(AId) then
      raise Exception.Create('Não é possível excluir o departamento porque existem empregados vinculados a ele.');

    IniciarTransacao;
    try
      FRepository.Excluir(AId);
      ConfirmarTransacao;
    except
      DesfazerTransacao;
      raise;
    end;
end;

end.