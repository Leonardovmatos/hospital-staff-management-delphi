unit uIEmpregadoRepository;

interface

uses
  FireDAC.Comp.Client,
  uEmpregado,
  uFiltroEmpregado;

type
  IEmpregadoRepository = interface
    ['{18B57C44-7219-4D83-9CF3-E4A682EA3E94}']

    procedure Listar(const AFiltro: TFiltroEmpregado;const AQuery: TFDQuery);
    function ObterPorId(const AId: Integer): TEmpregado;
    procedure Inserir(const AEmpregado: TEmpregado);
    procedure Atualizar(const AEmpregado: TEmpregado);
    procedure Excluir(const AId: Integer);
  end;

implementation

end.