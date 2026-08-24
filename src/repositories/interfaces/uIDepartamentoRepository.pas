unit uIDepartamentoRepository;

interface

uses
  FireDAC.Comp.Client,
  uDepartamento;

type
  IDepartamentoRepository = interface
    ['{58A8EC5D-D0FE-420B-BCF8-1E326A4AE59D}']

    procedure Listar(const AFiltroNome: string;const AQuery: TFDQuery);
    function ObterPorId(const AId: Integer): TDepartamento;
    procedure Inserir(const ADepartamento: TDepartamento);
    procedure Atualizar(const ADepartamento: TDepartamento);
    procedure Excluir(const AId: Integer);
    function ExisteEmpregadoVinculado(const AId: Integer): Boolean;
  end;

implementation

end.