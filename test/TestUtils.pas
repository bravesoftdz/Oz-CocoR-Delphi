unit TestUtils;

interface

uses
  TestFramework,
  System.Classes,
  System.Generics.Collections,
  oz.cocor.Utils;

type

{$Region 'TestTBitSet: Test methods'}

  TestTBitSet = class(TTestCase)
  strict private
    FBitSet: TBitSet;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestClone;
    procedure TestUnite;
    procedure TestIntersect;
    procedure TestDiffer;
    procedure TestSetAll;
  end;

{$EndRegion}

{$Region 'TestTCharSet: Test methods'}

  TestTCharSet = class(TTestCase)
  strict private
    FCharSet: TCharSet;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestIncl;
    procedure TestIncl1;
    procedure TestEquals;
    procedure TestElements;
    procedure TestFirst;
    procedure TestUnite;
    procedure TestIntersect;
    procedure TestSubtract;
    procedure TestIncludes;
    procedure TestIntersects;
    procedure TestFill;
    procedure TestClone;
  end;

{$EndRegion}

implementation

{$Region 'TestTBitSet'}

procedure TestTBitSet.SetUp;
begin
  FBitSet := TBitSet.Create(600);
end;

procedure TestTBitSet.TearDown;
begin
  FBitSet.Free;
  FBitSet := nil;
end;

procedure TestTBitSet.TestClone;
var
  r: TBitSet;
  i: Integer;
  b: Boolean;
begin
  FBitSet[20] := True;
  r := FBitSet.Clone;
  try
    for i := 0 to FBitSet.Size - 1 do
    begin
      b := r[i];
      Check(b = (i = 20), 'Clone error')
    end;
  finally
    r.Free;
  end;
end;

procedure TestTBitSet.TestUnite;
var
  s: TBitSet;
  i: Integer;
  b: Boolean;
begin
  FBitSet[20] := True;
  s := TBitSet.Create(600);
  try
    s[200] := True;
    s[400] := True;
    FBitSet.Unite(s);
    for i := 0 to FBitSet.Size - 1 do
    begin
      b := FBitSet[i];
      case i of
        20, 200, 400:
          Check(b, 'Unite error');
      else
        Check(not b, 'Unite error');
      end;
    end;
  finally
    s.Free;
  end;
end;

procedure TestTBitSet.TestIntersect;
var
  s: TBitSet;
  i: Integer;
  b: Boolean;
begin
  FBitSet[0] := True;
  FBitSet[20] := True;
  FBitSet[200] := True;
  FBitSet[599] := True;
  s := TBitSet.Create(600);
  try
    s[0] := True;
    s[80] := True;
    s[200] := True;
    s[400] := True;
    s[450] := True;
    s[599] := True;
    FBitSet.Intersect(s);
    for i := 0 to FBitSet.Size - 1 do
    begin
      b := FBitSet[i];
      case i of
        0, 200, 599:
          Check(b, 'Intersect error');
      else
        Check(not b, 'Intersect error');
      end;
    end;
  finally
    s.Free;
  end;
end;

procedure TestTBitSet.TestDiffer;
var
  s: TBitSet;
  i: Integer;
  b: Boolean;
begin
  FBitSet[0] := True;
  FBitSet[20] := True;
  FBitSet[200] := True;
  FBitSet[300] := True;
  FBitSet[599] := True;
  s := TBitSet.Create(600);
  try
    s[200] := True;
    s[400] := True;
    s[599] := True;
    FBitSet.Differ(s);
    for i := 0 to FBitSet.Size - 1 do
    begin
      b := FBitSet[i];
      case i of
        0, 20, 300:
          Check(b, 'Differ error');
      else
        Check(not b, 'Differ error');
      end;
    end;
  finally
    s.Free;
  end;
end;

procedure TestTBitSet.TestSetAll;
var
  b, b1: Boolean;
  i: Integer;
begin
  for b in [False, True] do
  begin
    FBitSet.SetAll(b);
    for i := 0 to FBitSet.Size - 1 do
    begin
      b1 := FBitSet[i];
      Check(b1 = b, 'SetAll error');
    end;
  end;
end;

{$EndRegion}

{$Region 'TestTCharSet'}

procedure TestTCharSet.SetUp;
begin
  FCharSet := TCharSet.Create;
end;

procedure TestTCharSet.TearDown;
begin
  FCharSet.Free;
  FCharSet := nil;
end;

procedure TestTCharSet.TestIncl;
var
  ch: Char;
  i: Integer;
  b1, b2: Boolean;
begin
  ch := 'A';
  FCharSet.Incl(ch);
  for i := 0 to 255 do
  begin
    b1 := FCharSet.Items[i];
    Check(b1 = (Ord(ch) = i))
  end;
  ch := 'D';
  FCharSet.Incl(ch);
  for i := 0 to 255 do
  begin
    b1 := FCharSet.Items[i];
    b2 := (i = Ord('A')) or (i = Ord('D'));
    Check(b1 = b2);
  end;
  ch := 'C';
  FCharSet.Incl(ch);
  for i := 0 to 255 do
  begin
    b1 := FCharSet.Items[i];
    b2 := (i = Ord('A')) or (i = Ord('C')) or (i = Ord('D'));
    Check(b1 = b2);
  end;
  ch := 'B';
  FCharSet.Incl(ch);
  for i := 0 to 255 do
  begin
    b1 := FCharSet.Items[i];
    b2 := (i >= Ord('A')) and (i <= Ord('D'));
    Check(b1 = b2);
  end;
end;

procedure TestTCharSet.TestIncl1;
var
  ch, i: Integer;
  b: Boolean;
begin
  ch := Ord('A');
  FCharSet.Incl(ch);
  for i := 0 to 255 do
  begin
    b := FCharSet.Items[i];
    Check(b = (ch = i))
  end;
end;

procedure TestTCharSet.TestEquals;
var
  b: Boolean;
  s: TCharSet;
begin
  FCharSet.Incl('A');
  FCharSet.Incl('0');
  FCharSet.Incl('9');
  s := TCharSet.Create;
  try
    s.Incl('A');
    s.Incl('0');
    s.Incl('9');
    s.Incl('B');
    b := FCharSet.Equals(s);
    Check(not b);
    FCharSet.Incl('B');
    b := FCharSet.Equals(s);
    Check(b);
  finally
    s.Free;
  end;
end;

procedure TestTCharSet.TestElements;
var
  i, n: Integer;
begin
  n := FCharSet.Elements;
  Check(n = 0);
  FCharSet.Incl('A');
  n := FCharSet.Elements;
  Check(n = 1);
  for i := Ord('0') to Ord('9') do
    FCharSet.Incl(i);
  n := FCharSet.Elements;
  Check(n = 11);
end;

procedure TestTCharSet.TestFirst;
var
  f: Integer;
begin
  f := FCharSet.First;
  Check(f = -1);
  FCharSet.Incl(100);
  f := FCharSet.First;
  Check(f = 100);
  FCharSet.Incl(32);
  f := FCharSet.First;
  Check(f = 32);
end;

procedure TestTCharSet.TestUnite;
var
  s, r: TCharSet;
  f: Integer;
  b: Boolean;
begin
  s := TCharSet.Create;
  r := TCharSet.Create;
  try
    FCharSet.Unite(s);
    f := FCharSet.First;
    Check(f = -1);
    s.Incl('A');
    s.Incl('0');
    FCharSet.Incl('B');
    FCharSet.Incl('z');
    FCharSet.Unite(s);
    r.Incl('A');
    r.Incl('0');
    r.Incl('B');
    r.Incl('z');
    b := FCharSet.Equals(r);
    Check(b);
  finally
    s.Free;
    r.Free;
  end;
end;

procedure TestTCharSet.TestIntersect;
var
  s, r: TCharSet;
  f: Integer;
  b: Boolean;
begin
  s := TCharSet.Create;
  r := TCharSet.Create;
  try
    FCharSet.Unite(s);
    f := FCharSet.First;
    Check(f = -1);
    s.Incl('A');
    s.Incl('B');
    s.Incl('0');
    s.Incl('1');
    s.Incl('2');
    FCharSet.Incl('B');
    FCharSet.Incl('2');
    FCharSet.Incl('z');
    FCharSet.Intersect(s);
    r.Incl('B');
    r.Incl('2');
    b := FCharSet.Equals(r);
    Check(b);
  finally
    s.Free;
    r.Free;
  end;
end;

procedure TestTCharSet.TestSubtract;
var
  a, b, r: TCharSet;
  ok: Boolean;
begin
  FCharSet.Incl('A');
  FCharSet.Incl('B');
  FCharSet.Incl('C');
  FCharSet.Incl('D');
  FCharSet.Incl('E');
  FCharSet.Incl('F');
  FCharSet.Incl('0');
  FCharSet.Incl('5');
  FCharSet.Incl('9');
  FCharSet.Incl('z');
  a := TCharSet.Create;
  b := TCharSet.Create;
  try
    a.Incl('C');
    a.Incl('F');
    a.Incl('z');
    r := FCharSet.Subtract(a);
    try
      b.Incl('A');
      b.Incl('B');
      // C
      b.Incl('D');
      // F
      b.Incl('E');
      b.Incl('0');
      b.Incl('5');
      b.Incl('9');
      // z
      ok := r.Equals(b);
      Check(ok);
    finally
      r.Free;
    end;
  finally
    a.Free;
    b.Free;
  end;
end;

procedure TestTCharSet.TestIntersects;
var
  s: TCharSet;
  b: Boolean;
begin
  FCharSet.Incl('A');
  FCharSet.Incl('B');
  FCharSet.Incl('C');
  FCharSet.Incl('D');
  FCharSet.Incl('E');
  FCharSet.Incl('F');
  FCharSet.Incl('0');
  FCharSet.Incl('5');
  FCharSet.Incl('9');
  FCharSet.Incl('z');
  s := TCharSet.Create;
  try
    b := FCharSet.Intersects(s);
    s.Incl('@');
    Check(not b);
    s.Incl('F');
    b := FCharSet.Intersects(s);
    Check(b);
  finally
    s.Free;
  end;
end;

procedure TestTCharSet.TestIncludes;
var
  b: Boolean;
  s: TCharSet;
begin
  FCharSet.Incl('A');
  FCharSet.Incl('B');
  FCharSet.Incl('C');
  FCharSet.Incl('D');
  FCharSet.Incl('E');
  FCharSet.Incl('F');
  FCharSet.Incl('0');
  FCharSet.Incl('5');
  FCharSet.Incl('9');
  FCharSet.Incl('z');
  s := TCharSet.Create;
  try
    s.Incl('A');
    s.Incl('B');
    s.Incl('C');
    s.Incl('D');
    s.Incl('E');
    s.Incl('F');
    s.Incl('0');
    s.Incl('5');
    s.Incl('9');
    b := FCharSet.Includes(s);
    Check(b);
    s.Incl('z');
    b := FCharSet.Includes(s);
    Check(b);
    s.Incl('@');
    b := FCharSet.Includes(s);
    Check(not b);
  finally
    s.Free;
  end;
end;

procedure TestTCharSet.TestFill;
var
  s: string;
begin
  FCharSet.Fill;
  s := FCharSet.ToString;
  Check(s = '[#0..#65535]');
end;

procedure TestTCharSet.TestClone;
var
  r: TCharSet;
  b: Boolean;
begin
  FCharSet.Incl('A');
  FCharSet.Incl('B');
  FCharSet.Incl('C');
  FCharSet.Incl('D');
  FCharSet.Incl('E');
  FCharSet.Incl('F');
  FCharSet.Incl('0');
  FCharSet.Incl('5');
  FCharSet.Incl('9');
  FCharSet.Incl('z');
  r := FCharSet.Clone;
  try
    b := FCharSet.Equals(r);
    Check(b);
  finally
    r.Free;
  end;
end;

{$EndRegion}

initialization

  RegisterTest(TestTBitSet.Suite);
  RegisterTest(TestTCharSet.Suite);

end.
