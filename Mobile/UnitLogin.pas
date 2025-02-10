unit UnitLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Objects, FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  uLoading, uSession;

type
  TFrmLogin = class(TForm)
    TabControl: TTabControl;
    TabLogin: TTabItem;
    TabNovaConta: TTabItem;
    rectFundo1: TRectangle;
    Image1: TImage;
    Layout1: TLayout;
    Label1: TLabel;
    edtEmail: TEdit;
    Label2: TLabel;
    edtSenha: TEdit;
    Rectangle2: TRectangle;
    btnLogin: TSpeedButton;
    lblNovaConta: TLabel;
    Rectangle1: TRectangle;
    Image2: TImage;
    Layout2: TLayout;
    Label4: TLabel;
    edtContaNome: TEdit;
    Label5: TLabel;
    EdtContaSenha: TEdit;
    Rectangle3: TRectangle;
    btnCriarConta: TSpeedButton;
    lblLogin: TLabel;
    Label7: TLabel;
    EdtContaEmail: TEdit;
    Label8: TLabel;
    EdtContaSenha2: TEdit;
    procedure lblNovaContaClick(Sender: TObject);
    procedure lblLoginClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure btnCriarContaClick(Sender: TObject);
  private
    procedure TerminateLogin(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

{$R *.fmx}

uses UnitPrincipal, DataModule.Geral, uFunctions, UnitExemplo;

procedure TFrmLogin.TerminateLogin(Sender: TObject);
begin
    TLoading.Hide;

    // Se deu erro, devemos abortar o acessso...
    if Assigned(TThread(Sender).FatalException) then
    begin
        showmessage(Exception(TThread(sender).FatalException).Message);
        exit;
    end;

    TSession.ID_USUARIO := DmGeral.TabUsuario.FieldByName('id').AsInteger;
    TSession.NOME := DmGeral.TabUsuario.FieldByName('nome').AsString;
    TSession.EMAIL := DmGeral.TabUsuario.FieldByName('email').AsString;

    if NOT Assigned(FrmPrincipal) then
        Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    FrmLogin.Close;
end;


procedure TFrmLogin.btnCriarContaClick(Sender: TObject);
begin
    if (EdtContaSenha.Text <> EdtContaSenha2.Text) then
    begin
        showmessage('As senhas não conferem. Digite novamente.');
        exit;
    end;

    TLoading.Show(FrmLogin);

    TLoading.ExecuteThread(procedure
    begin
        DmGeral.CriarConta(edtContaNome.text, edtContaEmail.Text,
                           edtContaSenha.Text, DmGeral.TabUsuario);
    end,
    TerminateLogin);
end;

procedure TFrmLogin.btnLoginClick(Sender: TObject);
begin
  TUtils.OpenForm<TfrmExemplo>(procedure(aForm: TfrmExemplo)
  begin
    aForm.Codigo := 1001;
  end);

   //TLoading.Show(FrmLogin);

   // TLoading.ExecuteThread(procedure
   // begin
   //     DmGeral.Login(edtEmail.Text, edtSenha.Text, DmGeral.TabUsuario);
   // end,
   // TerminateLogin);
end;


procedure TFrmLogin.lblLoginClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(0);
end;

procedure TFrmLogin.lblNovaContaClick(Sender: TObject);
begin
    TabControl.GotoVisibleTab(1);
end;

end.
