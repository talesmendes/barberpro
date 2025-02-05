unit Entities;

interface

uses
  Aurelius.Mapping.Attributes, XData.Model.Attributes;

type
  [Entity]
  [Table('Usuario')]
  [Sequence('UsuarioSeq')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TUsuario = class
  private
    [Column('Id', [TColumnProp.Unique, TColumnProp.Required, TColumnProp.NoUpdate])]
    FId: Integer;

    [Column('Nome', [TColumnProp.Required], 100)]
    FNome: string;

    [Column('Email', [TColumnProp.Required], 100)]
    FEmail: string;

    [Column('Senha', [TColumnProp.Required], 50)]
    FSenha: string;
  public
    property Id: integer read FId;
    property Nome: string read FNome write FNome;
    property Email: string read FEmail write FEmail;
    property Senha: string read FSenha write FSenha;
  end;

  [Entity]
  [Table('Servico')]
  [Sequence('ServicoSeq')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TServico = class
  private
    [Column('Id', [TColumnProp.Unique, TColumnProp.Required, TColumnProp.NoUpdate])]
    FId: Integer;

    [Column('Descricao', [TColumnProp.Required], 100)]
    FDescricao: string;

    [Column('UrlIcone', [TColumnProp.Required], 1024)]
    FUrlIcone: string;
  public
    property Id: integer read FId;
    property Descricao: string read FDescricao write FDescricao;
    property UrlIcone: string read FUrlIcone write FUrlIcone;
  end;

  [Entity]
  [Table('Prestador')]
  [Sequence('PrestadorSeq')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TPrestador = class
  private
    [Column('Id', [TColumnProp.Unique, TColumnProp.Required, TColumnProp.NoUpdate])]
    FId: Integer;

    [Column('Nome', [TColumnProp.Required], 100)]
    FNome: string;
  public
    property Id: integer read FId;
    property Nome: string read FNome write FNome;
  end;

  [Entity]
  [Table('ServicoPrestador')]
  [Sequence('ServicoPrestadorSeq')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TServicoPrestador = class
  private
    [Column('Id', [TColumnProp.Unique, TColumnProp.Required, TColumnProp.NoUpdate])]
    FId: Integer;

    [Association([TAssociationProp.Required], [])]
    [JoinColumn('ServicoId', [])]
    FServico: TServico;

    [Association([TAssociationProp.Required], [])]
    [JoinColumn('PrestadorId', [])]
    FPrestador: TPrestador;

    [Column('Preco', [TColumnProp.Required], 10, 2)]
    FPreco: Currency;
    function GetNomePrestador: string;
    function GetNomeServico: string;
    function GetIdPrestador: Integer;
  public
    property Id: integer read FId;
    property Servico: TServico read FServico write FServico;
    property Prestador: TPrestador read FPrestador write FPrestador;
    property Preco: Currency read FPreco write FPreco;
    [XDataProperty]
    property NomeServico: string read GetNomeServico;
    [XDataProperty]
    property NomePrestador: string read GetNomePrestador;
    [XDataProperty]
    property IdPrestador: Integer read GetIdPrestador;
  end;

  [Entity]
  [Table('Reserva')]
  [Sequence('ReservaSeq')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  TReserva = class
  private
    [Column('Id', [TColumnProp.Unique, TColumnProp.Required, TColumnProp.NoUpdate])]
    FId: Integer;

    [Association([TAssociationProp.Required], [])]
    [JoinColumn('UsuarioId', [])]
    FUsuario: TUsuario;

    [Association([TAssociationProp.Required], [])]
    [JoinColumn('ServicoId', [])]
    FServico: TServico;

    [Association([TAssociationProp.Required], [])]
    [JoinColumn('PrestadorId', [])]
    FPrestador: TPrestador;

    [Column('Dia', [])]
    FDia: String;

    [Column('Hora', [])]
    FHora: String;
    function GetNomePrestador: string;
    function GetNomeServico: string;
  public
    property Id: integer read FId;
    property Usuario: TUsuario read FUsuario write FUsuario;
    property Servico: TServico read FServico write FServico;
    property Prestador: TPrestador read FPrestador write FPrestador;
    property Dia: String read FDia write FDia;
    property Hora: String read FHora write FHora;
    [XDataProperty]
    property NomeServico: string read GetNomeServico;
    [XDataProperty]
    property NomePrestador: string read GetNomePrestador;
  end;

  [Entity]
  [Table('Horario')]
  [Sequence('HorarioSeq')]
  [Id('FId', TIdGenerator.IdentityOrSequence)]
  THorario = class
  private
    [Column('Id', [TColumnProp.Unique, TColumnProp.Required, TColumnProp.NoUpdate])]
    FId: Integer;

    [Association([TAssociationProp.Required], [])]
    [JoinColumn('ServicoId', [])]
    FServico: TServico;

    [Association([TAssociationProp.Required], [])]
    [JoinColumn('PrestadorId', [])]
    FPrestador: TPrestador;

    [Column('Horario', [])]
    FHorario: String;
  public
    property Id: integer read FId;
    property Servico: TServico read FServico write FServico;
    property Prestador: TPrestador read FPrestador write FPrestador;
    property Horario: String read FHorario write FHorario;
  end;

implementation

{ TServicoPrestador }

function TServicoPrestador.GetIdPrestador: Integer;
begin
  Result := Prestador.Id;
end;

function TServicoPrestador.GetNomePrestador: string;
begin
  Result := Prestador.Nome;
end;

function TServicoPrestador.GetNomeServico: string;
begin
  Result := Servico.FDescricao;
end;

{ TReserva }

function TReserva.GetNomePrestador: string;
begin
  Result := Prestador.Nome;
end;

function TReserva.GetNomeServico: string;
begin
  Result := Servico.Descricao;
end;

initialization
  RegisterEntity(TUsuario);
  RegisterEntity(TServico);
  RegisterEntity(TPrestador);
  RegisterEntity(TServicoPrestador);
  RegisterEntity(TReserva);
  RegisterEntity(THorario);

end.
