unit Server;

interface

uses 
  ConnectionModule, 
  XData.Server.Module,
  System.SysUtils,
  Sparkle.Middleware.Cors,
  Sparkle.Middleware.Compress,
  Sparkle.HttpSys.Server,
  Sparkle.HttpServer.Context,
  Sparkle.HttpServer.Module,
  Sparkle.Module.Static;

procedure StartServer;
procedure StopServer;

implementation

uses
  System.IOUtils;

var
  SparkleServer: THttpSysServer;

procedure StartServer;
var
  Module: TXDataServerModule;
  SM: TStaticModule;
begin
  if Assigned(SparkleServer) then
     Exit;

  SparkleServer := THttpSysServer.Create;

  Module := TXDataServerModule.Create('http://+:2001/tms/xdata', TSQLiteConnection.CreatePool(20));

  // Uncomment line below to enable CORS in the server
  //Module.AddMiddleware(TCorsMiddleware.Create);

  // Uncomment line below to allow compressed responses from server
  //Module.AddMiddleware(TCompressMiddleware.Create);

  SparkleServer.AddModule(Module);

  SM := TStaticModule.Create('http://+:2001/tms/files', ExtractFilePath(ParamStr(0)) + 'myfiles');
  SparkleServer.AddModule(SM);

  SparkleServer.Start;
end;

procedure StopServer;
begin
  FreeAndNil(SparkleServer);
end;

initialization
  SparkleServer := nil;
finalization
  StopServer;
end.
