unit uEmpregadoService;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uEmpregado,
  uFiltroEmpregado,
  uIEmpregadoRepository;

type
  TEmpregadoService = class
  private
    FRepository: IEmpregadoRepository;
    FConnection: TFDConnection;

    procedure Validar(const AEmpregado: TEmpregado);

    procedure IniciarTransacao;
    procedure ConfirmarTransacao;
    procedure DesfazerTransacao;
  public
    constructor Create(const ARepository: IEmpregadoRepository;const AConnection: TFDConnection);
    procedure Listar(const AFiltro: TFiltroEmpregado;const AQuery: TFDQuery);
    function ObterPorId(const AId: Integer): TEmpregado;
    procedure Salvar(const AEmpregado: TEmpregado);
    procedure Excluir(const AId: Integer);
  end;

implementation

constructor TEmpregadoService.Create(const ARepository: IEmpregadoRepository;const AConnection: TFDConnection);
begin
    inherited Create;

    if not Assigned(ARepository) then
      raise Exception.Create('Repositório de empregado não informado.');

    if not Assigned(AConnection) then
      raise Exception.Create('Conexão com o banco de dados não informada.');

    FRepository := ARepository;
    FConnection := AConnection;
end;

procedure TEmpregadoService.Validar(const AEmpregado: TEmpregado);
begin
    if not Assigned(AEmpregado) then
      raise Exception.Create('Empregado não informado.');

    if Trim(AEmpregado.Nome) = '' then
      raise Exception.Create('Informe o nome do empregado.');

    if not Assigned(AEmpregado.Departamento) or
       (AEmpregado.Departamento.Id <= 0) then
      raise Exception.Create('Selecione um departamento.');

    if AEmpregado.CodigoFuncao <= 0 then
      raise Exception.Create('Informe um código de função válido.');

    if Trim(AEmpregado.NomeFuncao) = '' then
      raise Exception.Create('Informe o nome da função.');

    if AEmpregado.DataAdmissao = 0 then
      raise Exception.Create('Informe a data de admissão.');

    if AEmpregado.DataAdmissao > Now then
      raise Exception.Create('A data de admissão não pode ser futura.');

    if AEmpregado.Salario < 0 then
      raise Exception.Create('O salário não pode ser negativo.');

    if AEmpregado.Comissao < 0 then
      raise Exception.Create('A comissão não pode ser negativa.');
end;

procedure TEmpregadoService.IniciarTransacao;
begin
    if not Assigned(FConnection) then
      raise Exception.Create('Conexão indisponível para iniciar transação.');

    if not FConnection.InTransaction then
      FConnection.StartTransaction;
end;

procedure TEmpregadoService.ConfirmarTransacao;
begin
    if Assigned(FConnection) and FConnection.InTransaction then
      FConnection.Commit;
end;

procedure TEmpregadoService.DesfazerTransacao;
begin
    if Assigned(FConnection) and FConnection.InTransaction then
      FConnection.Rollback;
end;

procedure TEmpregadoService.Listar(const AFiltro: TFiltroEmpregado;const AQuery: TFDQuery);
begin
    if not Assigned(AFiltro) then
      raise Exception.Create('Filtro de empregados não informado.');

    if not Assigned(AQuery) then
      raise Exception.Create('Query de destino não informada.');

    FRepository.Listar(AFiltro, AQuery);
end;

function TEmpregadoService.ObterPorId(const AId: Integer): TEmpregado;
begin
    if AId <= 0 then
      raise Exception.Create('Código de empregado inválido.');

    Result := FRepository.ObterPorId(AId);

    if not Assigned(Result) then
      raise Exception.Create('Empregado não encontrado.');
end;

procedure TEmpregadoService.Salvar(const AEmpregado: TEmpregado);
begin
    Validar(AEmpregado);

    IniciarTransacao;
    try
      if AEmpregado.Id = 0 then
        FRepository.Inserir(AEmpregado)
      else
        FRepository.Atualizar(AEmpregado);

      ConfirmarTransacao;
    except
      DesfazerTransacao;
      raise;
    end;
end;

procedure TEmpregadoService.Excluir(const AId: Integer);
begin
    if AId <= 0 then
      raise Exception.Create('Código de empregado inválido.');

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
