unit UnitHistorico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListBox, uLoading,
  uSession, uFunctions, FMX.DialogService;

type
  TFrmHistorico = class(TForm)
    lytToolbar: TLayout;
    Label1: TLabel;
    imgFechar: TImage;
    lbHistorico: TListBox;
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure AddHistoricoListbox(id_reserva: integer; servico, prestador, dt,
      hora: string; ind_exclusao: boolean);
    procedure RefreshHistorico;
    procedure TerminateHistorico(Sender: TObject);
    procedure ClickDelete(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmHistorico: TFrmHistorico;

implementation

{$R *.fmx}

uses UnitFrameHistorico, DataModule.Geral;

procedure TFrmHistorico.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmHistorico := nil;
end;

procedure TFrmHistorico.FormShow(Sender: TObject);
begin
    RefreshHistorico;
end;

procedure TFrmHistorico.imgFecharClick(Sender: TObject);
begin
    close;
end;

procedure TFrmHistorico.ClickDelete(Sender: TObject);
var
    id_reserva: integer;
begin
    id_reserva := TImage(Sender).Tag;

    TDialogService.MessageDialog('Confirma exclusão da reserva?',
                                 TMsgDlgType.mtConfirmation,
                                 [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                                 TMsgDlgBtn.mbNo,
                                 0,
                                 procedure(const AResult: TModalResult)
                                 begin
                                    if AResult = mrYes then
                                    begin
                                        DmGeral.ExcluirReserva(id_reserva);
                                        RefreshHistorico;
                                    end;
                                 end);
end;

procedure TFrmHistorico.AddHistoricoListbox(id_reserva: integer;
                                            servico, prestador, dt, hora: string;
                                            ind_exclusao: boolean);
var
    item: TListBoxItem;
    frame: TFrameHistorico;
begin
    // item da listbox
    item := TListBoxItem.Create(lbHistorico);
    item.Selectable := false;
    item.Text := '';
    item.height := 70;
    item.Tag := id_reserva;

    // frame do horario
    frame := TFrameHistorico.Create(item);
    frame.lblServico.Text := servico;
    frame.lblDescricao.Text := prestador + ' - ' + dt + ' ' + hora;
    frame.imgExcluir.Visible := ind_exclusao;
    frame.imgExcluir.Tag := id_reserva;
    frame.imgExcluir.OnClick := ClickDelete;

    item.AddObject(frame);

    lbHistorico.AddObject(item);
end;

procedure TFrmHistorico.TerminateHistorico(Sender: TObject);
var
  ind_exclusao: boolean;
begin
    TLoading.Hide;

    // Se deu erro, devemos abortar o acessso...
    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(sender).FatalException).Message);
        exit;
    end;

    with DmGeral.TabHistorico do
    begin
        while NOT Eof do
        begin
            ind_exclusao := FieldByName('Dia').AsString >=
                            FormatDateTime('yyyy-mm-dd', now);

            AddHistoricoListbox(FieldByName('id').AsInteger,
                                FieldByName('NomeServico').AsString,
                                FieldByName('NomePrestador').AsString,
                                UTCtoShortDateBR(FieldByName('Dia').AsString),
                                FieldByName('Hora').AsString,
                                ind_exclusao);

            Next;
        end;
    end;
end;

procedure TFrmHistorico.RefreshHistorico;
begin
    lbHistorico.Items.Clear;
    TLoading.Show(FrmHistorico);

    TLoading.ExecuteThread(procedure
    begin
        DmGeral.ListarReservas(TSession.ID_USUARIO, DmGeral.TabHistorico);
    end,
    TerminateHistorico);
end;


end.
