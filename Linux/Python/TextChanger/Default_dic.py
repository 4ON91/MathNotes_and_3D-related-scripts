import sys
from random import choice
#♎
def RT3(text):

    NewText = ""
    
    dic4 = {'_NEWLINE '                 :'ⵥ',
            '_music'                    :'♬',
            '_unwoken'                  :'_(ˇωˇ」∠)',
            '_awoken'                   :'_(°ω°｣ ∠)_ⵥ',
            '_stretch'                  :'٩(๑˘ω˘๑)۶:.｡ⵥ',
            '_tm'                       :'™',
            '_glitter'                  :'(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧ⵥ',
            '_whocares'                 :'┐(￣ヮ￣)┌ⵥ',
            '_lolidc'                   :'╮ (. ❛ ᴗ ❛.) ╭ⵥ',
            '_dizzy'                    :'Σ(๛д๛)ⵥ',
            '_tableflip'                :'(╯ಠ_ರೃ)╯︵ ┻━┻ⵥ',
            '_TABLEFLIP'                :'‎(ﾉಥ益ಥ）ﾉ ┻━┻ⵥ',
            '_idcflip'                  :'┻━┻ ︵ ¯\ (ツ)/¯ ︵ ┻━┻ⵥ',
            '_ohno'                     :'(╯•﹏•╰)ⵥ',
            '_flattered'                :'(๑•́‧̫•̀๑)ⵥ',
            '_FLATTERED'                :'(๑ּగ⌄ּగ๑)ⵥ',
            '_dafuq'                    :'(≖︿≖✿)ⵥ',
            '_fightme?'                 :'(ง ͠° ͟ʖ ͡°)งⵥ',
            '_nofight'                  :'( ง ͡°╭ ͟ʖ╮͡° ) งⵥ',
            '_leftjab'                  :'(((c=(ﾟﾛﾟ;qⵥ',
            '_rightjab'                 :'(∩`ω´)⊃))ⵥ',
            '_yeah'                     :'(งಠل͜ಠ)งⵥ',
            '_YEAH'                     :'(ง ͡ʘ ͜ʖ ͡ʘ)งⵥ',
            '_shy'                      :'(´∩ω∩｀)ⵥ',
            '_hi'                       :'ヾ(｡･ω･｡)ⵥ',
            '_senpai!'                  :'ヾ(๑╹ヮ╹๑)ﾉ”ⵥ',
            '_senpai?'                  :'ヾ(๑ㆁᗜㆁ๑)ﾉ”ⵥ',
            '_noticeme'                 :'ヾ(Ő∀Ő๑)ﾉⵥ',
            '_SWAG'                     :'(*•̀ᴗ•́*)و ̑̑ⵥ',
            '_swag'                     :'(๑˃̵ᴗ˂̵)وⵥ',
            '_sorry'                    :'( •́ .̫ •̀ )ⵥ',
            '_bae'                      :'✾(〜 ☌ω☌)〜✾ⵥ',
            '_sparkly'                  :'˚✧₊⁎( ˘ω˘ )⁎⁺˳✧༚ⵥ',
            '_sigh'                     :'(︶ω︶)ⵥ',
            '_come'                     :'∩( ・ω・)∩ⵥ',
            '_kthen'                    :'(ㆁᴗㆁ✿)ⵥ',
            '_que'                      :'(✿╹◡╹)ⵥ',
            '_righto!'                  :'-(๑☆‿ ☆#)ᕗⵥ',
            '_amazing'                  :',､’`<(❛ヮ❛✿)>,､’`’`,､ⵥ',
            '_drugs1'                   :'☆(❁‿❁)☆ⵥ',
            '_drugs2'                   :'☆(◒‿◒)☆ⵥ',
            '_drugs3'                   :'(｡✿‿✿｡)ⵥ',
            '_drugs4'                   :'(◐ω◑ )ⵥ',
            '_charm'                    :'(✧≖‿ゝ≖)ⵥ',
            '_HURT'                     :'◝(๑⁺᷄д⁺᷅๑)◞՞ⵥ',
            '_idiot'                    :'ε-(≖д≖﹆)ⵥ',
            '_hurt?'                    :'( ´•̥̥̥ω•̥̥̥` )ⵥ',
            '_Flz'                      :'(◡‿◡✿)ⵥ',
            '_Frz'                      :'(✿◠‿◠)ⵥ',
            '_heh'                      :'（。≖ิ‿≖)ⵥ',
            '_snob'                     :'( ᵘ ᵕ ᵘ ⁎)ⵥ',
            '_smug'                     :'(≖ᴗ≖๑)ⵥ',
            '_SMUG'                     :'(。≖ˇ∀ˇ≖。)ⵥ',
            '_righto?'                  :'₍₍ (ง Ŏ౪Ŏ)ว ⁾⁾ⵥ',
            '_wow'                      :'(⊙ヮ⊙)ⵥ',
            '_nirvana'                  :'˚✧₊⁎( ˘ω˘ )⁎⁺˳✧༚ⵥ',
            '_omg'                      :'(⊙︿⊙✿)ⵥ',
            '_OMG'                      :'Σ(ﾟﾛﾟ｣)｣ⵥ',
            '_fuckthis'                 :'=͟͟͞͞٩(๑☉ᴗ☉)੭ु⁾⁾ⵥ',
            '_butful'                   :'(ʃƪ˘･ᴗ･˘)ⵥ',
            '_BUTFUL'                   :'(º̩̩́⌣º̩̩̀ʃƪ)ⵥ',
            '_dreamy'                   :'(´⌣`ʃƪ)ⵥ',
            '_DREAMY'                   :'(´▽`ʃƪ)ⵥ',
            '_giggle'                   :'(*≧艸≦)ⵥ',
            '_LOL'                      :'(*≧▽≦)ﾉｼ))ⵥ',
            '_huh?'                     :'⊙ω⊙ⵥ',
            '_HUH?'                     :'⊙▽⊙ⵥ',
            '_idk...'                   :'⚈້͈͡ ·̼̮ ⚈້͈͡ⵥ',
            '_idk?'                     :'( ؔ⚈͟ ◡ ؔ⚈͟ ๑)…ﾝ？ⵥ',
            '_karma'                    :'࿊',
            'mol'                       :'㏖',
            '_shock'                    :'（｀〇Д〇）ⵥ',
            '_umm'                      :'( ⚆ _ ⚆ )ⵥ',
            '_UMM'                      :'((⚆·̫⚆‧̣̥̇ ))ⵥ',
            '_thisguy'                  :'（；¬＿¬)ⵥ',
            '_THISGUY'                  :'(눈_눈)',
            '_pissed'                   :'(ᇂ∀ᇂ╬)ⵥ',
            '_PISSED'                   :'（╬ಠ益ಠ)ⵥ',
            '_OFFENDED'                 :'(╬ Ò ‸ Ó)ⵥ',
            '_RETARD'                   :'＼(´◓Д◔`)／ⵥ',
            '_tard'                     :'ヘ(゜Д、゜)ノⵥ',
            '_TARD'                     :'(⑅∫°ਊ°)∫ⵥ',
            '_retard'                   :'( ┐΄✹ਊ✹)┐ⵥ',
            '_fuckhide'                 :'┬┴┬┴┤д・´) ├┬┴┬┴　!!ⵥ',
            '_whatsgoingon'             :'┬┴┬┴┤  (･_├┬┴┬┴ⵥ',
            '_heardyouweretalkingshit'  :'┬┴┬┴┤･ω･｀)├┬┴┬┴ⵥ',
            '_ow'                       :'(ᗒᗩᗕ)՞ⵥ',
            '_panic'                    :'Σ੧(❛□❛✿)ⵥ',
            '_cute'                     :'٩(*ゝڡ◕๑)۶♥ⵥ',
            '_SPOOKYCRYING'             :'(༎ຶ ෴ ༎ຶ)',
            '_spookycrying'             :'( ´༎ຶㅂ༎ຶ`)ⵥ',
            '_dearOP1'                  :'＿φ( °-°)/ⵥ',
            '_dearOP2'                  :'＿φ(°-°= )ⵥ',
            '_dearOP3'                  :'＿φ(￣ー￣ )ⵥ',
            '_MrRobot'                  :'へ[ ᴼ ▃ ᴼ ]_/¯ⵥ',
            '_MyPrecious'               :'Σ(+Oдo;艸; )ⵥ',
            '_thirst'                   :'(ತ ൧͑ ತ)ⵥ',
            '_hurt...'                  :'(☍﹏⁰)｡ⵥ',
            '_sick'                     :'(;・ж;・;)ⵥ'}

    dic3 = {'rad'           :'㎭',
            '_fightme'      :'(๑و•̀ω•́)وⵥ',
            '_righto'       :'╭ (oㅇ‿ o#)ᕗⵥ',
            '_hurt'         :'ಥ‿ಥⵥ',
            'quarter'       :'¼',
            'half'          :'½',
            '3quarters'     :'¾',
            '_what?'          :'｢(ﾟ<ﾟ)ﾞ??ⵥ',
            'ffl'           :'ﬃ',
            'pts'           :'₧',
            'fax'           :'℻',
            'log'           :'㏒',
            'ulu'           :'ﬗ',
            'oloo'          :'‰'}
    
    dic2 = {'ae'            :'æ' ,
            '_spooky'       :'(((╹д╹;)))ⵥ',
            '_no'           :'(；￣Д￣）ⵥ',
            '_NO'           :'(ಠ ∩ಠ)ⵥ',
            'als'           :'⅍',
            "_:'("          :'｡ﾟ( ﾟஇ‸இﾟ+)ﾟ｡ⵥ',
            '_:('           :'(๑◕︵◕๑)ⵥ',
            '_^_^'          :'（　＾ω＾）ⵥ',
            '_r'            :'(｀・ω・´)”ⵥ',
            '_l'            :'(｡･ω･｡)ⵥ',
            '_f'            :'(^・ω・^ )ⵥ',
            '_Fl'           :'(◕‿◕✿)ⵥ',
            '_ur'           :'（＿´ω｀）ⵥ',
            '_dr'           :'(=^-ω-^= )ⵥ',
            '_Fr'           :'ヽ（◕◡◕❀ฺ ）ノⵥ',
            '_Wl'           :'(ó﹏ò｡)ⵥ',
            '_Wr'           :'(｡ŏ﹏ŏ)ⵥ',
            '_Wf'           :'(¤﹏¤)ⵥ',
            '_ok'           :'╭( ･ㅂ･)و ̑̑ ˂ᵒ͜͡ᵏᵎ⁾✩ⵥ',
            'io'            :'Ю',
            'ao'            :'ꜵ',
            'ia'            :'ꙗ',
            'am'            :'㏂',
            'male'          :'♂',
            'cal'           :'㎈',
            'clo'           :'℅',
            'ek'            :'Ꚅ',
            'dz'            :'ʣ',
            'ff'            :'ﬀ',
            'fl'            :'ﬂ',
            'fm'            :'㎙',
            'fn'            :'ʩ',
            'female'        :'♀',
            '_p'            :'҉',
            'ha'            :'㏊',
            'heart'         :'♥',
            'ka'            :'㎄',
            'lm'            :'㏐',
            'ls'            :'ʪ',
            'mm'            :'㎜',
            'ol'            :'ଶ',
            'ov'            :'㍵',
            'ns'            :'㎱',
            'no'            :'№',
            'oc'            :'⳪',
            'oo'            :'ꝏ',
            'oy'            :'ѹ',
            'pa'            :'㎀',
            'ps'            :'㎰',
            'ru'            :'ⴠ',
            'sr'            :'㏛',
            'st'            :'ﬆ',
            'ts'            :'ʦ',
            'ue'            :'ᵫ',
            'ug'            :'㎍',
            'un'            :'տ',
            '!!'            :'‼',
            '...'           :'…',
            'vi'            :'ⅵ'}

    dic1 = {'c'             :'ċ',
            'f'             :'ƒ',
            'g'             :'ġ',
            'h'             :'н',
            'i'             :'і',
            'j'             :'ʝ',
            'k'             :'к',
            'l'             :'l',
            'q'             :'q',
            'u'             :'ų',
            'v'             :'ν',
            'w'             :'ɯ',
            'x'             :'א',
            'z'             :'z',
            'I'             :'Ꮖ',
            'J'             :'Ꭻ',
            'S'             :'ꗟ',
            'L'             :'Ļ',
            'U'             :'∪',
            ' '             :' '}
        

    for Dic1, Dic2 in dic4.items():
        text = text.replace(Dic1,Dic2)
    for Dic1, Dic2 in dic3.items():
        text = text.replace(Dic1,Dic2)
    for Dic1, Dic2 in dic2.items():
        text = text.replace(Dic1,Dic2)
    for Dic1, Dic2 in dic1.items():
        text = text.replace(Dic1,Dic2)

    a = list('αᥠᥑ')
    b = list('ⲂᏰᏴ')
    d = list('ძᵭᶁḋ')
    e = list('ѐᥱ')
    H = list('ଐ')
    m = list('ᵯ₥')
    n = list('ȵɴᵰᶇᥰռ')
    o = list('σō')
    O = list('ⵁⴱⴲⵀⵕⵙⵚ')
    p = list('ꝐꝒⱣ')
    r = list('ŗṝṙɍ')
    R = list('ꞦɌⱤ')
    s = list('ṩꞩş')
    t = list('ṫṭ')
    S = list('ꚃꚂꗟ')
    y = list('ỵỷỿ')

    for line in text:

        if "ⵥ" in line:
            line = line.replace(line, "\r\n")
        if "a" in line:
            line = line.replace(line, choice(a))
        if "B" in line:
            line = line.replace(line, choice(b))
        if "d" in line:
            line = line.replace(line, choice(d))
        if 'e' in line:
            line = line.replace(line, choice(e))
        if "H" in line:
            line = line.replace(line, choice(H))
        if "m" in line:
            line = line.replace(line, choice(m))
        if "n" in line:
            line = line.replace(line, choice(n))
        if "o" in line:
            line = line.replace(line, choice(o))
        if "O" in line:
            line = line.replace(line, choice(O))
        if "p" in line:
            line = line.replace(line, choice(p))
        if "r" in line:
            line = line.replace(line, choice(r))
        if "R" in line:
            line = line.replace(line, choice(R))
        if "s" in line:
            line = line.replace(line, choice(s))
        if "S" in line:
            line = line.replace(line, choice(S))
        if "t" in line:
            line = line.replace(line, choice(t))
        if "y" in line:
            line = line.replace(line, choice(y))

        NewText += line

    text = NewText
    return text
print(RT3("The quick brown fox jumps over the lazy dog"))
