from math import *

def r90(x,y,h, *args, **kwargs):
    AC = kwargs.get("tanup", float)
    CB = kwargs.get("tandown", float)

    if h == 0 and y== 0:
        if AC != 0:
            y = x*tan(radians(AC))
            h = x/cos(radians(AC))
    if h == 0 and x == 0:
        if CB != 0:
            x = y/tan(radians(CB))
    if y == 0:
        y = sqrt((h**2-x**2))
    if x == 0:
        x = sqrt((h**2-y**2))
    if h == 0:
        h = sqrt(x**2+y**2) #Pythagora's theorem

    a = x
    o = y
    
    print("\n")
    print("Adjacent: ", x)
    print("Opposite: ", y)
    print("Hypotenuse: ", h)
    print("Angle1: ", degrees(asin(o/h)))
    print("Angle2: ", degrees(asin(a/h)))
    print("Angle3: ", degrees(asin(a/h))*2 )
    print("\n")

    return(x,y,h,degrees(asin(o/h)), degrees(asin(a/h)))

def FH(InnerAngle, OuterAngle, KnownLength):
    a = tan(radians(InnerAngle))
    b = tan(radians(OuterAngle))
    c = b*KnownLength
    d = a-b
    e = c/d
    Height = a*e
    print("Height: ", Height)
    x = r90(0,Height,0,tandown = InnerAngle)


def CosineRule(d,f, E):
    "find the length of the E's side"
    #e**2 = d**2 + f**2 - 2df cos E
    e = sqrt(d**2 + f**2 - (2*d*f)*cos(radians(E)))
    #print(d,f, E,e)
    return(e)

def CosineRule_KnownLengths(a,b,c):
    A = degrees(acos((b**2 + c**2 - a**2)/(2*b*c)))
    B = degrees(acos((a**2 + c**2 - b**2)/(2*a*c)))
    C = degrees(acos((a**2 + b**2 - c**2)/(2*a*b)))

    return(A,B,C)

def SineRule_Length(A, a, B):
    #(a*sin(radians(B)) / sin(radians(A)
    b = (a*sin(radians(B)))/sin(radians(A))
    #print(A,a,B,b)
    return(b)

def SineRule_Angle(a, b, A):
    B = degrees(asin((b*sin(radians(A)))/a))
    #print(A,a,B,b)
    return(B)
    
def nr90(A,a,B,b,C,c, PRINTINFO):
    if A == 0 and B == 0 and C == 0:
        if a != 0 and b != 0 and c != 0:
            Array = CosineRule_KnownLengths(a,b,c)
            A = Array[0]
            B = Array[1]
            C = Array[2]

    #TODO: DRY out if statements
            
    if A != 0 and a == 0:
        if b != 0 and c != 0:
            a = CosineRule(b, c, A)
    if B != 0 and b == 0:
        if a != 0 and c != 0:
            b = CosineRule(a, c, B)
    if C != 0 and c == 0:
        if a != 0 and b != 0:
            c = CosineRule(a, b, C)
    if A != 0 and a != 0: # 0 1
        if b != 0:
            if B == 0:
                B = SineRule_Angle(a,b,A)
        if B != 0:
            if b == 0:
                b = SineRule_Length(A,a,B)
        if c != 0:
            if C == 0:
                C = SineRule_Angle(a,c, A)
        if C != 0:
            if c == 0:
                c = SineRule_Length(A,a,C)
    if B != 0 and b != 0: #2 3
        if c != 0:
            if C == 0:
                C = SineRule_Angle(b,c,B)
        if C != 0:
            if c == 0:
                c = SineRule_Length(B,b,C)  
        if a != 0: 
            if A == 0: 
                A = SineRule_Angle(b,a,B)
        if A != 0:
            if a != 0:
                a = SineRule_Length(B,b,A)
    if C != 0 and c != 0: # 4 5
        if a != 0:
            if A == 0:
                A = SineRule_Angle(c,a,C)
        if A != 0:
            if a == 0:
                a = SineRule_Length(C,c,A)
        if b != 0:
            if B == 0:
                B = SineRule_Angle(c,b,C)
        if B != 0:
            if b == 0:
                b = SineRule_Length(C,c,B)
    if A == 0:
        A = 180 - B - C
        a = (b*sin(radians(A)))/sin(radians(B))
    if B == 0:
        B = 180 - A - C
        b = (a*sin(radians(B)))/sin(radians(A))
    if C == 0:
        C = 180 - A - B
        c = (b*sin(radians(C)))/sin(radians(B))

    print("_"*65)
    print("{:<3} {:<16}{:<3}{:<16}".format("A:", A, "a:", a))
    print("{:<3} {:<16}{:<3}{:<16}".format("B:", B, "b:", b))
    print("{:<3} {:<16}{:<3}{:<16}\n".format("C:", C, "c:", c))
    print("_"*65)
    return(A,a,B,b,C,c)


def CirAng(Parts, Radius):
    info = []
    if Parts % 2 == 0:
        x = Radius * cos(radians(360/Parts))
        y = Radius * sin(radians(360/Parts))
        a = [Radius - x, y]
        a = r90(a[0], a[1], 0)
        b = a
        InnerAngle = a[3] * 2
         
    else:
        x = Radius * sin(radians(360/Parts))
        y = Radius * cos(radians(360/Parts))
        a = [x , Radius - y]
        a = r90(a[0], a[1], 0)
        b = a
        
        InnerAngle = a[3] * (Parts - 2)
        
    ShortAngle = InnerAngle/2
    OuterAngle = 360 - InnerAngle
    Length = a[2]
    info.append([Parts,
                 Radius,
                 Length,
                 InnerAngle,
                 OuterAngle])
    info.append(b)

    print("Points: ", Parts)
    print("Radius: ", Radius)
    print("Length per part: ", Length)
    print("Inner Angle: ", InnerAngle)
    print("Outer Angle: ", OuterAngle)
    print("="*40)
    print("="*40)
    print("="*40)
    print('\n'*3)
    
    return(info)

def polarp(p1,p2):
    x = p1.x - p2.x
    y = p1.y - p2.y
    r = sqrt(x**2+y**2)
    if x == 0 or y == 0:
        if x > 0:
            a = 0
        if y > 0:
            a = 90
        if x < 0:
            a = 180
        if y < 0:
            a = 270

    a = degrees(atan(y/x))*180/pi
    if(x > 0 and y > 0):
        a = a
    if x < 0:
        a = 180 + a
    if x > 0 and y < 0:
        a = 360 + a
    return(a)

class xy:
    def __init__(self, Force, Incline):
        self.f = Force
        self.i = radians(Incline)
        self.x = Force * cos(radians(Incline))
        self.y = Force * sin(radians(Incline))
        print("{:<9}{:<24}".format("Force:",self.f))
        print("{:<9}{:<24}".format("Incline:",self.i))
        print("{:<9}{:<24}".format("x:",self.x))
        print("{:<9}{:<24}".format("y:",self.y))
        print()


class res:
    def __init__(self, *args):
        x = 0
        y = 0
        self.positions = []
        for j in range(0, len(args)):
            x += args[j].x
            y += args[j].y
            self.positions.append([x,y])

        self.m = sqrt(x**2+y**2)
        self.d = degrees(atan(y/x)) 

        print("_"*65)
        print("{:<11}{:<2}".format("X: ", x))
        print("{:<11}{:<2}".format("Y: ", y))

        print("{:<11}{:<2}".format("Magnitude:",self.m))
        print("{:<11}{:<2}".format("Direction:",self.d))
        print("%f to %f/%f"%(self.m, self.d, 180-abs(self.d)))
        print("_"*65)

class line:
    def __init__(self, px, py, dx, dy):
        self.px = px
        self.py = py
        self.dx = dx-px
        self.dy = dy-py
        self.mag = sqrt(self.dx**2 + self.dy**2)

def Intersection(a, b):
    print(a.dx/a.mag, b.dx/b.mag, a.dx/a.mag == b.dx/b.mag)
    print(a.dy/a.mag, b.dy/b.mag, a.dy/a.mag == b.dy/b.mag)
    if a.dx/a.mag == b.dx/b.mag and a.dy/a.mag == b.dy/b.mag:
        print("Lines are parallel - exiting function")
        return
    T2 = (a.dx*(b.py-a.py)+a.dy*(a.px-b.px))/(b.dx*a.dy-b.dy*a.dx)
    T1 = (b.px+b.dx*T2-a.px)/a.dx

    if(T1<0): return(None)
    if(T2<0 or T2>1): return(None)
    print(a.px+a.dx*T1,a.py+a.dy*T1,T1)
    return( [a.px+a.dx*T1,
             a.py+a.dy*T1,
             T1])
    

def GD(Array):
    fx = 0
    f1 = 0
    f2 = 0
    f3 = 0
    f4 = 0
    Standard_Deviation = 0
    
    for i in range(0,len(Array)):
        f1 += Array[i][0]
        f2 += Array[i][1]
        f3 += Array[i][2]
        fx += median((Array[i][0],Array[i][1]))*Array[i][2]

    ReturnArray = []
    ReturnArray.append(fx)
    ReturnArray.append(f1)
    ReturnArray.append(f2)
    ReturnArray.append(f3)

    print("\n")
    Mean = fx/f3
    for i in range(0,len(Array)):
        f4 += Array[i][2]*(median((Array[i][0],Array[i][1]))-Mean)**2

    f4 = sqrt(f4/ReturnArray[3])
    ReturnArray.append(f4)
    print("{:>7} {:<20}".format("Mean", Mean))
    print("{:>7} {:<20}".format("S.D.", f4))
    print("\n")
    return(ReturnArray)

def MMMnSD(A):
    A.sort()
    tag = []
    for line in A:
        if line not in tag:
            tag.append(line)
    Modal = []
    for x in range(0, len(tag)):
        Modal.append(A.count(tag[x]))
    Modal.sort()
    if Modal[len(Modal)-1]==1:
        Modal = "NO MODE"
    else:
        Modal = max(set(A), key = A.count)

    Length              = len(A)
    Mean                = (fsum(A)/len(A))
    Median              = median(A)
    Sum                 = fsum(A)

    Standard_Deviation  =  0

    for i in range(0,len(A)):
        eq = abs((A[i]-len(A))**2)
        Standard_Deviation += eq

    Standard_Deviation = Standard_Deviation/len(A)
    Standard_Deviation = round(sqrt(Standard_Deviation),4)
    sys.stdout.write("{:>7} {:<5}\n".format("Length", Length))
    sys.stdout.write("{:>7} {:<5}\n".format("Mean", Mean))
    sys.stdout.write("{:>7} {:<5}\n".format("Median", Median))
    sys.stdout.write("{:>7} {:<5}\n".format("Modal", Modal))
    sys.stdout.write("{:>7} {:<5}\n".format("S.D.", Standard_Deviation))
