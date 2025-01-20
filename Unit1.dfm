object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 
    'UTILITY - Identifies the Firebird Database (compatible with vers' +
    'ions 1.x - 5.x)'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 70
    Width = 54
    Height = 15
    Caption = 'Database :'
  end
  object Label2: TLabel
    Left = 16
    Top = 127
    Width = 314
    Height = 15
    Caption = 'Firebird server version / path that database is connected to :'
  end
  object lblFBserver: TLabel
    Left = 16
    Top = 148
    Width = 63
    Height = 15
    Caption = 'lblFBserver'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 202
    Width = 120
    Height = 15
    Caption = 'ODS database version :'
  end
  object lbODS: TLabel
    Left = 16
    Top = 223
    Width = 38
    Height = 15
    Caption = 'lblODS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 16
    Top = 257
    Width = 137
    Height = 15
    Caption = 'Firebird database version :'
  end
  object lbFBv: TLabel
    Left = 16
    Top = 278
    Width = 34
    Height = 15
    Caption = 'lblFBv'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPorta: TLabel
    Left = 488
    Top = 191
    Width = 37
    Height = 15
    Caption = 'lblPort'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblPS: TLabel
    Left = 488
    Top = 223
    Width = 27
    Height = 15
    Caption = 'lblPS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 488
    Top = 156
    Width = 100
    Height = 15
    Caption = 'other information :'
  end
  object lblDialetoSQL: TLabel
    Left = 488
    Top = 255
    Width = 75
    Height = 15
    Caption = 'lblDialetoSQL'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label6: TLabel
    Left = 16
    Top = 8
    Width = 130
    Height = 15
    Caption = 'Select Firebird database :'
  end
  object Label7: TLabel
    Left = 0
    Top = 426
    Width = 624
    Height = 15
    Align = alBottom
    Caption = 'Built with Delphi 12.1, FireDAC components, version 0.1 (2025)'
    ExplicitWidth = 327
  end
  object lblFBPath: TLabel
    Left = 16
    Top = 169
    Width = 52
    Height = 15
    Caption = 'lblFBPath'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 16
    Top = 29
    Width = 145
    Height = 25
    Caption = 'Browse'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtBD: TEdit
    Left = 16
    Top = 91
    Width = 593
    Height = 23
    ReadOnly = True
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 16
    Top = 311
    Width = 593
    Height = 109
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Left = 568
    Top = 8
  end
  object FDConnection1: TFDConnection
    Left = 216
    Top = 8
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 456
    Top = 8
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 328
    Top = 8
  end
  object FDIBInfo1: TFDIBInfo
    Left = 328
    Top = 200
  end
end
