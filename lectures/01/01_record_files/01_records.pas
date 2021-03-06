program record_example;

uses crt, sysutils;

type 
    TStudent = Record
        name: string[20];
        surname: string[30];
        age: integer;
        gender: char;
    end;

var 
    f: file of TStudent;
    choice: char;

procedure openFile(fileName: string);
var
    code: integer;
begin
    assign(f, fileName);
    {$I-}
        reset(f);
    {$I+}
    code := IOResult;

    if code <> 0 then
    begin
        {$I-}
            rewrite(f);
        {$I+}
        code := IOResult;
        if code <> 0 then
        begin
            writeln('Open file error');
            halt;
        end;
    end;
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

function inputSurname(): string;
var surname: string;
begin
    write('Фамилия: ');
    readln(surname);
    
    inputSurname := surname;
end;

// ========================= CREATE =======================
procedure saveRecord(n: integer; buffer: TStudent);
begin
    seek(f, n - 1);
    write(f, buffer);
end;

procedure addRecord;
var
    student: TStudent;
begin
    clrscr;
    student := inputStudentData;
    
    saveRecord(fileSize(f) + 1, student);
end;


// ========================= READ  =======================
procedure readRecordByNumber;
var
    n: integer;
    student: TStudent;
begin
    clrscr;
    n := inputRecordNumber();
    clrscr;

    seek(f, n - 1);
    read(f, student);
    
    writeln('Запись: ' + intToStr(n));
    writeln('Имя: ', student.name);
    writeln('Фамилия: ', student.surname);
    writeln('Пол: ', student.gender);
    writeln('Возраст: ', student.age);

    writeln();
    writeln();
    write('<Enter> - вернуться в главное меню');
    readln();
end;

procedure readRecordBySurname;
var
    surname: string;
    isFound: boolean;
    student: TStudent;
begin
    clrscr;
    surname := inputSurname();
    clrscr;

    seek(f, 0);
    isFound := false;
    while not eof(f) do
    begin
        read(f, student);
        if (student.surname = surname) then
        begin
            isFound := true;
            break;
        end;
    end;

    if isFound then
    begin
        writeln('Имя: ', student.name);
        writeln('Фамилия: ', student.surname);
        writeln('Пол: ', student.gender);
        writeln('Возраст: ', student.age);
    end
    else
        writeln('Фамилия ', surname, ' в списке не найдена');

    writeln();
    writeln();
    write('<Enter> - вернуться в главное меню');
    readln();
end;

procedure listRecords;
var
    student: TStudent;
    countRecords, recordNumber: integer;
begin
    clrscr;
    
    countRecords := fileSize(f);
    writeln('Всего записей: ', countRecords);

    seek(f, 0);
    recordNumber := 0;
    while not eof(f) do
    begin
        read(f, student);
        inc(recordNumber);

        writeln('--------------------- ', recordNumber, ' --');
        writeln('Имя: ', student.name);
        writeln('Фамилия: ', student.surname);
        writeln('Пол: ', student.gender);
        writeln('Возраст: ', student.age);
    end;

    writeln();
    write('<Enter> - вернуться в главное меню');
    readln();
end;


// ========================= UPDATE  =======================
procedure updateRecordBySurname;
var
    student: TStudent;
    surname: string;
    n: integer;
    isFound: boolean;
begin
    clrscr;
    surname := inputSurname();
    clrscr;

    seek(f, 0);
    n := 0;
    isFound := false;
    while not eof(f) do
    begin
        read(f, student);
        inc(n);
        if (student.surname = surname) then
        begin
            isFound := true;
            break;
        end;
    end;

    if isFound then
    begin
        writeln('Запись: ' + intToStr(n));
        writeln('Имя: ', student.name);
        writeln('Фамилия: ', student.surname);
        writeln('Пол: ', student.gender);
        writeln('Возраст: ', student.age);
        writeln('-------------------------------------');

        student := inputStudentData;

        saveRecord(n, student);
        writeln('-------------------------------------');
        writeln('Запись сохранена в файле');
    end
    else
        writeln('Фамилия ', surname, ' в списке не найдена');

    write('<Enter> - вернуться в главное меню');
    readln();
end;


// ========================= DELETE  =======================
procedure deleteRecordBySurname;
var
    student: TStudent;
    tempFile: file of TStudent;
    surname: string;
begin
    clrscr;
    surname := inputSurname();
    clrscr;

    assign(tempFile, 'tmp.dat');
    rewrite(tempFile);

    seek(f, 0);

    while not eof(f) do
    begin
        read(f, student);

        if student.surname <> surname then
        begin
            write(tempFile, student);
        end;
    end;

    close(tempFile);
    close(f);
    erase(f);
    rename(tempFile, 'students.dat');

    openFile('students.dat');
end;

// ========================= main program  =======================
begin
    openFile('students.dat');

    repeat
        clrscr;
        writeln('1. Добавить запись в файл (Create)');
        writeln();
        writeln('2. Найти запись по номеру (Read)');
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
            '2': readRecordByNumber;
            '3': readRecordBySurname;
            '4': listRecords;
            '5': updateRecordBySurname;
            '6': deleteRecordBySurname;
        end;

        writeln('');
        writeln();
    until (choice = '7');

end.
