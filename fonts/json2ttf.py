# glifi 4x7 (righe dall'alto; base della scrittura sotto la riga 5) -> TTF a pixel quadrati
import sys, json
from fontTools.fontBuilder import FontBuilder
from fontTools.pens.ttGlyphPen import TTGlyphPen
U=100; ROWS=7; ASC=6; DESC=1; ADV=4
f=json.load(open(sys.argv[1]))
f.setdefault('J',["....","..#.","..#.","..#.","#.#.","###.","...."])
f.setdefault('Q',["....",".##.","#.#.","#.#.","###.","..#.","...."])
f.setdefault('`',["....","#...",".#..","....","....","....","...."])
def glyph(rows):
    pen=TTGlyphPen(None)
    for r,line in enumerate(rows):
        y=(ASC-1-r)*U; x=0; line=line.replace('.','0').replace('#','1')
        while x<len(line):
            if line[x]=='1':
                e=x
                while e+1<len(line) and line[e+1]=='1': e+=1
                pen.moveTo((x*U,y)); pen.lineTo((x*U,y+U)); pen.lineTo(((e+1)*U,y+U)); pen.lineTo(((e+1)*U,y)); pen.closePath()
                x=e+1
            else: x+=1
    return pen.glyph()
names=['.notdef','space']; glyphs={'.notdef':glyph([]),'space':glyph([])}; cmap={32:'space'}
for c in sorted(f):
    n='uni%04X'%ord(c); names.append(n); glyphs[n]=glyph(f[c]); cmap[ord(c)]=n
metrics={n:(ADV*U,0) for n in names}
fam='Pixel 4x7'; ps='Pixel4x7-Regular'
fb=FontBuilder(unitsPerEm=ROWS*U, isTTF=True)
fb.setupGlyphOrder(names); fb.setupCharacterMap(cmap); fb.setupGlyf(glyphs); fb.setupHorizontalMetrics(metrics)
fb.setupHorizontalHeader(ascent=ASC*U, descent=-DESC*U, lineGap=0)
fb.setupNameTable({'familyName':fam,'styleName':'Regular','uniqueFontIdentifier':ps,'fullName':fam+' Regular','psName':ps,
                   'copyright':'Glifi ricostruiti dai pixel di uno screenshot (uso personale)'})
fb.setupOS2(sTypoAscender=ASC*U, sTypoDescender=-DESC*U, sTypoLineGap=0, usWinAscent=ASC*U, usWinDescent=DESC*U,
            usWeightClass=400, fsSelection=0x40, achVendID='NONE', xAvgCharWidth=ADV*U, sxHeight=4*U, sCapHeight=5*U)
fb.font['OS/2'].panose.bProportion=9
fb.setupPost(isFixedPitch=1, underlinePosition=-DESC*U, underlineThickness=U)
fb.save(sys.argv[2]); print(len(cmap),'caratteri ->',sys.argv[2])
