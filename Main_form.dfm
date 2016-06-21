object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'thread test'
  ClientHeight = 313
  ClientWidth = 718
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 5
    Top = 175
    Width = 86
    Height = 19
    Caption = 'File created:'
  end
  object Label2: TLabel
    Left = 333
    Top = 179
    Width = 86
    Height = 19
    Caption = 'threads job:'
  end
  object Label3: TLabel
    Left = 498
    Top = 136
    Width = 77
    Height = 33
    Caption = 'Label3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object label_isEnd: TLabel
    Left = 498
    Top = 101
    Width = 117
    Height = 29
    Caption = 'label_isEnd'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object E_sitesPath: TEdit
    Left = 16
    Top = 8
    Width = 476
    Height = 27
    ReadOnly = True
    TabOrder = 0
  end
  object btn_Sites: TButton
    Left = 498
    Top = 8
    Width = 100
    Height = 25
    Caption = 'Sites'
    TabOrder = 1
    OnClick = btn_SitesClick
  end
  object btn_users: TButton
    Left = 498
    Top = 65
    Width = 100
    Height = 25
    Caption = 'Users'
    TabOrder = 2
    OnClick = btn_usersClick
  end
  object E_usersPath: TEdit
    Left = 16
    Top = 64
    Width = 476
    Height = 27
    ReadOnly = True
    TabOrder = 3
  end
  object btn_MakeFile: TButton
    Left = 16
    Top = 96
    Width = 476
    Height = 44
    Caption = 'Make File'
    TabOrder = 4
    OnClick = btn_MakeFileClick
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 147
    Width = 476
    Height = 22
    TabOrder = 5
  end
  object Memo1: TMemo
    Left = 5
    Top = 200
    Width = 321
    Height = 108
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object Memo2: TMemo
    Left = 332
    Top = 200
    Width = 378
    Height = 105
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object btnSiteTest: TButton
    Left = 618
    Top = 8
    Width = 92
    Height = 25
    Caption = 'Site test'
    TabOrder = 8
    OnClick = btnSiteTestClick
  end
  object btnUsertest: TButton
    Left = 618
    Top = 65
    Width = 92
    Height = 25
    Caption = 'user test'
    TabOrder = 9
    OnClick = btnUsertestClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'text file|*.txt'
    Left = 544
    Top = 152
  end
  object dlgSave1: TSaveDialog
    Filter = 'text|*.txt'
    Left = 656
    Top = 104
  end
end
