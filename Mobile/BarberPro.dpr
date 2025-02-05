program BarberPro;

uses
  System.StartUpCopy,
  FMX.Forms,
  UnitLogin in 'UnitLogin.pas' {FrmLogin},
  UnitPrincipal in 'UnitPrincipal.pas' {FrmPrincipal},
  UnitFrameServico in 'Frames\UnitFrameServico.pas' {FrameServico: TFrame},
  uLoading in 'Utils\uLoading.pas',
  uFunctions in 'Utils\uFunctions.pas',
  UnitReserva in 'UnitReserva.pas' {FrmReserva},
  UnitFrameProfissional in 'Frames\UnitFrameProfissional.pas' {FrameProfissional: TFrame},
  uCustomCalendar in 'Utils\uCustomCalendar.pas',
  UnitFrameHora in 'Frames\UnitFrameHora.pas' {FrameHora: TFrame},
  UnitHistorico in 'UnitHistorico.pas' {FrmHistorico},
  UnitFrameHistorico in 'Frames\UnitFrameHistorico.pas' {FrameHistorico: TFrame},
  UnitConfig in 'UnitConfig.pas' {FrmConfig},
  DataModule.Geral in 'DataModules\DataModule.Geral.pas' {DmGeral: TDataModule},
  uSession in 'Utils\uSession.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmLogin, FrmLogin);
  Application.CreateForm(TFrmHistorico, FrmHistorico);
  Application.CreateForm(TFrmConfig, FrmConfig);
  Application.CreateForm(TDmGeral, DmGeral);
  Application.Run;
end.
