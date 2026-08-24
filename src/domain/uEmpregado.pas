unit uEmpregado;

interface

uses
  System.SysUtils,
  uDepartamento;

type
  TEmpregado = class
  private
    FId: Integer;
    FDepartamento: TDepartamento;
    FCodigoFuncao: Integer;
    FNome: string;
    FNomeFuncao: string;
    FDataAdmissao: TDateTime;
    FSalario: Currency;
    FComissao: Currency;
  public
    constructor Create;
    destructor Destroy; override;

    property Id: Integer read FId write FId;
    property Departamento: TDepartamento read FDepartamento write FDepartamento;
    property CodigoFuncao: Integer read FCodigoFuncao write FCodigoFuncao;
    property Nome: string read FNome write FNome;
    property NomeFuncao: string read FNomeFuncao write FNomeFuncao;
    property DataAdmissao: TDateTime read FDataAdmissao write FDataAdmissao;
    property Salario: Currency read FSalario write FSalario;
    property Comissao: Currency read FComissao write FComissao;
  end;

implementation

constructor TEmpregado.Create;
begin
    inherited Create;
    FDepartamento := TDepartamento.Create;
end;

destructor TEmpregado.Destroy;
begin
    FDepartamento.Free;
    inherited Destroy;
end;

end.
