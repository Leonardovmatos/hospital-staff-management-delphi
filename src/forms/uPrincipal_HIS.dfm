object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Align = alLeft
  Caption = 'Hospital Information System - v2.4'
  ClientHeight = 441
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mnuPrincipal
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object tvPrincipal: TTreeView
    Left = 0
    Top = 0
    Width = 348
    Height = 441
    Align = alClient
    Indent = 19
    TabOrder = 0
    OnDblClick = tvPrincipalDblClick
    Items.NodeData = {
      070100000009540054007200650065004E006F00640065003100000002000000
      0200000002000000FFFFFFFF02000000000000000002000000010943006F006E
      00730075006C00740061007300000033000000150000001500000015000000FF
      FFFFFF15000000000000000000000000010A45006D0070007200650067006100
      64006F007300000039000000160000001600000016000000FFFFFFFF16000000
      000000000000000000010D44006500700061007200740061006D0065006E0074
      006F007300}
    ExplicitWidth = 346
    ExplicitHeight = 433
  end
  object mnuPrincipal: TMainMenu
    Left = 224
    Top = 48
    object mniArquivo: TMenuItem
      Caption = 'Arquivo'
      object mniSair: TMenuItem
        Caption = 'Sair'
        OnClick = mniSairClick
      end
    end
    object mniConsultas: TMenuItem
      Caption = 'Consultas'
      object mniConsultaEmpregados: TMenuItem
        Caption = 'Empregados'
        OnClick = mniConsultaEmpregadosClick
      end
      object mniConsultaDepartamentos: TMenuItem
        Caption = 'Departamentos'
        OnClick = mniConsultaDepartamentosClick
      end
    end
  end
end
