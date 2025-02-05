unit UnitConfig;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts;

type
  TFrmConfig = class(TForm)
    lytToolbar: TLayout;
    Label1: TLabel;
    imgFechar: TImage;
    rectMenuDados: TRectangle;
    Image1: TImage;
    Label2: TLabel;
    rectMenuSenha: TRectangle;
    Image2: TImage;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgFecharClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmConfig: TFrmConfig;

implementation

{$R *.fmx}

procedure TFrmConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmConfig := nil;
end;

procedure TFrmConfig.imgFecharClick(Sender: TObject);
begin
    close;
end;

end.
