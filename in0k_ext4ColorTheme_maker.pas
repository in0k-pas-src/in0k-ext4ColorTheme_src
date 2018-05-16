unit in0k_ext4ColorTheme_maker;

{$mode objfpc}{$H+}

interface

uses
  Graphics,
  in0k_ext4ColorTheme_itemsLair;

type

 tExt4ColorTheme_Colors=tColorsLAIR;



procedure Ext4ColorTheme_Colors__INI(out Colors:tExt4ColorTheme_Colors);
procedure Ext4ColorTheme_Colors__DEL(var Colors:tExt4ColorTheme_Colors);

procedure Ext4ColorTheme_Colors__ADD(var Colors:tExt4ColorTheme_Colors; const RGB:tColor);

function  Ext4ColorTheme_Colors__enumFirst(const Colors:tExt4ColorTheme_Colors):pointer;
function  Ext4ColorTheme_Colors__enumNext (const enNode:pointer):pointer;
function  Ext4ColorTheme_Colors__enumColor(const enNode:pointer):tColor;
function  Ext4ColorTheme_Colors__enumDelta(const enNode:pointer):Single;

implementation

procedure Ext4ColorTheme_Colors__INI(out Colors:tExt4ColorTheme_Colors);
begin
    ColorsLAIR_INIT(Colors);
end;

procedure Ext4ColorTheme_Colors__DEL(var Colors:tExt4ColorTheme_Colors);
begin
    ColorsLAIR_CLEAR(Colors);
end;

//------------------------------------------------------------------------------

procedure _add_(var Colors:tExt4ColorTheme_Colors; const R,G,B:BYTE);
var c:tColor;
begin
    c:=RGBToColor(r,g,b);
    if ColorsLAIR_noExist(Colors,c)
    then ColorsLAIR_push(Colors,ColorsNode_new(c));
end;

procedure _add_f8r8a_(var Colors:tExt4ColorTheme_Colors; const R,G,B:BYTE);
begin // forward & reverse & additional
   _add_(Colors,    r,    g,    b);
    //
   _add_(Colors,$ff-r,$ff-g,$ff-b);
   {_add_(Colors,$ff-r,$ff-g,    b);
   _add_(Colors,$ff-r,    g,$ff-b);
   _add_(Colors,    r,$ff-g,$ff-b);
   _add_(Colors,$ff-r,    g,    b);
   _add_(Colors,    r,$ff-g,    b);
   _add_(Colors,    r,    g,$ff-b);}
    //
   _add_(Colors,r-$ff,g-$ff,b-$ff);
   {_add_(Colors,r-$ff,g-$ff,b    );
   _add_(Colors,r-$ff,g    ,b-$ff);
   _add_(Colors,r    ,g-$ff,b-$ff);
   _add_(Colors,r-$ff,g    ,b    );
   _add_(Colors,r    ,g-$ff,b    );
   _add_(Colors,r    ,g    ,b-$ff);}
end;

procedure Ext4ColorTheme_Colors__ADD(var Colors:tExt4ColorTheme_Colors; const RGB:tColor);
var r,g,b:BYTE;
begin   {$ifOpt D+}
        Assert( ColorToRGB(RGB)=RGB ,'Wrong parameter RGB. Use ColorToRGB before!');
        {$endIf}
    r:=Red  (RGB);
    g:=Green(RGB);
    b:=Blue (RGB);
    //---
   _add_f8r8a_(Colors, r,g,b);
   _add_f8r8a_(Colors, r,b,g);
   _add_f8r8a_(Colors, b,r,g);
   _add_f8r8a_(Colors, g,r,b);
   _add_f8r8a_(Colors, g,b,r);
   _add_f8r8a_(Colors, b,g,r);
end;

//------------------------------------------------------------------------------

function Ext4ColorTheme_Colors__enumFirst(const Colors:tExt4ColorTheme_Colors):pointer;
begin
    result:=ColorsLAIR_first(Colors);
end;

function Ext4ColorTheme_Colors__enumNext(const enNode:pointer):pointer;
begin
    result:=ColorsLAIR_next(pColorsNode(enNode));
end;

function Ext4ColorTheme_Colors__enumColor(const enNode:pointer):tColor;
begin
    result:=pColorsNode(enNode)^.color;
end;

function Ext4ColorTheme_Colors__enumDelta(const enNode:pointer):Single;
begin
    result:=pColorsNode(enNode)^.delta;
end;



end.

