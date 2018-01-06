#Only works with integer values
def SquareRootAlgorithm(VARIABLE):
    for i in range(0, VARIABLE+1):
        if( pow(i,2) >= VARIABLE):
            MULTIPLE = i-1
            PROBLEM = VARIABLE-pow(i-1,2)
            FINAL_ANSWER = MULTIPLE
            break
    for i in range(1, 100):
        PROBLEM = PROBLEM*100
        MULTIPLE = (MULTIPLE+(MULTIPLE%10))*10
        for x in range(0, 10):
            if( (MULTIPLE+x)*x > PROBLEM):
                PROBLEM = PROBLEM - (MULTIPLE+(x-1))*(x-1)
                MULTIPLE = (MULTIPLE+(x-1))
                FINAL_ANSWER = FINAL_ANSWER + ((x-1) * pow(10,-i))
                break
    return(FINAL_ANSWER)

print(SquareRootAlgorithm(2))
#1.414213562373
