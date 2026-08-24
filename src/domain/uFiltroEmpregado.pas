unit uFiltroEmpregado;

interface

type
  TFiltroEmpregado = class
  private
    FNome: string;
    FDepartamentoId: Integer;
  public
    constructor Create;

    property Nome: string read FNome write FNome;
    property DepartamentoId: Integer read FDepartamentoId write FDepartamentoId;
  end;

implementation

constructor TFiltroEmpregado.Create;
begin
    inherited Create;

    FNome := '';
    FDepartamentoId := 0;
end;

end.
