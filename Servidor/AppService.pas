unit AppService;

interface

uses
  System.Generics.Collections, XData.Service.Common, Entities;

type
  [ServiceContract]
  IAppService = interface(IInvokable)
    ['{7ED75262-87E0-4CA0-80A1-448FB9D312A1}']
    [HttpPost]
    function Login(Email, Senha: string): TUsuario;
    [HttpPost]
    function InserirUsuario(Nome, Email, Senha: string): TUsuario;
    [HttpGet]
    function ListarServicos: TList<TServico>;
    [HttpGet]
    function ListarPrestadores(ServicoId: Integer): TList<TServicoPrestador>;
    [HttpGet]
    function ListarHorarios(ServicoId, PrestadorId: Integer; Dia: TDate): TList<THorario>;
    [HttpGet]
    function ListarReservas(UsuarioId: Integer): TList<TReserva>;
    [HttpPost]
    function InserirReserva(UsuarioId, ServicoId, PrestadorId: Integer; Horario: TDateTime): TReserva;
    [HttpPost]
    function ExcluirReserva(ReservaId: Integer): Boolean;
  end;

implementation

initialization
  RegisterServiceType(TypeInfo(IAppService));

end.
