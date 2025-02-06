unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListBox,
  uLoading, uSession, uFunctions, FMX.Ani;

type
  TFrmPrincipal = class(TForm)
    lytToolbar: TLayout;
    imgMenu: TImage;
    imgLogo: TImage;
    Label1: TLabel;
    lbServicos: TListBox;
    rectMenu: TRectangle;
    Image1: TImage;
    Layout1: TLayout;
    lblMenuAgendamentos: TLabel;
    lblMenuConfig: TLabel;
    Label4: TLabel;
    lblMenuDesconectar: TLabel;
    imgFecharMenu: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbServicosItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure imgMenuClick(Sender: TObject);
    procedure imgFecharMenuClick(Sender: TObject);
    procedure lblMenuAgendamentosClick(Sender: TObject);
    procedure lblMenuConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblMenuDesconectarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure AddServicoListbox(id_servico: integer; descricao,
                                url_icone: string);
    procedure RefreshServicos;
    procedure TerminateServicos(Sender: TObject);
    procedure DownloadFotoListbox(lb: TListBox);
    procedure Menu;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.fmx}

uses UnitFrameServico, UnitReserva, UnitHistorico, UnitConfig, DataModule.Geral,
  UnitLogin;

procedure TFrmPrincipal.DownloadFotoListbox(lb: TListBox);
var
    t: TThread;
    foto: TBitmap;
    frame: TFrameServico;
begin
    // Carregar imagens...
    t := TThread.CreateAnonymousThread(procedure
    var
        i : integer;
    begin

        for i := 0 to lb.Items.Count - 1 do
        begin
            //sleep(1000);
            frame := TFrameServico(lb.ItemByIndex(i).Components[0]);


            if frame.imgIcone.TagString <> '' then
            begin
                foto := TBitmap.Create;
                LoadImageFromURL(foto, BASE_URLIMG + frame.imgIcone.TagString);

                frame.imgIcone.TagString := '';
                //frame.imgIcone.bitmap := foto;
                frame.imgIcone.Bitmap.Assign(foto);
                foto.Free;
            end;
        end;

    end);

    t.Start;
end;

procedure TFrmPrincipal.AddServicoListbox(id_servico: integer;
                                          descricao, url_icone: string);
var
    item: TListBoxItem;
    frame: TFrameServico;
begin
    // item da listbox
    item := TListBoxItem.Create(lbServicos);
    item.Selectable := false;
    item.Text := '';
    item.Height := 170;
    item.Tag := id_servico;
    item.TagString := descricao;

    // frame do servico
    frame := TFrameServico.Create(item);
    frame.lblDescricao.Text := descricao;
    frame.imgIcone.TagString := url_icone;

    item.AddObject(frame);

    lbServicos.AddObject(item);
end;

procedure TFrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := TCloseAction.caFree;
    FrmPrincipal := nil;
end;

procedure TFrmPrincipal.FormCreate(Sender: TObject);
begin
    rectMenu.Visible := true;
end;

procedure TFrmPrincipal.FormResize(Sender: TObject);
begin
    lbServicos.Columns := Trunc(lbServicos.Width / 140);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
    rectMenu.Position.X := (lytToolbar.Width + 50) * -1;
    RefreshServicos;
end;

procedure TFrmPrincipal.Menu;
begin
    if rectMenu.Position.X = 0 then // Aberto
        TAnimator.AnimateFloat(rectMenu, 'Position.X', (lytToolbar.Width + 50) * -1, 0.5, TAnimationType.InOut,
                              TInterpolationType.Circular)
    else
    begin
        rectMenu.Width := FrmPrincipal.ClientWidth;
        rectMenu.Height := FrmPrincipal.ClientHeight;


        TAnimator.AnimateFloat(rectMenu, 'Position.X', 0, 0.5, TAnimationType.Out,
                              TInterpolationType.Circular)
    end;
end;

procedure TFrmPrincipal.imgFecharMenuClick(Sender: TObject);
begin
    Menu;
end;

procedure TFrmPrincipal.imgMenuClick(Sender: TObject);
begin
    Menu;
end;

procedure TFrmPrincipal.lblMenuAgendamentosClick(Sender: TObject);
begin
    Menu;

    if NOT Assigned(FrmHistorico) then
        Application.CreateForm(TFrmHistorico, FrmHistorico);

    FrmHistorico.Show;
end;

procedure TFrmPrincipal.lblMenuConfigClick(Sender: TObject);
begin
    Menu;

    if NOT Assigned(FrmConfig) then
        Application.CreateForm(TFrmConfig, FrmConfig);

    FrmConfig.Show;
end;

procedure TFrmPrincipal.lblMenuDesconectarClick(Sender: TObject);
begin
    TSession.ID_USUARIO := 0;
    TSession.NOME := '';
    TSession.EMAIL := '';

    if NOT Assigned(FrmLogin) then
        Application.CreateForm(TFrmLogin, FrmLogin);

    Application.MainForm := FrmLogin;

    FrmLogin.show;
    FrmPrincipal.Close;
end;

procedure TFrmPrincipal.lbServicosItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
    if NOT Assigned(FrmReserva) then
        Application.CreateForm(TFrmReserva, FrmReserva);

    FrmReserva.id_servico := Item.Tag;
    FrmReserva.descr_servico := Item.TagString;
    FrmReserva.Show;
end;

procedure TFrmPrincipal.TerminateServicos(Sender: TObject);
begin
    TLoading.Hide;

    // Se deu erro, devemos abortar o acessso...
    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(sender).FatalException).Message);
        exit;
    end;

    while NOT DmGeral.TabServico.Eof do
    begin
        AddServicoListbox(DmGeral.TabServico.FieldByName('id').AsInteger,
                          DmGeral.TabServico.FieldByName('descricao').AsString,
                          DmGeral.TabServico.FieldByName('UrlIcone').AsString);

        DmGeral.TabServico.Next;
    end;

    DownloadFotoListbox(lbServicos);
end;

procedure TFrmPrincipal.RefreshServicos;
begin
    lbServicos.Items.Clear;
    TLoading.Show(FrmPrincipal);

    TLoading.ExecuteThread(procedure
    begin
        DmGeral.ListarServicos(DmGeral.TabServico);
    end,
    TerminateServicos);
end;

end.
