program chinook;

{$MODE OBJFPC}{$H+}{$J-}

uses
  CRT, Classes, SysUtils, SQLDB, SQLite3Conn;

var
  sqlite3: TSQLite3Connection;
  dbTrans: TSQLTransaction;
  dbQuery: TSQLQuery;
  slNames: TStringList;
  quit: boolean = false;

function sqlDBError(const msg: string): string;
begin
  // error message reformatting
  result := 'ERROR: '+StringReplace(msg,'TSQLite3Connection : ','',[]);
end;

function openDB(const dbName: string): boolean;
begin
  // create components
  sqlite3 := TSQLite3Connection.Create(nil);
  dbTrans := TSQLTransaction.Create(nil);
  dbQuery := TSQLQuery.Create(nil);
  slNames := TStringList.Create;

  // setup components
  sqlite3.Transaction   := dbTrans;
  dbTrans.Database      := sqlite3;
  dbQuery.Transaction   := dbTrans;
  dbQuery.Database      := sqlite3;
  slNames.CaseSensitive := false;

  // setup db
  sqlite3.DatabaseName := dbName;
  sqlite3.HostName     := 'localhost';
  sqlite3.CharSet      := 'UTF8';

  // open db
  if FileExists(dbName) then
  try
    sqlite3.Open;
    result := sqlite3.Connected;
  except
    on E: Exception do
    begin
      sqlite3.Close;
      writeln(sqlDBError(E.Message));
    end;
  end
  else
  begin
    result := false;
    writeln('Database file "',dbName,'" is not found.');
  end;
end;

procedure closeDB;
begin
  // disconnect
  if sqlite3.Connected then
  begin
    dbTrans.Commit;
    dbQuery.Close;
    sqlite3.Close;
  end;

  // release
  slNames.Free;
  dbQuery.Free;
  dbTrans.Free;
  sqlite3.Free;
end;

procedure showTables(const clear: boolean = true);
var
  i,j: integer;
begin
  if clear then ClrScr;

  // get and print list of tables
  sqlite3.GetTableNames(slNames,false);
  if slNames.Count > 0 then
  begin
    writeln('> "',sqlite3.DatabaseName,'" has ',slNames.Count,' table(s):');

    j := 0;
    for i := 0 to slNames.Count-1 do
      // fix included system tables bug
      if LowerCase(Copy(slNames[i],1,7)) <> 'sqlite_' then
      begin
        j := j+1;
        writeln(j,'. ',slNames[i]);
      end;
    writeln('Found ',j,' data table(s).');
  end
  else
    writeln('> "',sqlite3.DatabaseName,'" has no tables.');
end;

procedure execQuery(const sql: string);
begin
  try
    // execute command
    dbQuery.SQL.Text := sql;
    dbTrans.Active := true;
    dbQuery.ExecSQL;

    // print info
    writeln('> Executing: "',sql,'"');
    writeln('Affected ',dbQuery.RowsAffected,' record(s).');

    // commit changes
    dbTrans.Commit;
  except
    on E: Exception do
    begin
      // rollback changes
      dbTrans.Rollback;
      writeln(sqlDBError(E.Message));
    end;
  end;
end;

procedure openQuery(const sql: string);
var
  i: integer;
begin
  try
    // fetch data
    dbQuery.SQL.Text := sql;
    dbQuery.Open;

    if dbQuery.Active then
    begin
      ClrScr;
      writeln('> Fetching: "',sql,'"');

      // get and print headers
      dbQuery.GetFieldNames(slNames);
      for i := 0 to slNames.Count-1 do write('| ',UpperCase(slNames[i]),' ');
      writeln;

      // iterate rows
      while not dbQuery.EOF do
      begin
        // print cell by column
        for i := 0 to dbQuery.FieldCount-1 do
          // write('| ',dbQuery.Fields.Fields[i].AsString,' ');
          write('| ',dbQuery.FieldByName('name').AsString,' ');
        writeln;

        dbQuery.Next;
      end;

      // print summary
      writeln('Found ',dbQuery.RecordCount,' record(s).');
    end;

    dbQuery.Close;
  except
    on E: Exception do writeln(sqlDBError(E.Message));
  end;
end;

procedure showSchema(const sql: string);
var
  i,p: integer;
  t: string;
begin
  // check table name
  p := Pos(' ',sql);
  if p = 0 then writeln('ERROR: Schema requires a table name.');
  if p = 0 then exit;

  // check table existence
  sqlite3.GetTableNames(slNames,false);
  t := LowerCase(Copy(sql, p+1, Length(sql)-p));
  p := slNames.IndexOf(t);
  if p = -1 then writeln('ERROR: Table "',t,'" is not found.');
  if p = -1 then exit;

  // fetch table schema
  try
    ClrScr;
    writeln('> Schema of "',t,'"');

    // schema command
    dbQuery.SQL.Text := 'select name, sql from sqlite_master '+
                        'where type="table" and name="'+t+'"';
    dbQuery.Open;

    // print schema
    writeln(dbQuery.Fields.Fields[1].AsString);
    dbQuery.Close;
  except
    on E: Exception do writeln(sqlDBError(E.Message));
  end;
end;

procedure runQuery;
var
  p: integer;
  q,s: string;
begin
  if sqlite3.Connected then
  begin
    // query input
    writeln('_____');
    writeln('Enter SQL query:');
    write('» ');
    readln(q);
    q := Trim(q);

    // filter input to process custom commands
    if q <> '' then
    begin
      // read first word
      p := Pos(' ',q);
      if p = 0 then p := Length(q) else p := p-1;
      s := LowerCase(Copy(q,1,p));

      // run query
      if (s = 'quit') or (s = 'exit') then quit := true
      else if (s = 'clear') and (p = Length(q)) then ClrScr
      else if (s = 'tables') and (p = Length(q)) then showTables
      else if s = 'schema' then showSchema(q)
      else if s = 'select' then openQuery(q)
      else execQuery(q);
    end;
  end;
end;

//# main program
begin
  try
    if openDB('students.db') then
    begin
      showTables(false);
      repeat runQuery until quit;
    end;
  finally
    closeDB;
  end;
end.
