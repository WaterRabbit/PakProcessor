//
//  IniScene.h
//  PAK processor
//
//  Created by id on 12/1/13.
//  Copyright (c) 2013 id. All rights reserved.
//

#import "Ini.h"

#import "ScenarioBasic.h"
#import "ScenarioMap.h"
#import "ScenarioStructures.h"

@interface IniScene : Ini

@property ScenarioBasic *basic;

@property ScenarioMap *map;

@property ScenarioStructures *structures;


@property NSMutableDictionary *categories;


@property NSData *mapTiles;

//; Scenario 2 control for house Harkonnen.
//
//[BASIC]
//LosePicture=LOSTVEHC.WSA
//WinPicture=WIN2.WSA
//BriefPicture=HEADQRTS.WSA
//TimeOut=0
//MapScale=1
//CursorPos=2658
//TacticalPos=2331
//LoseFlags=5
//WinFlags=23
//
//[MAP]
//Field=2348
//Bloom=1188,2024,2390
//Seed=223
//
//[Harkonnen]
//Quota=2700
//Credits=1200
//Brain=Human
//MaxUnit=25
//
//[Atreides]
//Quota=0
//Credits=100
//Brain=CPU
//MaxUnit=25
//
//[TEAMS]
//1=Atreides,Normal,Foot,3,5
//2=Atreides,Normal,Foot,2,4
//3=Atreides,Normal,Foot,3,4
//4=Atreides,Normal,Foot,2,4
//5=Atreides,Normal,Foot,2,4
//
//[UNITS]
//
//ID022=Harkonnen,Quad,256,2912,64,Guard
//ID023=Harkonnen,Quad,256,2853,64,Guard
//ID024=Harkonnen,Trooper,256,2847,64,Guard
//ID025=Harkonnen,Quad,256,2727,64,Guard
//ID026=Harkonnen,Quad,256,2655,64,Guard
//ID027=Harkonnen,Trooper,256,2664,64,Guard
//ID028=Harkonnen,Trooper,256,2594,64,Guard
//ID029=Atreides,Infantry,256,1939,64,Area Guard
//ID030=Atreides,Infantry,256,1892,64,Ambush
//ID031=Atreides,Quad,256,1759,64,Area Guard
//ID033=Atreides,Trike,256,1691,64,Area Guard
//ID032=Atreides,Trike,256,1699,64,Area Guard
//ID036=Atreides,Trike,256,1625,64,Ambush
//ID035=Atreides,Infantry,256,1702,64,Ambush
//ID034=Atreides,Infantry,256,1694,64,Ambush
//ID037=Atreides,Trike,256,1574,64,Area Guard
//ID038=Atreides,Infantry,256,1498,64,Area Guard
//ID039=Atreides,Trike,256,1379,64,Ambush
//ID040=Atreides,Infantry,256,1376,64,Area Guard
//[STRUCTURES]
//GEN2992=Harkonnen,Concrete
//GEN1637=Atreides,Concrete
//GEN1636=Atreides,Concrete
//GEN1635=Atreides,Concrete
//GEN1630=Atreides,Concrete
//GEN1627=Atreides,Concrete
//GEN1573=Atreides,Concrete
//GEN1570=Atreides,Concrete
//GEN1563=Atreides,Concrete
//GEN1509=Atreides,Concrete
//GEN1506=Atreides,Concrete
//GEN1503=Atreides,Concrete
//GEN1499=Atreides,Concrete
//GEN1442=Atreides,Concrete
//GEN1439=Atreides,Concrete
//ID004=Atreides,Const Yard,256,1440
//ID003=Atreides,Windtrap,256,1692
//ID020=Atreides,Outpost,256,1633
//ID005=Atreides,Barracks,256,1507
//ID002=Atreides,Windtrap,256,1564
//ID001=Harkonnen,Const Yard,256,2658
//ID000=Atreides,Refinery,256,1436
//hhgd_ZUPQXYTW\]WXZ]`didcfimnlorkhgcgkmlklnnrxyupqsolprkdghedgiloqorxyxvrmlnjhhiihklkoollqnklopqsngjkha^_c`[`c^[^a`^^`ba]]bc`cjolqz~|unihb]XSPSX]`]^acddeddghfhmnljkiijgehjijjjqz}xy|}}wrsrpnlhbcgjiga^a\WZ[XY]__bhknmprrsurnllmnorrtxxwwy}~~||{unonkd_^XUVTUVUSUWXXX\\]cjkmonnsvstuvsstttxyvuwz{zy|}{vqrrngbceeaabbcffb__a__efbcdfiikidgjmlnqtspnnonklmqsstusssrpmkig`_ceb^]`b`agjmrwvuvusqpnjihfijloqsssromnnjgeb^ZVVVVWZ^bgjmpsttttsrspkjmnnnonnnptuuurnkmoqsohggeddfhhgihigdeebabaacbdghikoqrwzwxxywvvurokhgdcbcdefhjiijkkkkigheaadfeccedcdfijijgdejmrssvzxuuutpmkjjjkkjijjkmnmkknqqonoooppmmmljhiheeedgghlligghijhhgggfeegfeggdbbaadhknqtwwvwyxvtssqoonoqrstuvtrstqnlihea^_____^^a`__^\]^\Z[]_abceinqrqtwyz||zz{{{yxtttsrqrplkkjkjfeeedcdeffedcdeeccdbbabdgfffghhjnpqrtuuurqppolklomilnnoponnmmlklljhhhdccdgdadgiiijkkkllmoqqrrrrsusqpnmlkljhfedddccdeiiiijjhikjjlmmmnnlkmnmkjjighjmnnnmnnmklljiihikjjkjiijiiklkjklklopnnppppoonlklkjjkjiklmlklkjiheceeb`aca__bbacegjlmllmnnmopopstuuwxwwyywuttrqponlifedcccbbb`_`abbbdfhigghhgfffghhjklmnmmnppppqrsrstsrrqommkiiiiihhiiihihgffhhhhgegijijjkkjijijjjkkkklmoqpppopomlljhhgffefghiklmopqqstsrssrppnkiihggggghgghhghhhgeefggghhgfeddfhjihjklmlmooooopqrrrpponnmkjjjijkkihhiiiklkmnnmmnmmljhiihihikkkjklllmnmmmnmkkllkllkklkjjjigggecccdccdfgfefhjkkllllmmopomklmmmnoppoopqpooopponmlkijiijjjkllkkklllljiiihggggedddddfhijjklllkjjjjjjjklllmnmnnnmmmnooppnnnmmmmmmlllllllkkkkjihhihhggfddefgfedefgfghiiiijkkklmnnoooqqonnooonopponnnonnnoonllkkihhgfeeefgfefgghihhhiiijjjjiikkkllmnoopqppppooonmlkklkjijjiijkkkkjiiiigeefeghiijjkkkkkkkklkkkjjjkkkkkkklmnonnnnnmlllkkkkjjkjkklllmmlllkklllkjjjjjjkjjiihhgeeefeeeeffghiiijjkmnnnoppooonnnoooooponmnmlkjiiihggggfffeefghhijkkkllkkkkkllllmmmlmmnnnnonoonnnonnnnmllmmmmlkjihgggfedeeeeffgghhhijkkkkkllkllklllklmmmnnnnnnnooonnnmkjiihgghiiiijkkkjjkllllkkjiihhihhhiiiijjjjjjjjkkkkkkkklmmmnnnoooopponmlllllmmmmllllkkjjjiiiihhggfghhhghhhhhiiiiijjjkkllmnnnnnnoonnonnnnnmmllkkkjjjiiiiiiii


@end
