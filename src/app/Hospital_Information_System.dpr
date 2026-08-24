program Hospital_Information_System;

uses
  Vcl.Forms,
  uPrincipal_HIS in '..\forms\uPrincipal_HIS.pas' {frmPrincipal},
  uDataModuleConnection in '..\infrastructure\uDataModuleConnection.pas' {dmConnection: TDataModule},
  uDepartamento in '..\domain\uDepartamento.pas',
  uEmpregado in '..\domain\uEmpregado.pas',
  uIDepartamentoRepository in '..\repositories\interfaces\uIDepartamentoRepository.pas',
  uDepartamentoRepository in '..\repositories\uDepartamentoRepository.pas',
  uDepartamentoService in '..\services\uDepartamentoService.pas',
  uConsultaDepartamentos in '..\forms\uConsultaDepartamentos.pas' {FrmConsultaDepartamentos},
  uCadastroDepartamentos in '..\forms\uCadastroDepartamentos.pas' {frmCadastroDepartamentos},
  uConsultaEmpregados in '..\forms\uConsultaEmpregados.pas' {frmConsultaEmpregados},
  uEmpregadoService in '..\services\uEmpregadoService.pas',
  uCadastroEmpregados in '..\forms\uCadastroEmpregados.pas' {FrmCadastroEmpregado},
  uFiltroEmpregado in '..\domain\uFiltroEmpregado.pas',
  uIEmpregadoRepository in '..\repositories\interfaces\uIEmpregadoRepository.pas',
  uEmpregadoRepository in '..\repositories\uEmpregadoRepository.pas',
  uRelatorioEmpregados in '..\reports\uRelatorioEmpregados.pas' {RelatorioEmpregados};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmConnection, dmConnection);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
