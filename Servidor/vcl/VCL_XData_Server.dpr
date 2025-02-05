program VCL_XData_Server;

uses
  Vcl.Forms,
  Server in '..\Server.pas',
  ConnectionModule in '..\ConnectionModule.pas' {SQLiteConnection: TDataModule},
  MainForm in 'MainForm.pas' {fmServer},
  Entities in '..\Entities.pas',
  AppService in '..\AppService.pas',
  AppServiceImplementation in '..\AppServiceImplementation.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSQLiteConnection, SQLiteConnection);
  Application.CreateForm(TfmServer, fmServer);
  Application.Run;
end.
