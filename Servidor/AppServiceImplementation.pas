unit AppServiceImplementation;

interface

uses
  System.SysUtils, System.JSON, System.Generics.Collections, XData.Server.Module, XData.Service.Common,
  XData.Sys.Exceptions, Aurelius.Drivers.Interfaces, Aurelius.Engine.ObjectManager, Aurelius.Criteria.Linq,
  Entities, AppService;

type
  [ServiceImplementation]
  TAppService = class(TInterfacedObject, IAppService)
  private
    function GetConnection: IDBConnection;
    function GetManager: TObjectManager;
  public
    function Login(Email, Senha: string): TUsuario;
    function InserirUsuario(Nome, Email, Senha: string): TUsuario;
    function ListarServicos: TList<TServico>;
    function ListarPrestadores(ServicoId: Integer): TList<TServicoPrestador>;
    function ListarHorarios(ServicoId, PrestadorId: Integer; Dia: TDate): TList<THorario>;
    function ListarReservas(UsuarioId: Integer): TList<TReserva>;
    function InserirReserva(UsuarioId, ServicoId, PrestadorId: Integer; Horario: TDateTime): TReserva;
    function ExcluirReserva(ReservaId: Integer): Boolean;
  end;

implementation

{ TAppService }

function TAppService.GetManager: TObjectManager;
begin
  Result := TXDataOperationContext.Current.GetManager;
end;

function TAppService.InserirReserva(UsuarioId, ServicoId, PrestadorId: Integer; Horario: TDateTime): TReserva;
var
  Reserva: TReserva;
begin
  Reserva := TReserva.Create;
  Reserva.Usuario   := GetManager.Find<TUsuario>(UsuarioId);
  Reserva.Servico   := GetManager.Find<TServico>(ServicoId);
  Reserva.Prestador := GetManager.Find<TPrestador>(PrestadorId);
  Reserva.Dia       := FormatDateTime('yyyy-mm-dd', Horario);
  Reserva.Hora      := FormatDateTime('hh:mm', Horario);
  GetManager.Save(Reserva);
  Result := Reserva;
end;

function TAppService.InserirUsuario(Nome, Email, Senha: string): TUsuario;
var
  Usuario: TUsuario;
begin
  Usuario := TUsuario.Create;
  Usuario.Nome  := Nome;
  Usuario.Email := Email;
  Usuario.Senha := Senha;
  GetManager.Save(Usuario);
  Result := Usuario;
end;

function TAppService.ExcluirReserva(ReservaId: Integer): Boolean;
var
  Reserva: TReserva;
begin
  Reserva := GetManager.Find<TReserva>(ReservaId);
  GetManager.Remove(Reserva);
  Result := True;
end;

function TAppService.GetConnection: IDBConnection;
begin
  Result := TXDataOperationContext.Current.Connection;
end;

function TAppService.ListarHorarios(ServicoId, PrestadorId: Integer; Dia: TDate): TList<THorario>;
begin
  Result := GetManager.Find<THorario>.CreateAlias('Servico', 'S').CreateAlias('Prestador', 'P')
    .Add(Linq['P.Id'] = PrestadorId)
    .Add(Linq['S.Id'] = ServicoId)
    .Where(Linq.Sql(Format(
      '{Horario} not in (select r.hora from reserva r where r.PrestadorId = {P.Id} and r.ServicoId = {S.Id} and r.Dia = ''%s'')'
     , [FormatDateTime('yyyy-mm-dd', Dia)])))
    .OrderBy('Horario')
    .List;
end;

function TAppService.ListarPrestadores(ServicoId: Integer): TList<TServicoPrestador>;
begin
  Result := GetManager.Find<TServicoPrestador>.CreateAlias('Servico', 'S')
    .Add(Linq['S.Id'] = ServicoId)
    .OrderBy('Id').List;
end;

function TAppService.ListarReservas(UsuarioId: Integer): TList<TReserva>;
begin
  Result := GetManager.Find<TReserva>.Add(Linq['Usuario.Id'] = UsuarioId).OrderBy('Dia', False).List;
end;

function TAppService.ListarServicos: TList<TServico>;
begin
  Result := GetManager.Find<TServico>.OrderBy('Descricao').List;
end;

function TAppService.Login(Email, Senha: string): TUsuario;
var
  Usuario: TUsuario;
begin
  Usuario := GetManager.Find<TUsuario>.Add(Linq['Email'].Lower = Email.ToLower).Add(Linq['Senha'].Lower = Senha.ToLower).UniqueResult;
  if not Assigned(Usuario) then
    raise EXDataHttpUnauthorized.Create('E-mail ou senha inválida');
  Result := Usuario;
end;

initialization
  RegisterServiceType(TAppService);

end.
