unit UnitExemplo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UnitFormBase, FMX.Controls.Presentation;

type
  TfrmExemplo = class(TfrmBase)
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure Terminate(Sender: TObject);
  public
    Codigo: Word;
  end;

implementation

{$R *.fmx}

uses uLoading;

procedure TfrmExemplo.Button1Click(Sender: TObject);
begin
  inherited;
  ShowMessageFmt('O código atribuído após a criação é %d', [Codigo]);
end;

procedure TfrmExemplo.FormShow(Sender: TObject);
begin
  inherited;
  TLoading.Show(Self);
  TLoading.ExecuteThread(procedure
  begin
    Sleep(8000);
  end,Terminate);
end;

procedure TfrmExemplo.Terminate(Sender: TObject);
begin
  TLoading.Hide;
  ShowMessage('Terminei');
end;

end.
