program Backend;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  System.JSON,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.PG,
  FireDAC.Phys.PGDef,
  FireDAC.DApt,
  users,
  dtmConexao,
  convenios,
  HoraChegou in 'HoraChegou.pas';

var
  ConexaoBanco: TFDConnection;
  DataModuloConexao: TDataModuloConexao;
  porta: Integer;

// Procedure para ativar rota simples de teste
procedure Ativa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('API Online, banco: ' + ConexaoBanco.Params.Database);
end;

// Procedure para registrar as rotas da aplicação
procedure RegisterAllRoutes;
begin
  users.RegisterRoutes(ConexaoBanco);
  convenios.RegisterRoutes(ConexaoBanco);
  HoraChegou.RegisterRoutes(ConexaoBanco); // Chama unit de rotas e passa conexão
end;

begin
  try
    DataModuloConexao := TDataModuloConexao.Create(nil);
    ConexaoBanco := DataModuloConexao.FDConnection1;
    ConexaoBanco.Connected := True;
    if ConexaoBanco.Connected then
      begin
      Writeln('Servidor Conectado');
      end;

    porta := 9000;
    THorse.Use(Jhonson);

    RegisterAllRoutes;
    THorse.Get('/ativa', Ativa);

    Writeln('API rodando na porta: ', porta);
    THorse.Listen(porta);

  except
    on E: Exception do
      Writeln('Erro: ', E.Message);
  end;

  DataModuloConexao.Free;
end.

