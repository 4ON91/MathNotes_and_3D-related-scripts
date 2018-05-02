import copy
import csv
import os

class Gate:
    def __init__(self, Sockets):
        self.Sockets = Sockets
        self.Inputs = []
        self.UniqueInputs = ""
        
    def canPass(self):
        return(True)
    
    def getInput(self, I):
        if( (type(I) == Input) &
            (I.sym().casefold() not in self.UniqueInputs.casefold()) ):
            self.UniqueInputs += I.sym()
            self.Inputs.append(I.On)
    
class Input:
    def __init__(self, Symbol, On):
        self.Symbol = Symbol.upper()[:1]
        self.On = On
        self.Position = (int, int)
    
    def sym(self):
        if(self.On):
            return(self.Symbol.upper())
        else:
            return(self.Symbol.lower())

    def csym(self):
        return(self.Symbol.casefold())
    
    def __repr__(self):
        return(self.sym())

    def __invert__(self):
        if(self.On):
            self.On = False
        else:
            self.On = True
    
    def canPass(self):
        return(False)
    
    def canContinue(self, I):
        return(True)

class Output:
    def canPass(self):
        return(True)
    
    def canContinue(self, I):
        return(True)

class AND(Gate):
    def canContinue(self, I):
        self.getInput(I)
        if((True in self.Inputs)&
           (False not in self.Inputs)&
           (len(self.Inputs) >= self.Sockets)):
            return(True)
        else:
            return(False)

class NAND(Gate):
    def canContinue(self, I):
        self.getInput(I)
        if((False in self.Inputs)&
           (True not in self.Inputs)&
           (len(self.Inputs) >= self.Sockets)):
            return(True)
        else:
            return(False)
        
class OR(Gate):
    def canContinue(self, I):
        self.getInput(I)
        if( (len(self.Inputs) >= self.Sockets) &
            (True in self.Inputs) ):
            return(True)
        else:
            return(False)
        
class NOR(Gate):
    def canContinue(self, I):
        self.getInput(I)
        if( (len(self.Inputs) >= self.Sockets) &
            (False in self.Inputs) ):
           return(True)
        else:
           return(False)
        
class INVERT:
    def canPass(self):
        return(True)
    
    def canContinue(self, I):
        ~I
        return(True)
    
class CircuitPath:
    def __init__(self, Passable):
        self.Passable = Passable
        
    def canPass(self):
        return(self.Passable)

    def canContinue(self, I):
        return(True)
        
def SwitchStateList(NumberOfSwitches):
    binary_string = ""
    i = 0
    Switches = NumberOfSwitches
    
    Switch_States = []
    while( len(binary_string) <= NumberOfSwitches ):
        binary_string = str(bin(i))[2:]
        i += 1
        Switch_States.append(("{:>0%s}"%str(Switches)).format(binary_string))

    Switch_States.pop(-1)
    return(Switch_States)

def ANDList(NumberOfSwitches):
    a = list("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    binary_string = ""
    i = 0
    Switches = NumberOfSwitches
    
    Switch_States = []
    while( len(binary_string) <= NumberOfSwitches ):
        binary_string = ("{:>0%s}"%str(Switches)).format(str(bin(i))[2:])
        b = ""
        for x in range(0, len(binary_string)):
            if(int(binary_string[x]) == 0):
                b += a[x].lower()
            else:
                b += a[x].upper()
        i += 1
        Switch_States.append(b)

    Switch_States.pop(-1)
    return(Switch_States)

def RunCircuit(file):
    OP1 = OR(1)
    OP2 = OR(2)
    OP3 = OR(3)

    ON1 = NOR(1)
    ON2 = NOR(2)
    ON3 = NOR(3)

    AP1 = AND(1)
    AP2 = AND(2)
    AP3 = AND(3)

    AN1 = NAND(1)
    AN2 = NAND(2)
    AN3 = NAND(3)
           
    CP0 = CircuitPath(False)
    CP1 = CircuitPath(True)
           
    I00 = Input("A", False)
    I01 = Input("B", True)
    I02 = Input("C", True)
    
    OUT = Output()
    INV = INVERT()
    
    Circuit_Array = [line for line in csv.reader(open(file, "r"))]
    for y in range(0, len(Circuit_Array)):
        for x in range(0, len(Circuit_Array[0])):
            exec("Circuit_Array[y][x] = " + Circuit_Array[y][x])
            
    Circuit = copy.deepcopy(Circuit_Array)
    
    Row = len(Circuit)-1
    Col = len(Circuit[0])-1
    
    Integers = []

    Input_List = []
    
    for y in range(0, len(Circuit)):
        for x in range(0, len(Circuit[0])):
            if(type(Circuit[y][x]) == Input):
                Circuit[y][x].Position = (x,y)
                Input_List.append(Circuit[y][x])

    def BoolMove(Tile, Direction):
        if(Tile.canPass()):
            return(Direction)
        else:
            return("")
        
    def GetDirection(Position, Direction):
        X, Y = Position
        if(Direction == "N"):
            X, Y = X, Y-1
        if(Direction == "E"):
            X, Y = X+1, Y
        if(Direction == "S"):
            X, Y = X, Y+1
        if(Direction == "W"):
            X, Y = X-1, Y
        return((X, Y))

    def FindOutput(Input, CurrentPosition, Directions, Map, Length, Path, Globals):
        X, Y = CurrentPosition
        while(True):
            if len(Directions) >= 2:
                for Direction in Directions:
                    FindOutput(Input, (X,Y), Direction, copy.deepcopy(Map), Length, copy.deepcopy(Path), Globals)
                return

            Map[Y][X] = CP0

            if( Globals[Y][X].canContinue(Input) ):
                pass
            else:
                Integers.append([0, Input.sym(), Length, Path])
                return

            if(len(Directions) > 0):
                Path.append(Directions)
                
            X, Y = GetDirection((X,Y), Directions)

            if( type(Globals[Y][X]) == Output):
                Integers.append([1, Input.sym(), Length, Path])
                return
            
            Directions = ""
            
            if(Y-1 >= 0):
                Directions += BoolMove(Map[Y-1][X], "N")

            if(X+1 <= Col):
                Directions += BoolMove(Map[Y][X+1], "E")

            if(Y+1 <= Row):
                Directions += BoolMove(Map[Y+1][X], "S")

            if(X-1 >= 0):
                Directions += BoolMove(Map[Y][X-1], "W")

            if len(Directions) == 0:
                Integers.append([0, Input.sym(), Length, Path])
                return

            Length += 1

    Input_List.sort(key = Input.csym)
    
    for I in Input_List:
        FindOutput(I, I.Position, "", copy.deepcopy(Circuit), 0, [], Circuit_Array)
         
    return(Integers)

EmulatedCircuit = RunCircuit("T01.txt")

for line in EmulatedCircuit:
    print(line)

"""
C * ( (A*B) + (a*B) )
C * ( (A*b) + a )
A * ( (B*c) + (b*C) + (a*B) ) * B
C * ( (B*C*a) + (a * (B+C)) )

A - 835

Simplying circuit

ab + aB + Ab
a*(B+b) + Ab
a*(1) + Ab
a + Ab

(A+aB)*(B+bA)
(A*B) + (A*bA) + (aB * B) + (aB*bA)
AB + Ab + aB + aBbA (Switches can't be on and off at the same time so we get rid of aBbA)
AB + Ab + aB + 0
AB + Ab + aB
A*(B+b) + aB (We simplify the equation now by grouping like terms)
A(B+b) + aB (and again; Switches can't be on and off at the same time so we get rid of Bb)
A + aB (and we're left with this)

ABc + ABC + aBC
AB(c+C) + aBC = (ABc + ABC + aBC, but simplified)
AB(1) + aBC (Adding a switch's opposite to itself is equal to '1')
AB + aBC (A switch multiplied by 1 is equal to itself)
B(A + aC)

abC + aBC + AbC + ABC
bC(Aa) + BC(Aa)
bC(1) + BC(1)
bC + BC
C(Bb) = bC + BC
C(1)
C
   0
   1
  10
  11
 100
 101
 110
 111
1000
1001
1010
1011
1100
1101
1110
1111

Ac + a(B+C) + AB(C+b)
Ac + aB + aC + ABC + ABb
Ac + aB + aC + ABC + A(0) ( A switch multiplied by its opposite is equal to '0')
Ac + aB + aC + ABC
A(c+BC) + aB + aC    (Rule 17: A + aB = A+B)
A(c+B) + aB + aC
Ac + AB + aB + aC
Ac + B(A+a)
Ac + B + aC (Simplify until you have a set of unique variables)

AbC + AB(aC) + BC(bA)
AbC + ABa + ABC + BCb + BCA
AbC + 0*B + ABC + 0*C + ABC
AbC + ABC + ABC (ABC + ABC = ABC)
AbC + ABC
AC(b+B)
AC(1)
AC


HEM 11 46 105
835

1
ab + aB
a(b + B)
a

2
aB + AB + ab
a(B+b) + AB
a + AB

3
ab + Ab + b(A+a)
ab + Ab + b(1)
ab +Ab + b
b(Aa) + b
b(1) + b
b + b
b

4
Ab + A(B+b) + AB
Ab + AB + Ab + AB
Ab + Ab = Ab
AB + AB = AB
Ab + AB
A(Bb)
A

5
(A+AB)*(B+BA)
(AB) + (A*AB) + (AB*B) + (AB*AB)
AB + (A*A)B + A(B*B) + AB
AB + A(B) + A(B) + AB
AB

6
abC + aBC + AbC
bC(a + A) + aBC
bC(a + A) + aBC
bC(1) + aBC
bC + aBC
C(b + aB)

7
Abc + ABC + aBC
Abc + BC(A+a)
Abc + BC

8
abc + aBC + Abc
bc(a+A) + aBC
bc + aBC

9
abc + abC + Abc + AbC
ab(c+C) + Ab(c+C)
ab + Ab
b(A+a)
b

10
AbC + ABC + ABc + aBc
AbC + ABC + Bc(A+a)
AbC + ABC + Bc
AC(b+B) + Bc
AC + Bc

11
C(AB+Ab) + c(ab+aB)
ABC + AbC + abc + aBc
AC(B+b) + ac(b+B)
AC + ac

12
c(ab + AB + Ab) + A(BC + bC)
abc + ABc + Abc + ABC + AbC
abc + A(Bc + bC) + A(bc+BC)
abc + A + A
abc + A -shallow simplification

c(ab + AB + Ab) + A(BC+ bC)
abc + ABc + Abc + ABC + AbC
bc(a+A) ABc + ABC + AbC
bc + ABc + ABC + AbC
bc + AB(c+C) + AbC
bc + AB + AbC
b(c + AC) + AB
b(c+A) + AB
bc + Ab + AB
bc + A(b+B)
bc + A -deeper simplification
A + bc

AbC * aBc

11.4 106 De Morgan's laws
 ____     __
(Ab+C)*(a+Bc)
t1: (a+B)*c = ac + Bc
t2: a + (b+C) = a + b + C
(ac+Bc)*(a+b+C)
aac + abc + acC + aBc + Bbc + BcC
ac + abc + 0 + aBc + 0 + 0
ac + abc + aBc
ac(B+b) + ac
ac + ac
ac
 __   ___
(aB)+(a+B)
(A+b)+A*b
A+Ab+b   (A+AB) = A, regardless of any of the variable's states.
A+b

HEM 11.4 E47 107
1
      __
(ab)*(aB)
(ab)*(A+b)
Aab + abb
0 + ab
ab

2  __   __
(A+BC)+(AB+C) = a+b+C
((A+b)*c) + (a+b+C)
Ac+bc+a+b+C
(a+Ac)+(b+bc)+C
a+b+C

3
 _____   __
(aB+Bc)*(Ab)
((A+b)*(b+C))*(a+B)
(Ab+AC+bb+bC)*(a+B)
Aab+ABb+AaC+ABC+abb+Bbb+abC+BbC
0+0+0+ABC+ab+0+abC+0
ABC+ab+abC   (ab+abC = ab ???)
ABC + ab

4
 __ __   __
(Ab+Bc)+(aB)
(a+B+b+C)+(A+b)
a+B+b+C+A+b
(A+a)+(B+b)+C
1 + 1 + C
(C+1) + 1
1 + 1 = 1 ???

5
 __ __    __
(Ab+aC)*(aBC) = a(b+c)
(a+B+A+c)*(a*(b+c))
(a+B+A+c)*(ab+ac)
aab+aac+aBb+aBc+Aab+Aac+abc+acc
ab+ac+0+aBc+0+0+abc+ac
ab+ac+aBc+abc+ac
(ac+ac)+(ab+aBc)+(ac+acb)
ac+ab+ac
ac+ab
a(b+c)
"""
