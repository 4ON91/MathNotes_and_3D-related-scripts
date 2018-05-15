import regex as re

RF = '(\d+)(\.\d+)?'
P  = '\*\*'
MD = '[\*/]'
AS = '[\+-]'
Ops = '[*/0-9+-]'
Operators = [P, MD, AS]

def BODMAS(Equation):
    Equation = Equation.replace(" ", "")
    for Op in Operators:
        RegEx = re.compile(r'(%s)(%s)(%s)'%(RF, Op,  RF))
        while(RegEx.search(Equation)):
            Variables = re.split("(%s)" % Op, RegEx.search(Equation).group())
            X,O,Y = float(Variables[0]), Variables[1], float(Variables[2])
            Start, End = RegEx.search(Equation).spans()[0]
            try:
                if(O == "**"):
                    Equation = Equation.replace(Equation[Start:End], str((X)**(Y)))
                if(O == "*"):
                    Equation = Equation.replace(Equation[Start:End], str(X*Y))
                if(O == "/"):
                    Equation = Equation.replace(Equation[Start:End], str(X/Y))
                if(O == "+"):
                    Equation = Equation.replace(Equation[Start:End], str(X+Y))
                if(O == "-"):
                    Equation = Equation.replace(Equation[Start:End], str(X-Y))
            except ZeroDivisionError:
                Equation = Equation.replace(Equation[Start:End], str(X+Y))
    return(Equation)

Equation = "(1+(2*3**2)**2-(4*(5/2**2)+1))"

Brackets = re.compile(r'\((%s+?)(?!\()\)'%Ops)

def SolveEquation(Eq):
    if("(" in Eq or ")" in Eq):
        for x in range(0, len(Eq)):
            if( Eq[x] == "(" ):
                Start = x
            if( Eq[x] == ")" ):
                End = x
                Eq = Eq.replace(Eq[Start:End+1], BODMAS(Eq[Start+1:End]))
                Eq = SolveEquation(Eq)
                return(Eq)
    else:
        Eq = BODMAS(Eq)
        return(Eq)

print("Br2: ", SolveEquation(Equation))
