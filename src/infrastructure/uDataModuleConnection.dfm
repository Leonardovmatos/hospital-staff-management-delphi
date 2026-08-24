object dmConnection: TdmConnection
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=PG'
      'Server=127.0.0.1'
      'Database=Hospital_Info_System'
      'User_Name=postgres'
      'Password=25261172'
      'CharacterSet=UTF8')
    LoginPrompt = False
    Left = 256
    Top = 168
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    Left = 248
    Top = 264
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 256
    Top = 360
  end
end
