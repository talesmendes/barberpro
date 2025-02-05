unit UnitReserva;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  uLoading, FMX.TabControl, uCustomCalendar, uSession;

type
  TFrmReserva = class(TForm)
    lytToolbar: TLayout;
    imgFechar: TImage;
    Label1: TLabel;
    lblServico: TLabel;
    Label3: TLabel;
    lbProfissionais: TListBox;
    TabControl: TTabControl;
    Tab1: TTabItem;
    Tab2: TTabItem;
    rectFundo1: TRectangle;
    rectFundo2: TRectangle;
    lblServicoPrestador: TLabel;
    lbHorario: TListBox;
    Label5: TLabel;
    lytCalendario: TLayout;
    Label6: TLabel;
    rectReserva: TRectangle;
    btnReserva: TSpeedButton;
    lytNavegacao: TLayout;
    lblMes: TLabel;
    imgPrior: TImage;
    imgNext: TImage;
    Tab3: TTabItem;
    Rectangle1: TRectangle;
    Image1: TImage;
    Label7: TLabel;
    procedure FormShow(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbProfissionaisItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbHorarioItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure imgPriorClick(Sender: TObject);
    procedure imgNextClick(Sender: TObject);
    procedure btnReservaClick(Sender: TObject);
  private
    cal: TCustomCalendar;
    Fid_servico: integer;
    Fid_prestador: integer;
    Fhora: string;
    Fdescr_servico: string;
    procedure TerminateProfissionais(Sender: TObject);
    procedure RefreshProfissionais;
    procedure AddProfissionalListbox(id_prestador: integer; nome: string;
      preco: double);
    procedure DayClick(Sender: TObject);
    procedure ListarHorarios;
    procedure TerminateHorario(Sender: TObject);
    procedure AddHorarioListbox(id_horario: integer; hora: string);
    procedure SelecionarHora(item: TListboxItem);
    procedure TerminateReserva(Sender: TObject);
    { Private declarations }
  public
    property id_servico: integer read Fid_servico write Fid_servico;
    property descr_servico: string read Fdescr_servico write Fdescr_servico;
  end;

var
  FrmReserva: TFrmReserva;

implementation

{$R *.fmx}

uses UnitFrameProfissional, UnitFrameHora, DataModule.Geral;

procedure TFrmReserva.SelecionarHora(item: TListboxItem);
var
    frame: TFrameHora;
    item_temp: TListboxItem;
    i: integer;
begin
    btnReserva.Enabled := true;
    rectReserva.Opacity := 1;

    // Deixando todos os horarios com fundo escuro
    for i := 0 to lbHorario.Items.Count - 1 do
    begin
        item_temp := lbHorario.ItemByIndex(i);

        frame := TFrameHora(item_temp.Components[0]);
        frame.rectHora.Fill.Color := $FF232323;
    end;

    // Marcar item em laranja
    frame := TFrameHora(item.Components[0]);
    frame.rectHora.Fill.Color := $FFFE9900;
    Fhora := frame.lblHora.Text;
end;

procedure TFrmReserva.AddHorarioListbox(id_horario: integer;
                                        hora: string);
var
    item: TListBoxItem;
    frame: TFrameHora;
begin
    // item da listbox
    item := TListBoxItem.Create(lbHorario);
    item.Selectable := false;
    item.Text := '';
    item.Width := 85;
    item.Tag := id_horario;

    // frame do horario
    frame := TFrameHora.Create(item);
    frame.lblHora.Text := hora;

    item.AddObject(frame);

    lbHorario.AddObject(item);
end;

procedure TFrmReserva.TerminateHorario(Sender: TObject);
begin
    TLoading.Hide;

    // Se deu erro, devemos abortar o acessso...
    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(sender).FatalException).Message);
        exit;
    end;

    with DmGeral.TabHorario do
    begin
        while NOT Eof do
        begin
            AddHorarioListbox(fieldbyname('id').AsInteger,
                              FieldByName('horario').AsString);

            Next;
        end;
    end;

end;

procedure TFrmReserva.TerminateReserva(Sender: TObject);
begin
    TLoading.Hide;

    // Se deu erro, devemos abortar o acessso...
    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(sender).FatalException).Message);
        exit;
    end;

    TabControl.GotoVisibleTab(2);
end;

procedure TFrmReserva.ListarHorarios;
begin
    btnReserva.Enabled := false;
    rectReserva.Opacity := 0.3;

    lblMes.Text := cal.MonthName;
    lbHorario.Items.Clear;

    TLoading.Show(FrmReserva);

    TLoading.ExecuteThread(procedure
    begin
        DmGeral.ListarHorarios(id_servico,
                               Fid_prestador,
                               FormatDateTime('yyyy-mm-dd', cal.SelectedDate),
                               DmGeral.TabHorario);
    end, TerminateHorario);

end;

procedure TFrmReserva.AddProfissionalListbox(id_prestador: integer;
                                             nome: string;
                                             preco: double);
var
    item: TListBoxItem;
    frame: TFrameProfissional;
begin
    // item da listbox
    item := TListBoxItem.Create(lbProfissionais);
    item.Selectable := false;
    item.Text := '';
    item.Height := 60;
    item.Tag := id_prestador;
    item.TagString := nome;

    // frame do profissional
    frame := TFrameProfissional.Create(item);
    frame.lblNome.Text := nome;
    frame.lblPreco.Text := FormatFloat('R$ #,##0.00', preco);

    item.AddObject(frame);

    lbProfissionais.AddObject(item);
end;

procedure TFrmReserva.btnReservaClick(Sender: TObject);
begin
    TLoading.Show(FrmReserva);

    TLoading.ExecuteThread(procedure
    begin
        DmGeral.InserirReserva(TSession.ID_USUARIO,
                               id_servico,
                               Fid_prestador,
                               FormatDateTime('yyyy-mm-dd', cal.SelectedDate),
                               FHora);
    end,
    TerminateReserva);
end;

procedure TFrmReserva.TerminateProfissionais(Sender: TObject);
begin
    TLoading.Hide;

    // Se deu erro, devemos abortar o acessso...
    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(sender).FatalException).Message);
        exit;
    end;

    with DmGeral.TabPrestador do
    begin
        while NOT Eof do
        begin
            AddProfissionalListbox(FieldByName('idprestador').AsInteger,
                                   FieldByName('nomeprestador').AsString,
                                   FieldByName('preco').AsFloat);

            DmGeral.TabPrestador.Next;
        end;
    end;
end;

procedure TFrmReserva.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmReserva := nil;
end;

procedure TFrmReserva.DayClick(Sender: TObject);
begin
    //showmessage(FormatDateTime('dd/mm/yyyy', cal.SelectedDate))
    ListarHorarios;
end;

procedure TFrmReserva.FormCreate(Sender: TObject);
begin
    TabControl.ActiveTab := Tab1;

    // Monta o calendario
    cal := TCustomCalendar.Create(lytCalendario);
    cal.OnClick := DayClick;

    // Setup calendario
    cal.DayFontSize := 14;
    cal.DayFontColor := $FFFFFFFF;
    cal.SelectedDayColor := $FFFE9900;
    cal.BackgroundColor := $FF191919;

    cal.ShowCalendar;
end;

procedure TFrmReserva.FormDestroy(Sender: TObject);
begin
    cal.Free;
end;

procedure TFrmReserva.FormShow(Sender: TObject);
begin
    lblServico.Text := descr_servico;
    RefreshProfissionais;
end;

procedure TFrmReserva.imgFecharClick(Sender: TObject);
begin
    if TabControl.ActiveTab = Tab2 then
        TabControl.GotoVisibleTab(0)
    else
        close;
end;

procedure TFrmReserva.imgNextClick(Sender: TObject);
begin
    cal.NextMonth;
    ListarHorarios;
end;

procedure TFrmReserva.imgPriorClick(Sender: TObject);
begin
    cal.PriorMonth;
    ListarHorarios;
end;

procedure TFrmReserva.lbHorarioItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    SelecionarHora(Item);
end;

procedure TFrmReserva.lbProfissionaisItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    Fid_prestador := Item.Tag;
    lblServicoPrestador.Text := descr_servico + ' - ' + Item.TagString;
    ListarHorarios;
    TabControl.GotoVisibleTab(1);
end;

procedure TFrmReserva.RefreshProfissionais;
begin
    lbProfissionais.Items.Clear;
    TLoading.Show(FrmReserva);

    TLoading.ExecuteThread(procedure
    begin
        DmGeral.ListarProfissionais(id_servico, DmGeral.TabPrestador);
    end,
    TerminateProfissionais);
end;

end.
