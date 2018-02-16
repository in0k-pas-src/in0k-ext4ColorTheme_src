unit in0k_ext4ColorTheme;

{$mode objfpc}{$H+}

interface

uses Graphics,
    Classes, SysUtils;



function in0k_ext4ColorTheme_clHotLight:tColor; {$ifOpt D-} inline; {$endIf}
function in0k_ext4ColorTheme_asGreen   :tColor; {$ifOpt D-} inline; {$endIf}

function color_Red:tColor;


                                  //Green
                                  //Red

implementation

const cStartColor=clHotLight;//clHighlight;

// clHotLight  -- Color for a hyperlink or hot-tracked item. The associated background color is COLOR_WINDOW.
function in0k_ext4ColorTheme_clHotLight:tColor;
begin
    result:=clHotLight;
end;


// clHighlight -- Item(s) selected in a control. The associated foreground color is COLOR_HIGHLIGHTTEXT.



function in0k_ext4ColorTheme_asGreen:tColor;
var R,G,B:byte;
begin
    RedGreenBlue(ColorToRGB(cStartColor), R,G,B);
    if (G<R)and(B<R) then begin
                         //r,g,b
        result:=RGBToColor(B,R,G);
    end
   else
    if (R<G)and(B<G) then begin
        result:=RGBToColor(R,G,B);
    end
   else begin
        result:=RGBToColor(G,B,R);
    end;
end;


function color_Red:tColor;
var R,G,B:byte;
begin
    RedGreenBlue(ColorToRGB(cStartColor), R,G,B);
    if (G<R)and(B<R) then begin
        result:=RGBToColor(R,G,B);
    end
   else
    if (R<G)and(B<G) then begin
        result:=RGBToColor(G,B,R);
    end
   else begin
        result:=RGBToColor(B,R,G);
    end;
end;

end.

