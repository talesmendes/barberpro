unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfmServer = class(TForm)
    Label1: TLabel;
    btnUpdEstru: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnUpdEstruClick(Sender: TObject);
  private
  public
  end;

var
  fmServer: TfmServer;

implementation

uses
  Server, ConnectionModule, Aurelius.Engine.DatabaseManager;

{$R *.dfm}

procedure TfmServer.btnUpdEstruClick(Sender: TObject);
var
  DBManager: TDatabaseManager;
begin
  DBManager := TDatabaseManager.Create(SQLiteConnection.AureliusConnection1.CreateConnection);
  DBManager.UpdateDatabase;
  DBManager.Free;
end;

procedure TfmServer.FormCreate(Sender: TObject);
begin
  StartServer;
  Label1.Caption := 'Server running!';
end;

procedure TfmServer.FormDestroy(Sender: TObject);
begin
  StopServer;
end;

end.
