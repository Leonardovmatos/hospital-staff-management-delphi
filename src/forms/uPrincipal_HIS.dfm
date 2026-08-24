object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
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
      070200000009540054007200650065004E006F00640065003100000001000000
      0100000001000000FFFFFFFF0100000000000000000200000001094300610064
      0061007300740072006F0073000000330000000B0000000B0000000B000000FF
      FFFFFF0B000000000000000000000000010A45006D0070007200650067006100
      64006F0073000000390000000C0000000C0000000C000000FFFFFFFF0C000000
      000000000000000000010D44006500700061007200740061006D0065006E0074
      006F007300000031000000020000000200000002000000FFFFFFFF0200000000
      0000000002000000010943006F006E00730075006C0074006100730000003300
      0000150000001500000015000000FFFFFFFF1500000000000000000000000001
      0A45006D007000720065006700610064006F0073000000390000001600000016
      00000016000000FFFFFFFF16000000000000000000000000010D440065007000
      61007200740061006D0065006E0074006F007300}
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
