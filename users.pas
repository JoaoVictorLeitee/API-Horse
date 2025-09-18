unit users;


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
  THorse.Get('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      Query: TFDQuery;
      JSONArr: TJSONArray;
      TJSONObj: TJSONObject;
    begin
      Query := TFDQuery.Create(nil);
      try
        Query.Connection := AConexao; // usa a conexão que foi passada
        Query.SQL.Text := 'SELECT nom_paciente, dat_nascimento FROM arq_paciente limit 10';
        Query.Open;

        JSONArr := TJSONArray.Create;
        try
          while not Query.Eof do
          begin
            TJSONObj := TJSONObject.Create;
            TJSONObj.AddPair('nom_paciente', Query.FieldByName('nom_paciente').AsString);
            TJSONObj.AddPair('dat_nascimento', Query.FieldByName('dat_nascimento').AsString);
            JSONArr.AddElement(TJSONObj);
            Query.Next;
          end;

          Res.Send<TJSONArray>(JSONArr);
          // NÃO liberar JSONArray aqui, Horse libera automaticamente
        except
          JSONArr.Free;
          raise;
        end;

      finally
        Query.Free;
      end;
    end);
end;

end.
