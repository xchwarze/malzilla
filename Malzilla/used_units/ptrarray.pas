(* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is JavaScript Bridge.
 *
 * The Initial Developer of the Original Code is
 * Sterling Bates.
 * Portions created by the Initial Developer are Copyright (C) 2003
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** *)

unit ptrarray;

interface

type
  TPtrArray = class
  private
    FCount: Integer;
    FKeys: Array of Pointer;
    FOwnsValues: Boolean;
    FSize: Integer;
    FValues: Array of TObject;

    function GetItem(Ptr: Pointer): TObject;
    procedure Grow;
    function IndexOf(Ptr: Pointer): Integer;
    procedure SetItem(Ptr: Pointer; Value: TObject);
  public
    property Item[Ptr: Pointer]: TObject read GetItem write SetItem; default;
    property OwnsValues: Boolean read FOwnsValues write FOwnsValues;

    constructor Create;
    destructor Destroy; override;

    procedure Add(Key: Pointer; Value: TObject);
  end;

implementation

{ TPtrArray }

procedure TPtrArray.Add(Key: Pointer; Value: TObject);
begin
  Inc(FCount);
  if (FCount >= FSize) then
    Grow;
  FKeys[FCount-1] := Key;
  FValues[FCount-1] := Value;
end;

constructor TPtrArray.Create;
begin
  FSize := 0;
  FCount := 0;
end;

destructor TPtrArray.Destroy;
var
  i: Integer;
begin
  inherited;

  if (FOwnsValues) then
  begin
    for i := 0 to FCount-1 do
      FValues[i].Free;
  end;

  SetLength(FKeys, 0);
  SetLength(FValues, 0);
end;

function TPtrArray.GetItem(Ptr: Pointer): TObject;
var
  idx: Integer;
begin
  idx := IndexOf(Ptr);
  if (idx <> -1) then
    Result := FValues[idx]
  else
    Result := nil;
end;

procedure TPtrArray.Grow;
begin
  Inc(FSize, 16);
  SetLength(FKeys, FSize);
  SetLength(FValues, FSize);
end;

function TPtrArray.IndexOf(Ptr: Pointer): Integer;
var
  i: Integer;
begin
  for i := 0 to Length(FKeys)-1 do
    if (FKeys[i] = Ptr) then
    begin
      Result := i;
      exit;
    end;
  Result := -1;
end;

procedure TPtrArray.SetItem(Ptr: Pointer; Value: TObject);
var
  idx: Integer;
begin
  idx := IndexOf(Ptr);
  if (idx <> -1) then
    FValues[idx] := Value
  else
    Add(Ptr, Value);
end;

end.

