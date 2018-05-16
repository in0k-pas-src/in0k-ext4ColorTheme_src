unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  in0k_ext4ColorTheme_maker, Classes, SysUtils, FileUtil, Forms, Controls,
  Graphics, Dialogs, ColorBox, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ColorListBox1: TColorListBox;
    procedure Button1Click(Sender: TObject);
    procedure ColorListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    colors:tExt4ColorTheme_Colors;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender:TObject);
begin
    Ext4ColorTheme_Colors__INI(colors);
    //
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clHighlight));
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clHighlightedText));
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clHighlightText));

    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clHotLight));


    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clBackground              ));
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clActiveCaption           ));
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clInactiveCaption         ));
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clMenu                    ));//: Ne));    ));
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clWindow                  ));//: NewColorName := rsWindowColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clWindowFrame             ));//: NewColorName := rsWindowFrameColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clMenuText                ));//: NewColorName := rsMenuTextColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clWindowText              ));//: NewColorName := rsWindowTextColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clCaptionText             ));//: NewColorName := rsCaptionTextColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clActiveBorder            ));//: NewColorName := rsActiveBorderColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clInactiveBorder          ));//: NewColorName := rsInactiveBorderColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clAppWorkspace            ));//: NewColorName := rsAppWorkspaceColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clHighlight               ));//: NewColorName := rsHighlightColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clHighlightText           ));//: NewColorName := rsHighlightTextColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clBtnFace                 ));//: NewColorName := rsBtnFaceColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clBtnShadow               ));//: NewColorName := rsBtnShadowColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clGrayText                ));//: NewColorName := rsGrayTextColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clBtnText                 ));//: NewColorName := rsBtnTextColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clInactiveCaptionText     ));//: NewColorName := rsInactiveCaptionText;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clBtnHighlight            ));//: NewColorName := rsBtnHighlightColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(cl3DDkShadow              ));//: NewColorName := rs3DDkShadowColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(cl3DLight                 ));//: NewColorName := rs3DLightColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clInfoText                ));//: NewColorName := rsInfoTextColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clInfoBk                  ));//: NewColorName := rsInfoBkColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clHotLight                ));//: NewColorName := rsHotLightColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clGradientActiveCaption   ));//: NewColorName := rsGradientActiveCaptionColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clGradientInactiveCaption ));//: NewColorName := rsGradientInactiveCaptionColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clMenuHighlight           ));//: NewColorName := rsMenuHighlightColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clMenuBar                 ));//: NewColorName := rsMenuBarColorCaption;
    Ext4ColorTheme_Colors__ADD(colors,ColorToRGB(clForm                    ));//: NewColorName := rsFormColorCaption;



   // Screen.f;
end;

procedure TForm1.ColorListBox1Click(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var tmp:pointer;
      c:tColor;
begin
    ColorListBox1.Clear;

    tmp:=Ext4ColorTheme_Colors__enumFirst(colors);
    while Assigned(tmp) do begin
        c:=Ext4ColorTheme_Colors__enumColor(tmp);
        ColorListBox1.Items.AddObject('#'+IntToHex(c,6)+' '+FloatToStr(Ext4ColorTheme_Colors__enumDelta(tmp)),tObject(c));
        tmp:=Ext4ColorTheme_Colors__enumNext(tmp);
    end;

    Caption:=inttostr(ColorListBox1.Items.Count);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    Ext4ColorTheme_Colors__DEL(colors);
end;


end.

