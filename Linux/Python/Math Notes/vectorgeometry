from math import *

"""
When dividing integers, using arithmetic shifts are faster than
using the divide operator
"""

class p:
    def __init__(self, x,y,z):
        self.x = x
        self.y = y
        self.z = z
    def __repr__(self):
        return('p(%r, %r, %r)'%(self.x, self.y, self.z))

    def __add__(self, other):
        try:
            x = self.x + other.x
            y = self.y + other.y
            z = self.z + other.z
        except AttributeError:
            x = self.x + other
            y = self.y + other
            z = self.z + other
        return(p(x,y,z))
        
    def __sub__(self, other):
        try:
            x = self.x - other.x
            y = self.y - other.y
            z = self.z - other.z
        except AttributeError:
            x = self.x - other
            y = self.y - other
            z = self.z - other
        return(p(x,y,z))

    def __pow__(self, other):
        try:
            x = self.x ** other.x
            y = self.y ** other.y
            z = self.z ** other.z

        except AttributeError:
            x = self.x ** other
            y = self.y ** other
            z = self.z ** other
        return(p(x,y,z))

    def __mul__(self, other):
        try:
            x = self.x * other.x
            y = self.y * other.y
            z = self.z * other.z
        except AttributeError:
            x = self.x * other
            y = self.y * other
            z = self.z * other
        return(p(x,y,z))

def crossproduct(*args, **kwargs):
    Normal = kwargs.get("IsNormal", bool)
    if Normal == True:
        P = args[0]
        Q = args[1]
        R = args[2]
        u = Q-P
        v = R-P
        a = crossproduct(u,v)
        print("d = %f"%total(a*P))
        return(a)

    if len(args) > 3 or len(args) < 2:
        print("2x2 or 3x3 only")
        return

    if len(args) == 2:
        x = args[0].x
        y = args[0].y
        z = args[0].z
        
        i = args[1].x
        j = args[1].y
        k = args[1].z

        a =  (y*k)-(z*j)
        b = -(x*k)+(z*i)
        c =  (x*j)-(y*i)
        
    if len(args) == 3:
        u = args[0].x
        v = args[0].y
        w = args[0].z
        
        x = args[1].x
        y = args[1].y
        z = args[1].z
        
        i = args[2].x
        j = args[2].y
        k = args[2].z
        
        a = u*( (y*k)-(z*j) )
        b = v*(-(x*k)+(z*i) )
        c = w*( (x*j)-(y*i) )

    return(p(a,b,c))

def quadraticformula(a,b,c):
    print( ( -b + sqrt(b**2-4*a*c) ) / ( 2*a ))
    print( ( -b - sqrt(b**2-4*a*c) ) / ( 2*a ))
    
def total(*args):
    total = 0
    for x in range(0, len(args)):
        total += args[x].x
        total += args[x].y
        total += args[x].z
    return(total)

def test(p1,p2):
    a = total(p1*p2)
    if a > 0:
        print("Acute")
    if a < 0:
        print("Obtuse")
    if a == 0:
        print("Orthogonal (90 degrees)")
    return(a)

def area(p1,p2):        return(sqrt(total(crossproduct(p1,p2)**2)))
def vlen(p1):           return(sqrt(total(p1**2)))
def vlen2(p1):          return(total(p1**2))

def dot(p1,p2):         return(total(p1*p2))
def projection(v,w):    return(w*(total(v*w)/total(w**2)))
def length(p1,p2):      return(sqrt( total( (p2-p1)**2 ) ))

def angle(p1,p2):       return(degrees(acos(dot(p1*p2)/(vlen(p1)*vlen(p2)))))
def deco(p1,p2):        return(p1-p2)
def scalar(n,v,w):      return(total(n*(v-w)))

class gradients:
    def __init__(self, u):
        
        try:
            self.xy = u.x/u.y
        except ZeroDivisionError:
            pass
        
        try:
            self.xz = u.x/u.z
        except ZeroDivisionError:
            pass
        
        try:
            self.yx = u.y/u.x
        except ZeroDivisionError:
            pass
            self.yz = u.y/u.z
            
        try:
            self.zx = u.z/u.x
        except ZeroDivisionError:
            pass

        try:
            self.zy  = u.z/u.y
        except ZeroDivisionError:
            pass



def R2C(Target):
    Radius = sqrt( Target.x**2 + Target.y**2)
    Angle = degrees(atan(Target.y/Target.x))
    return(p(Radius,Angle, Target.z))

def C2R(Target):
    x = Target.x*cos(radians(Target.y))
    y = Target.x*sin(radians(Target.y))
    z = Target.z
    return(p(x,y,z))

def S2R(Target):
    r = pi/180
    x = Target.x * cos(Target.y*r) * sin(Target.z*r)
    y = Target.x * sin(Target.y*r) * sin(Target.z*r)
    z = Target.x * cos(Target.z*r)

    #x = float("%2.14f"%x)
    #y = float("%2.14f"%y)
    #z = float("%2.14f"%z)

    #print(x,y,z)
    return(p(x,y,z))

def R2S(Target):
    Radius = sqrt(total(Target**2))
    PolarAngle = degrees(atan(Target.y/Target.x))
    AzimuthalAngle = degrees(acos(Target.z/Radius))
    return(p(Radius, PolarAngle, AzimuthalAngle))
