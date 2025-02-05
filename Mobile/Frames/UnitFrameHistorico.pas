unit UnitFrameHistorico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Objects, FMX.Controls.Presentation;

type
  TFrameHistorico = class(TFrame)
    rectFundo: TRectangle;
    lblDescricao: TLabel;
    lblServico: TLabel;
    imgExcluir: TImage;
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
