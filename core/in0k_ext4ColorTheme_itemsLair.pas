unit in0k_ext4ColorTheme_itemsLair;

{$mode objfpc}{$H+}

interface

uses
  Graphics;

type

 pColorsNode=^rColorsNode;
 rColorsNode=record
    next :pColorsNode;
    color:TColor;      //< сам цвет
    delta:single;      //< растояние от базового
  end;

function  ColorsNode_new(const aColor:tColor):pColorsNode;
procedure ColorsNode_DEL(const node:pColorsNode);

type

 tColorsLAIR=pColorsNode;

function  ColorsLAIR_Present(const LAIR:tColorsLAIR):boolean;
function  ColorsLAIR_isEMPTY(const LAIR:tColorsLAIR):boolean;

procedure ColorsLAIR_INIT (out LAIR:tColorsLAIR);
procedure ColorsLAIR_CLEAR(var LAIR:tColorsLAIR);

procedure ColorsLAIR_push (var LAIR:tColorsLAIR; const node:pColorsNode);
function  ColorsLAIR_pop  (var LAIR:tColorsLAIR):pColorsNode;

function  ColorsLAIR_first(const LAIR:tColorsLAIR):pColorsNode;
function  ColorsLAIR_next (const node:pColorsNode):pColorsNode;

function  ColorsLAIR_present(const LAIR:tColorsLAIR; const color:tColor):boolean;
function  ColorsLAIR_noExist(const LAIR:tColorsLAIR; const color:tColor):boolean;

implementation

function ColorsNode_new(const aColor:tColor):pColorsNode;
begin
    new(result);
    result^.color:=aColor;
    result^.delta:=0;
    {$ifOpt D+} result^.next:=nil; {$endIf}
end;

procedure ColorsNode_DEL(const node:pColorsNode);
begin   {$ifOpt D+}
        Assert(Assigned(node));
        Assert(NOT Assigned(node^.next));
        {$endIf}
    Dispose(node);
end;

//------------------------------------------------------------------------------

function ColorsLAIR_Present(const LAIR:tColorsLAIR):boolean;
begin
    result:=Assigned(LAIR);
end;

function ColorsLAIR_isEMPTY(const LAIR:tColorsLAIR):boolean;
begin
    result:=NOT ColorsLAIR_Present(LAIR);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure ColorsLAIR_INIT (out LAIR:tColorsLAIR);
begin
    LAIR:=nil;
end;

procedure ColorsLAIR_CLEAR(var LAIR:tColorsLAIR);
var tmp:pColorsNode;
begin
    while ColorsLAIR_Present(LAIR) do begin
        tmp:=ColorsLAIR_pop(LAIR);
        ColorsNode_DEL(tmp)
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

type
 pPColorsNode=^pColorsNode;

procedure ColorsLAIR_push(var LAIR:tColorsLAIR; const node:pColorsNode);
var tmp:pPColorsNode;
begin   {$ifOpt D+}
        Assert(Assigned(node));
        Assert(NOT Assigned(node^.next));
        {$endIf}
    tmp:=@LAIR;
    while Assigned(tmp^) do begin
        if node^.delta <= tmp^^.delta then BREAK;
        tmp:=@((tmp^)^.next);
    end;
    //---
    node^.next:=tmp^;
    tmp^:=node;
end;

function ColorsLAIR_pop(var LAIR:tColorsLAIR):pColorsNode;
begin
    result:=LAIR;
    if Assigned(result) then begin
        LAIR:=result^.next;
        {$ifOpt D+} result^.next:=nil; {$endIf}
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ColorsLAIR_first(const LAIR:tColorsLAIR):pColorsNode;
begin
    result:=LAIR;
end;

function ColorsLAIR_next(const node:pColorsNode):pColorsNode;
begin   {$ifOpt D+}
        Assert(Assigned(node));
        {$endIf}
    result:=node^.next;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function ColorsLAIR_present(const LAIR:tColorsLAIR; const color:tColor):boolean;
var tmp:pColorsNode;
begin
    tmp:=ColorsLAIR_first(LAIR);
    while Assigned(tmp) do begin
        if tmp^.color=color then EXIT(TRUE);
        tmp:=ColorsLAIR_next(tmp);
    end;
    result:=false;
end;

function ColorsLAIR_noExist(const LAIR:tColorsLAIR; const color:tColor):boolean;
begin
    result:=NOT ColorsLAIR_present(LAIR,color);
end;

end.

