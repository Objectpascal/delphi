unit Main_form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,SyncObjs,
  BackgroundWorker;
const
 threads_count=10;
type
 Rec_FilePosition=record
     PStrat,PEnd:int64;
  end;
  Thread_job=class;
  TForm1 = class(TForm)
    E_sitesPath: TEdit;
    btn_Sites: TButton;
    btn_users: TButton;
    E_usersPath: TEdit;
    btn_MakeFile: TButton;
    ProgressBar1: TProgressBar;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Label1: TLabel;
    Memo2: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    label_isEnd: TLabel;
    btnSiteTest: TButton;
    btnUsertest: TButton;
    dlgSave1: TSaveDialog;
    procedure btn_SitesClick(Sender: TObject);
    procedure btn_usersClick(Sender: TObject);
    procedure btn_MakeFileClick(Sender: TObject);
    procedure btnSiteTestClick(Sender: TObject);
    procedure btnUsertestClick(Sender: TObject);
  private
  F_startTime,F_endTime:Cardinal;
  Thr_arr:array[1..threads_count] of Thread_job;
 // Paths_files:array[1..threads_count]of string;
 // Thr_arr:array  of Thread_job;
   Paths_files:array of string;
  jobs_done:integer;
  Task_count:integer;
    function getFileCount(file_path:string):int64;
    procedure MakeitOneFile();
    procedure add_path(path:string);
    procedure Add_thread(count:integer;var user_pos:Rec_FilePosition);
    { Private declarations }
  public

    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  end;


  Thread_job=class(TThread)
  private
    //FLock :TRTLCriticalSection;
      Flock:TCriticalSection;

    FPath_fileSite:string;
    Fpath_fileUser:string;
    FPos_user: Rec_FilePosition;
    Fpos_site: Rec_FilePosition;
    Fpath_save:string;

  protected
    constructor create(const sitePath,userPath:string;const pos_site,pos_user:Rec_FilePosition);
    procedure Thread_job();
    procedure Execute; override;

  public
    destructor Destroy; override;
    property Path_Site:string read FPath_fileSite write FPath_fileSite;
    property Path_user:string read Fpath_fileUser write Fpath_fileUser;
    property Pos_Site:Rec_FilePosition read Fpos_site write Fpos_site;
    property pos_user:Rec_FilePosition read FPos_user write Fpos_user;
    property Path_saveResult:string read Fpath_save write Fpath_save;
  end;


  therad_Main=class(TThread)
    private
      procedure Create_threads();

  protected
    procedure Execute; override;
    constructor create;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function createFile_(const path,const_str:string;const numberRepeat:Integer):Boolean;
var
  file_:TStringList;
  count:integer;
begin
  Result:=False;
  file_:=TStringList.Create;
  try
    try
    if FileExists(path) then
      DeleteFile(path);
    for count := 1 to numberRepeat do
        begin
          file_.Add(Format('%s%d',[const_str,count]));
        end;


     file_.SaveToFile(path);
     result:=True;
    except
    result:=False;

    end;
  finally
    FreeAndNil(file_);
  end;

end;
procedure Append_ToFile(const pathFile:string;const list:TStringList);
var
  file_text:TStringList;
  f:TextFile;
begin
  file_text:=TStringList.Create;
  try
    if not FileExists(pathFile) then
      begin

       AssignFile(f,pathFile);
       Rewrite(f);
       CloseFile(f);

      end;


   if FileExists(pathFile) then
    begin
      file_text.LoadFromFile(pathFile);
      if file_text.Count>1 then
        file_text.Delete(file_text.Count-1);
      file_text.add(list.Text);
      file_text.SaveToFile(pathFile);
    end;



  finally
    FreeAndNil(file_text);
  end;

end;


procedure TForm1.add_path(path: string);
begin
  SetLength(Paths_files,length(Paths_files)+1);
  Paths_files[high(Paths_files)]:=path;
end;

procedure TForm1.Add_thread(count:integer;var user_pos: Rec_FilePosition);
var
rec_site:Rec_FilePosition;
begin
      with rec_site do
          begin
            PStrat:=0;
            PEnd:=getFileCount(E_sitesPath.Text)-1;
          end;
      //  Memo2.Lines.Add(Format('start:%d | end:%d ',[sits_pos.PStrat,sits_pos.PEnd]));
        Thr_arr[count]:=Thread_job.create(E_sitesPath.Text,E_usersPath.Text,rec_site,user_pos);
        Thr_arr[count].Path_saveResult:=ExtractFilePath(Application.ExeName)+'result'+IntToStr(count)+'.txt';
        //Thr_arr[count].Resume;
        add_path(ExtractFilePath(Application.ExeName)+'result'+IntToStr(count)+'.txt');
        Inc(Task_count,1);
        //Paths_files[count]:= ExtractFilePath(Application.ExeName)+'result'+IntToStr(count)+'.txt';

end;

procedure TForm1.btnSiteTestClick(Sender: TObject);
var
numberSite:integer;
sitePath:string;
begin
try
  if dlgSave1.Execute then
    begin
    if Pos('.txt',dlgSave1.FileName)<=0 then
      sitePath:=dlgSave1.FileName+'.txt'
    else
      sitePath:=dlgSave1.FileName;
    end;
 numberSite:=StrToInt(InputBox('site file','number site:','1'));
 if createFile_(sitePath,'site',numberSite) then
  ShowMessage('file was created..')
  else
  ShowMessage('file not created!!');
except
  ShowMessage('plz entre integer number..');

end;
end;

procedure TForm1.btnUsertestClick(Sender: TObject);
var
numberuser:integer;
user_path:string;
begin
try
  if dlgSave1.Execute then
    begin
    if Pos('.txt',dlgSave1.FileName)<=0 then
      user_path:=dlgSave1.FileName+'.txt'
    else
      user_path:=dlgSave1.FileName;
    end;
 numberuser:=StrToInt(InputBox('user file','number User:','1'));
 if createFile_(user_path,'user',numberuser) then
  ShowMessage('file was created..')
  else
  ShowMessage('file not created!!');
except
  ShowMessage('plz entre integer number..');

end;
end;

procedure TForm1.btn_MakeFileClick(Sender: TObject);
var

  rec_site,rec_user:Rec_FilePosition;
  count:integer;
  max_countFiles:int64;
  lines_job,lines_mod:int64;
  index_start,index_end:int64;
begin
      Label3.Visible:=False;
      label_isEnd.Visible:=False;
      F_startTime:=GetTickCount;//startTime
      Memo1.Lines.Clear;
      memo2.Lines.Clear;
      SetLength(Paths_files,0);
      Task_count:=0;
      jobs_done:=0;
      max_countFiles:=getFileCount(E_usersPath.Text);
      lines_job:=max_countFiles div threads_count;
      lines_mod:=max_countFiles mod threads_count;
      index_start:=0;
      if lines_job>=2 then
        index_end:=lines_job
      else
        index_end:=max_countFiles;


     for count := Low(Thr_arr) to High(Thr_arr) do
      begin
      if (index_end+lines_mod)>=max_countFiles then
        begin
              index_end:=max_countFiles;
            with rec_user do
              begin
               PStrat:=index_start;
               PEnd:=index_end-1;
              end;
              Add_thread(count,rec_user);

              Memo2.Lines.Add(Format(' [thread%d] getJob-> Pstart:%d | pEnd:%d ',[count,rec_user.PStrat,rec_user.PEnd]));

              break;
        end;



      with rec_user do
        begin
          PStrat:=index_start;
          PEnd:=index_end-1;
        end;

      Memo2.Lines.Add(Format(' [thread%d] getJob-> Pstart:%d | pEnd:%d ',[count,rec_user.PStrat,rec_user.PEnd]));
      Add_thread(count,rec_user);

      inc(index_start,lines_job);
      inc(index_end,lines_job);
      end;


end;

procedure TForm1.btn_SitesClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      E_sitesPath.Text:=OpenDialog1.FileName;
    end;
end;

procedure TForm1.btn_usersClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      E_usersPath.Text:=OpenDialog1.FileName;
    end;
end;

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited;

  jobs_done:=0;
  F_startTime:=0;
  F_endTime:=0;
end;

destructor TForm1.Destroy;
begin
  //SetLength(Thr_arr,0);
  SetLength(Paths_files,0);
  inherited;
end;

function TForm1.getFileCount(file_path: string): int64;
var
  file_:TStringList;
begin
  result:=0;
  file_:=TStringList.Create;
  try
     file_.LoadFromFile(file_path);
     result:=file_.Count;
  finally
    FreeAndNil(file_);
  end;

end;

procedure TForm1.MakeitOneFile;
var
  count:integer;
  result_path:string;
  File_string:TStringList;
  file_result:TStringList;
  Time:TTimeStamp;
begin
  File_string:=TStringList.Create;
  //file_result:=TStringList.Create;
try
   result_path:=ExtractFilePath(Application.ExeName)+'result.txt';
   if FileExists(result_path) then
    DeleteFile(result_path);

  for count := Low(Paths_files) to High(Paths_files) do
  begin
    File_string.LoadFromFile(Paths_files[count]);
     //if file_result.Count>1 then

     //    file_result.Delete(file_result.Count-1);

   // file_result.add(File_string.Text);
   Append_ToFile(result_path,File_string);

    DeleteFile(Paths_files[count]);
  end;
 //file_result.SaveToFile(result_path);
 F_endTime:=GetTickCount;
 Label3.Visible:=True;
 Label3.Caption:=Format('Take %0.4f sec',[(F_endTime-F_startTime)/1000]);

 ShowMessage('File is Created on the Same path....ok!');

finally
  FreeAndNil(File_string);
 // FreeAndNil(file_result);
end;

end;

{ Thread_job }

constructor Thread_job.create(const sitePath,userPath:string;const pos_site,pos_user:Rec_FilePosition);
begin
  inherited create;
  //InitializeCriticalSection(FLock);
   FLock := TCriticalSection.Create;
  self.Priority:=tpNormal;
  self.FreeOnTerminate:=True;
  self.Path_Site:=sitePath;
  self.Path_user:=userPath;
  self.pos_site:=pos_site;
  self.pos_user:=pos_user;

end;

destructor Thread_job.Destroy;
begin
  //DeleteCriticalSection(FLock);
  FreeAndNil(Flock);
  inherited;
end;

procedure Thread_job.Execute;
begin
  inherited;

  while not Terminated do
    begin
      Synchronize(Thread_job);
      break;
    end;
end;

procedure Thread_job.Thread_job;
var
  File_site:TStringList;
  File_user:TStringList;
  File_result:TStringList;
  index_site,index_user:int64;

begin
//EnterCriticalSection(FLock);
  Flock.Acquire;
  File_site:=TStringList.Create;
  File_user:=TStringList.Create;
  File_result:=TStringList.Create;
  try
    File_site.LoadFromFile(Path_Site);
    File_user.LoadFromFile(Path_user);
      for index_user := pos_user.PStrat to pos_user.PEnd do
        begin
            for index_site := Pos_Site.PStrat to Pos_Site.PEnd do
              begin
                 File_result.Add(format('%s %s %s',[File_site[index_site],File_user[index_user],File_user[index_user]]));
              end;
        end;
    File_result.SaveToFile(Path_saveResult);
    form1.Memo1.Lines.Add(ExtractFileName(Path_saveResult));
    inc(form1.jobs_done,1);
    if form1.jobs_done=form1.Task_count then
      begin
      //ShowMessage('all tasks done.');
      form1.label_isEnd.Visible:=True;
      form1.label_isEnd.Caption:='all tasks done.';
      form1.MakeitOneFile();
      end;
  finally
    FreeAndNil(File_site);
    FreeAndNil(File_user);
    FreeAndNil(File_result);
    //LeaveCriticalSection(FLock);
    Flock.Release;
  end;

end;

{ therad_Main }

constructor therad_Main.create;
begin
inherited;
Self.Priority:=tpNormal;
self.FreeOnTerminate:=True;
end;

procedure therad_Main.Create_threads;
var

  rec_site,rec_user:Rec_FilePosition;
  count:integer;
  max_countFiles:int64;
  lines_job,lines_mod:int64;
  index_start,index_end:int64;
begin
with Form1 do
begin
      SetLength(Paths_files,0);
      Memo1.Lines.Clear;
      memo2.Lines.Clear;
      Task_count:=0;
      jobs_done:=0;
      max_countFiles:=getFileCount(E_sitesPath.Text);
      lines_job:=max_countFiles div threads_count;
      lines_mod:=max_countFiles mod threads_count;
      index_start:=0;
      if lines_job>=2 then
        index_end:=lines_job
      else
        index_end:=max_countFiles;


     for count := Low(Thr_arr) to High(Thr_arr) do
      begin
      if (index_end+lines_mod)>=max_countFiles then
        begin
              index_end:=max_countFiles;
            with rec_site do
              begin
               PStrat:=index_start;
               PEnd:=index_end-1;
              end;
              Add_thread(count,rec_site);

              Memo2.Lines.Add(Format(' [thread%d] getJob-> Pstart:%d | pEnd:%d ',[count,rec_site.PStrat,rec_site.PEnd]));

              break;
        end;



      with rec_site do
        begin
          PStrat:=index_start;
          PEnd:=index_end-1;
        end;

      Memo2.Lines.Add(Format('Pstart:%d | pEnd:%d ',[rec_site.PStrat,rec_site.PEnd]));
      Add_thread(count,rec_site);

      inc(index_start,lines_job);
      inc(index_end,lines_job);
      end;


end;
end;


procedure therad_Main.Execute;
begin
  inherited;
  while not Terminated do
    begin
      Synchronize(Create_threads);
      break;
    end;
end;

end.
