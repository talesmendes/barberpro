unit DataModule.Geral;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  RESTRequest4D, DataSet.Serialize.Adapter.RESTRequest4D,
  DataSet.Serialize.Config, DataSet.Serialize, System.JSON;

type
  TDmGeral = class(TDataModule)
    TabUsuario: TFDMemTable;
    TabServico: TFDMemTable;
    TabPrestador: TFDMemTable;
    TabHorario: TFDMemTable;
    TabHistorico: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
  private

  public
    procedure Login(email, senha: string; MemTable: TFDMemTable);
    procedure CriarConta(nome, email, senha: string; MemTable: TFDMemTable);
    procedure ListarServicos(MemTable: TFDMemTable);
    procedure ListarProfissionais(id_servico: integer; MemTable: TFDMemTable);
    procedure ListarHorarios(id_servico, id_prestador: integer; dt: string;
                             MemTable: TFDMemTable);
    procedure InserirReserva(id_usuario, id_servico, id_prestador: integer; dt,
                             hora: string);
    procedure ListarReservas(id_usuario: integer; MemTable: TFDMemTable);
    procedure ExcluirReserva(id_reserva: integer);
  end;

var
  DmGeral: TDmGeral;

Const
  BASE_URL = 'http://tmcaws.ddns.net:2001/tms/xdata/appservice';
  BASE_URLIMG = 'http://tmcaws.ddns.net:2001/tms/files/';

  {
  Alterar o arquivo: "AndroidManifest.template.xml"
  Colocar na tag application: android:usesCleartextTraffic="true"
  }


implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TDmGeral.Login(email, senha: string; MemTable: TFDMemTable);
var
    resp: IResponse;
    json: TJsonObject;
begin
    json := TJsonObject.Create;
    try
        json.AddPair('email', email);
        json.AddPair('senha', senha);

        resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/login')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .Adapters(TDataSetSerializeAdapter.New(MemTable))
                        .Post;

        if resp.StatusCode <> 200 then
            raise Exception.Create(resp.Content);

    finally
        json.Free;
    end;

end;

procedure TDmGeral.CriarConta(nome, email, senha: string; MemTable: TFDMemTable);
var
    resp: IResponse;
    json: TJsonObject;
begin
    json := TJsonObject.Create;
    try
        json.AddPair('nome', nome);
        json.AddPair('email', email);
        json.AddPair('senha', senha);

        resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/InserirUsuario')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .Adapters(TDataSetSerializeAdapter.New(MemTable))
                        .Post;

        if resp.StatusCode <> 200 then
            raise Exception.Create(resp.Content);

    finally
        json.Free;
    end;

end;

procedure TDmGeral.DataModuleCreate(Sender: TObject);
begin
    TDataSetSerializeConfig.GetInstance.CaseNameDefinition := cndLower;
    TDataSetSerializeConfig.GetInstance.Import.DecimalSeparator := '.';
end;

procedure TDmGeral.ListarServicos(MemTable: TFDMemTable);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/ListarServicos')
                      .Accept('application/json')
                      .Adapters(TDataSetSerializeAdapter.New(MemTable, 'value'))
                      .Get;

      if resp.StatusCode <> 200 then
          raise Exception.Create(resp.Content);


end;

procedure TDmGeral.ListarProfissionais(id_servico: integer; MemTable: TFDMemTable);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/ListarPrestadores')
                      .AddParam('ServicoId', id_servico.ToString)
                      .Accept('application/json')
                      .Adapters(TDataSetSerializeAdapter.New(MemTable, 'value'))
                      .Get;

      if resp.StatusCode <> 200 then
          raise Exception.Create(resp.Content);


end;

procedure TDmGeral.ListarHorarios(id_servico, id_prestador: integer; dt: string; MemTable: TFDMemTable);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/ListarHorarios')
                      .AddParam('PrestadorId', id_prestador.ToString)
                      .AddParam('ServicoId', id_servico.ToString)
                      .AddParam('Dia', dt)
                      .Accept('application/json')
                      .Adapters(TDataSetSerializeAdapter.New(MemTable, 'value'))
                      .Get;

      if resp.StatusCode <> 200 then
          raise Exception.Create(resp.Content);
end;

procedure TDmGeral.InserirReserva(id_usuario, id_servico, id_prestador: integer; dt, hora: string);
var
    resp: IResponse;
    json: TJsonObject;
begin
    json := TJsonObject.Create;
    try
        json.AddPair('UsuarioId', id_usuario);
        json.AddPair('ServicoId', id_servico);
        json.AddPair('PrestadorId', id_prestador);
        json.AddPair('Horario', dt + 'T' + hora);

        resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/InserirReserva')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .Post;

        if resp.StatusCode <> 200 then
            raise Exception.Create(resp.Content);

    finally
        json.Free;
    end;

end;

procedure TDmGeral.ListarReservas(id_usuario: integer; MemTable: TFDMemTable);
var
    resp: IResponse;
begin
    resp := TRequest.New.BaseURL(BASE_URL)
                      .Resource('/ListarReservas')
                      .AddParam('UsuarioId', id_usuario.ToString)
                      .Accept('application/json')
                      .Adapters(TDataSetSerializeAdapter.New(MemTable, 'value'))
                      .Get;

      if resp.StatusCode <> 200 then
          raise Exception.Create(resp.Content);
end;

procedure TDmGeral.ExcluirReserva(id_reserva: integer);
var
    json: TJsonObject;
    resp: IResponse;
begin
    json := TJsonObject.Create;
    try
        json.AddPair('ReservaId', id_reserva);

        resp := TRequest.New.BaseURL(BASE_URL)
                        .Resource('/ExcluirReserva')
                        .AddBody(json.ToJSON)
                        .Accept('application/json')
                        .Post;

        if resp.StatusCode <> 200 then
            raise Exception.Create(resp.Content);

    finally
        json.Free;
    end;

end;

end.
