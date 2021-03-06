program sqlite_example;

{$MODE OBJFPC}{$H+}{$J-}

uses
  crt, Classes, SysUtils, SQLDB, SQLite3Conn;
  
type 
    TStudent = Record
        name: string[20];
        surname: string[30];
        age: integer;
        gender: char;
    end;

var
    sqlite3: TSQLite3Connection;
    dbTrans: TSQLTransaction;
    dbQuery: TSQLQuery;
    slNames: TStringList;
    f: file of TStudent;
    choice: char;

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
      writeln(E.Message);
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

function inputStudentData(): TStudent;
var
    student: TStudent;
begin
    write('Имя: ');
    readln(student.name);
    write('Фамилия: ');
    readln(student.surname);
    write('Пол: ');
    readln(student.gender);
    write('Возраст: ');
    readln(student.age);

    inputStudentData := student;
end;

function inputRecordNumber(): integer;
var n, countRecords: integer;
begin
    countRecords := fileSize(f);

    write('Номер записи (1...' + intToStr(countRecords) + '): ');
    repeat
        readln(n);
    until (n >= 1) and (n <= countRecords);
    
    inputRecordNumber := n;
end;

function inputSurname: string;
var surname: string;
begin
    write('Фамилия: ');
    readln(surname);
    
    inputSurname := surname;
end;

// ========================= CREATE =======================
procedure execQuery(sql: string);
begin
    try
        dbQuery.SQL.Text := sql;
        dbTrans.Active := true;
        dbQuery.ExecSQL;

        dbTrans.Commit;
    except
        on E: Exception do
        begin
          dbTrans.Rollback;
          writeln(E.Message);
        end;
    end;
end;

procedure addRecord;
var
    student: TStudent;
    sql: string;
begin
    clrscr;
    writeln('НОВАЯ ЗАПИСЬ:');
    student := inputStudentData;

    sql := 'INSERT INTO students (name, surname, age, gender) VALUES (';
    sql := sql +'"'+student.name+'", "'+student.surname+'", '+IntToStr(student.age)+', "'+student.gender+'")';

    execQuery(sql);
end;


// ========================= READ  =======================
procedure printRecords(sql: string);
var
    recordNumber: integer;
begin
    clrscr;
    
    try
        dbQuery.SQL.Text := sql;
        dbQuery.Open;

        if dbQuery.Active then
        begin
            clrscr;

            writeln('Всего записей: ', dbQuery.RecordCount);

            recordNumber := 0;
            while not dbQuery.EOF do
            begin
                inc(recordNumber);

                writeln('--------------------- ', recordNumber, ' --');
                writeln('Имя: ', dbQuery.FieldByName('name').AsString);
                writeln('Фамилия: ', dbQuery.FieldByName('surname').AsString);
                writeln('Пол: ', dbQuery.FieldByName('gender').AsString);
                writeln('Возраст: ', dbQuery.FieldByName('age').AsInteger);

                dbQuery.Next;
            end;
        end;

        dbQuery.Close;
    except
        on E: Exception do writeln(E.Message);
    end;

    writeln();
    write('<Enter> - вернуться в главное меню');
    readln();
end;

procedure readRecordBySurname;
var surname: string;
begin
    clrscr;
    writeln('ПОИСК ЗАПИСИ');
    surname := inputSurname;

    printRecords('SELECT * FROM students WHERE surname="' + surname + '"');
end;

procedure listRecords;
begin
    printRecords('SELECT * FROM students ORDER BY surname');
end;


// ========================= UPDATE  =======================
procedure updateRecordBySurname;
var
    student: TStudent;
    surname: string;
    sql: string;
begin
    clrscr;
    writeln('ИЗМЕНЕНИЕ ЗАПИСИ');
    surname := inputSurname;
    writeln('Новые данные:');
    student := inputStudentData;


    sql := 'UPDATE students SET';
    sql := sql + ' name="'+student.name+'"';
    sql := sql + ', surname="'+student.surname+'"';
    sql := sql + ', age='+IntToStr(student.age);
    sql := sql + ', gender="'+student.gender+'"';
    sql := sql + ' WHERE surname="' + surname + '"';
    
    execQuery(sql);

    write('<Enter> - вернуться в главное меню');
    readln();
end;


// ========================= DELETE  =======================
procedure deleteRecordBySurname;
var
    surname: string;
    sql: string;
begin
    clrscr;
    writeln('УДАЛЕНИЕ ЗАПИСИ');
    surname := inputSurname;

    sql := 'DELETE FROM students WHERE surname="' + surname + '"';
    execQuery(sql);
end;

// ========================= main program  =======================
begin
    openDB('students.db');

    repeat
        clrscr;
        writeln('1. Добавить запись в файл (Create)');
        writeln();
        writeln('3. Найти запись по фамилии (Read)');
        writeln('4. Показать все записи (Read)');
        writeln();
        writeln('5. Обновить запись по фамилии (Update)');
        writeln();
        writeln('6. Удалить запись по фамилии (Delete)');
        writeln('');
        writeln('7. Выход');

        writeln('===============================');
        writeln();
        write('Ваш выбор: ');
        readln(choice);

        choice := upcase(choice);
        case choice of 
            '1': addRecord;
            '3': readRecordBySurname;
            '4': listRecords;
            '5': updateRecordBySurname;
            '6': deleteRecordBySurname;
        end;

        writeln('');
        writeln();
    until (choice = '7');

end.
