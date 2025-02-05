object SQLiteConnection: TSQLiteConnection
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 198
  Width = 282
  object AureliusConnection1: TAureliusConnection
    DriverName = 'SQLite'
    Params.Strings = (
      'Database=Banco.db'
      'EnableForeignKeys=True')
    Left = 64
    Top = 64
  end
end
