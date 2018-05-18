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

def SolveBrackets(Eq):
    while(re.search(r'([()])', Eq)):
        a = re.search(r'\([\.*/0-9+-]*?\)', Eq)
        s, e = a.spans()[0]
        Eq = Eq.replace(Eq[s:e], BODMAS(Eq[s+1:e-1]))
    return(Eq)

print("SolveBrackets: ", SolveBrackets(Equation))



