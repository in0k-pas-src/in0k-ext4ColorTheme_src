unit in0k_ext4ColorTheme_maker;

{$mode objfpc}{$H+}

interface

uses
  Graphics, LCLType,
  cs_consts, csCalc_Delta, //< математика "Цветов"
  in0k_ext4ColorTheme_itemsLair;

type

 tExt4ColorTheme_Colors=tColorsLAIR;

procedure Ext4ColorTheme_Colors__INI(out Colors:tExt4ColorTheme_Colors);
procedure Ext4ColorTheme_Colors__DEL(var Colors:tExt4ColorTheme_Colors);

procedure Ext4ColorTheme_Colors__addProduce(var Colors:tExt4ColorTheme_Colors; const RGB:tColor);

procedure Ext4ColorTheme_Colors__delSimilar(var Colors:tExt4ColorTheme_Colors; const RGB:tColor; const delta:single=cMinDeltaE*4);




procedure Ext4ColorTheme_Colors__addProduce_sysColors(var Colors:tExt4ColorTheme_Colors);
procedure Ext4ColorTheme_Colors__delSimilar_sysColors(var Colors:tExt4ColorTheme_Colors; const delta:single=cMinDeltaE*4);

procedure Ext4ColorTheme_Colors__sort(var Colors:tExt4ColorTheme_Colors; const RGB:tColor);

//< ОБХОД "коллекции цветов"
//< это видимо будет использоваться практически ИСКЛЮЧИТЕЛЬНО в рамках теста
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

// Добавить "цвет" в "каталог", если его там ещё НЕТ
procedure _add_unique_(var Colors:tExt4ColorTheme_Colors; const R,G,B:BYTE);
var c:tColor;
begin
    c:=RGBToColor(r,g,b);
    if ColorsLAIR_noExist(Colors,c)
    then ColorsLAIR_push(Colors,ColorsNode_new(c));
end;

// добавить набор цветов, основанный на компанентах
procedure _add_f8r8a_(var Colors:tExt4ColorTheme_Colors; const R,G,B:BYTE);
begin // forward & reverse & additional
    // сплошная комбинаторика, тут очень МАЛО науки
    //---------------------------------------------
    // прямой цвет
   _add_unique_(Colors,    r,    g,    b);
    // "обратные" цвета
   _add_unique_(Colors,$ff-r,$ff-g,$ff-b);
   {_add_unique_(Colors,$ff-r,$ff-g,    b);
   _add_unique_(Colors,$ff-r,    g,$ff-b);
   _add_unique_(Colors,    r,$ff-g,$ff-b);
   _add_unique_(Colors,$ff-r,    g,    b);
   _add_unique_(Colors,    r,$ff-g,    b);
   _add_unique_(Colors,    r,    g,$ff-b);}
    // "дополняющие" цвета
   _add_unique_(Colors,r-$ff,g-$ff,b-$ff);
   {_add_unique_(Colors,r-$ff,g-$ff,b    );
   _add_unique_(Colors,r-$ff,g    ,b-$ff);
   _add_unique_(Colors,r    ,g-$ff,b-$ff);
   _add_unique_(Colors,r-$ff,g    ,b    );
   _add_unique_(Colors,r    ,g-$ff,b    );
   _add_unique_(Colors,r    ,g    ,b-$ff);}
end;

procedure Ext4ColorTheme_Colors__addProduce(var Colors:tExt4ColorTheme_Colors; const RGB:tColor);
var r,g,b:BYTE;
begin   {$ifOpt D+}
        Assert( ColorToRGB(RGB)=RGB ,'Wrong parameter RGB. Use ColorToRGB before!');
        {$endIf}
    r:=Red  (RGB);
    g:=Green(RGB);
    b:=Blue (RGB);
    // перемешиваем компоненты, для генерации БОЛЬШЕГО числа цветов
    // сплошная комбинаторика, тут очень МАЛО науки
   _add_f8r8a_(Colors, r,g,b);
   _add_f8r8a_(Colors, r,b,g);
   _add_f8r8a_(Colors, b,r,g);
   _add_f8r8a_(Colors, g,r,b);
   _add_f8r8a_(Colors, g,b,r);
   _add_f8r8a_(Colors, b,g,r);
end;


procedure Ext4ColorTheme_Colors__delSimilar(var Colors:tExt4ColorTheme_Colors; const RGB:tColor; const delta:single=cMinDeltaE*4);
var tmpColors:tExt4ColorTheme_Colors;
    tmpNode  :pColorsNode;
begin   {$ifOpt D+}
        Assert( ColorToRGB(RGB)=RGB ,'Wrong parameter RGB. Use ColorToRGB before!');
        {$endIf}
    ColorsLAIR_INIT(tmpColors);
    while ColorsLAIR_Present(Colors) do begin
        tmpNode:=ColorsLAIR_pop(Colors);
        if delta<csCalc_Delta.delta(RGB,tmpNode^.color)
        then ColorsLAIR_push(tmpColors,tmpNode)
        else ColorsNode_DEL(tmpNode) //< СЛИШКОМ похоже, удаляем
    end;
    Colors:=tmpColors;
end;

procedure Ext4ColorTheme_Colors__sort(var Colors:tExt4ColorTheme_Colors; const RGB:tColor);
var tmpColors:tExt4ColorTheme_Colors;
    tmpNode  :pColorsNode;
begin   {$ifOpt D+}
        Assert( ColorToRGB(RGB)=RGB ,'Wrong parameter RGB. Use ColorToRGB before!');
        {$endIf}
    ColorsLAIR_INIT(tmpColors);
    while ColorsLAIR_Present(Colors) do begin
        tmpNode:=ColorsLAIR_pop(Colors);
        tmpNode^.delta:=csCalc_Delta.delta(RGB,tmpNode^.color);
        ColorsLAIR_push(tmpColors,tmpNode)
    end;
    Colors:=tmpColors;
end;

//------------------------------------------------------------------------------

const // количество Системных цветов, MAX_SYS_COLORS - последний из них
  cExt4ColorTheme_sysColorCount=MAX_SYS_COLORS+1;

procedure Ext4ColorTheme_Colors__addProduce_sysColors(var Colors:tExt4ColorTheme_Colors);
var i:TColorRef;
    c:TColor;
begin
    for i:=0 to cExt4ColorTheme_sysColorCount-1 do begin //< {1}
        c:=TColor(SYS_COLOR_BASE or i);
        Ext4ColorTheme_Colors__addProduce(Colors, ColorToRGB(c));
    end;
end;

procedure Ext4ColorTheme_Colors__delSimilar_sysColors(var Colors:tExt4ColorTheme_Colors; const delta:single=cMinDeltaE*4);
var i:TColorRef;
    c:TColor;
begin
    for i:=0 to cExt4ColorTheme_sysColorCount-1 do begin //< {1}
        c:=TColor(SYS_COLOR_BASE or i);
        Ext4ColorTheme_Colors__delSimilar(Colors, ColorToRGB(c),delta);
    end;
end;

//

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

