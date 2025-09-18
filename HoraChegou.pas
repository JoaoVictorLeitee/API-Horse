unit HoraChegou;

interface

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
  FireDAC.DApt;


procedure RegisterRoutes(AConexao: TFDConnection);

implementation

var
ConexaoBanco: TFDConnection;


procedure RegisterRoutes(AConexao: TFDConnection);
begin
  THorse.post('/horachegou',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      Query: TFDQuery;
      JSONBody: TJSONObject;
      JSONArr: TJSONArray;
      TJSONObj: TJSONObject;
      IDpaciente: Integer;
      NomePaciente, DataMarcacao: String;
    begin
    JSONBody := Req.Body<TJSONObject>;
     IDPaciente     := JSONBody.GetValue<Integer>('cod_paciente');
     NomePaciente   := JSONBody.GetValue<string>('nom_paciente');
     DataMarcacao   := JSONBody.GetValue<string>('dat_marcacao');

     Query := TFDQuery.Create(nil);
      try
        Query.Connection := AConexao; // usa a conexão que foi passada
        Query.SQL.Text := 'INSERT INTO arq_agendal(cod_paciente, nom_paciente, dat_marcacao)' + 'Values (:id, :nome, :data)';
        Query.ParamByName('id').AsInteger := IDpaciente;
        Query.ParamByName('nome').AsString := NomePaciente;
        Query.ParamByName('data').AsDate := StrToDate(DataMarcacao);
        Query.ExecSQL;
      finally
        Query.Free;
      end;
    end);
end;

end.
