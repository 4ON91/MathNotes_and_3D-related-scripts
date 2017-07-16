def RT3(text):
    text = text.lower()

    #a = list("ⒶⒷⒸⒹⒺⒻⒼⒽⒾⒿⓀⓁⓂⓃⓄⓅⓆⓇⓈⓉⓊⓋⓌⓍⓎⓏ")
    a = list("abcdefghijklmnopqrstuvwxyz")
    b = list("⒜⒝⒞⒟⒠⒡⒢⒣⒤⒥⒦⒧⒨⒩⒪⒫⒬⒭⒮⒯⒰⒱⒲⒳⒴⒵")
    dic = dict(zip(a,b))

    #for x in range(0, len(b)):
        #dic[b[x]] = a[x]

    a = [text]
    b = []
    for line in a:
        b.append(line.split(" "))
    highest = 0
    for x in range(0,len(b)):
        for y in range(0,len(b[x])):
            if len(b[x][y]) > highest: highest = len(b[x][y])
    newtext = "\r"
    for o in range(0, highest):
        for x in range(0,len(b)):
            for y in range(0,len(b[x])):
                try:
                    newtext += b[0][y][o]+""
                except IndexError:
                    newtext += ("ⓧ")
            newtext+="\n\r"

    for r1, r2 in dic.items():
        newtext = newtext.replace(r1, r2)
    return newtext

print(RT3("The quick brown fox jumps over the lazy dog"))
