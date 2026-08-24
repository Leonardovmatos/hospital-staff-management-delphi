unit uDepartamento;

interface

type
  TDepartamento = class
  private
    FId: Integer;
    FNome: string;
    FLocal: string;
  public
    property Id: Integer read FId write FId;
    property Nome: string read FNome write FNome;
    property Local: string read FLocal write FLocal;
  end;

implementation

end.
