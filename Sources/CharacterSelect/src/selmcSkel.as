// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//selmcSkel

package 
{
    import flash.display.MovieClip;

    public class selmcSkel extends MovieClip 
    {

        public var idlefoot:MovieClip;
        public var chest:MovieClip;
        public var weaponOff:MovieClip;
        public var frontthigh:MovieClip;
        public var cape:MovieClip;
        public var frontshoulder:MovieClip;
        public var hitbox:MovieClip;
        public var head:MovieClip;
        public var backshoulder:MovieClip;
        public var hip:MovieClip;
        public var backthigh:MovieClip;
        public var backhair:MovieClip;
        public var backshin:MovieClip;
        public var weaponTemp:MovieClip;
        public var robe:MovieClip;
        public var weapon:MovieClip;
        public var frontshin:MovieClip;
        public var backfoot:MovieClip;
        public var backrobe:MovieClip;
        public var arrow:MovieClip;
        public var emoteFX:MovieClip;
        public var frontfoot:MovieClip;
        public var backhand:MovieClip;
        public var fronthand:MovieClip;
        public var animLoop:int;
        public var avtMC:MovieClip;
        internal var onMove:Boolean = false;

        public function selmcSkel()
        {
            addFrameScript(0, frame1, 7, frame8, 8, frame9, 16, frame17, 20, frame21, 27, frame28, 32, frame33, 40, frame41, 45, frame46, 53, frame54, 67, frame68, 68, frame69, 84, frame85, 85, frame86, 92, frame93, 98, frame99, 99, frame100, 116, frame117, 117, frame118, 130, frame131, 131, frame132, 155, frame156, 165, frame166, 166, frame167, 185, frame186, 186, frame187, 200, frame201, 209, frame210, 210, frame211, 244, frame245, 245, frame246, 261, frame262, 262, frame263, 271, frame272, 280, frame281, 288, frame289, 289, frame290, 309, frame310, 312, frame313, 313, frame314, 345, frame346, 346, frame347, 364, frame365, 366, frame367, 367, frame368, 392, frame393, 393, frame394, 457, frame458, 458, frame459, 475, frame476, 494, frame495, 502, frame503, 510, frame511, 511, frame512, 0x0200, frame513, 558, frame559, 559, frame560, 589, frame590, 590, frame591, 598, frame599, 599, frame600, 607, frame608, 620, frame621, 621, frame622, 632, frame633, 653, frame654, 677, frame678, 695, frame696, 702, frame703, 705, frame706, 721, frame722, 722, frame723, 725, frame726, 751, frame752, 752, frame753, 756, frame757, 780, frame781, 781, frame782, 785, frame786, 808, frame809, 809, frame810, 826, frame827, 827, frame828, 848, frame849, 849, frame850, 855, frame856, 856, frame857, 885, frame886, 886, frame887, 909, frame910, 910, frame911, 913, frame914, 930, frame931, 931, frame932, 934, frame935, 957, frame958, 958, frame959, 961, frame962, 983, frame984, 984, frame985, 987, frame988, 1001, frame1002, 1002, frame1003, 1013, frame1014, 1014, frame1015, 1017, frame1018, 1033, frame1034, 1034, frame1035, 1037, frame1038, 1048, frame1049, 1049, frame1050, 1070, frame1071, 1071, frame1072, 1082, frame1083, 1083, frame1084, 1087, frame1088, 1096, frame1097, 1097, frame1098, 1100, frame1101, 1111, frame1112, 1112, frame1113, 1121, frame1122, 1122, frame1123, 1126, frame1127, 1135, frame1136, 1136, frame1137, 1139, frame1140, 1150, frame1151, 1151, frame1152, 1162, frame1163, 1163, frame1164, 1166, frame1167, 1178, frame1179, 1179, frame1180, 1182, frame1183, 1191, frame1192, 1192, frame1193, 1203, frame1204, 1204, frame1205, 1207, frame1208, 1221, frame1222, 1222, frame1223, 1226, frame1227, 1243, frame1244, 1247, frame1248, 1253, frame1254, 1254, frame1255, 1257, frame1258, 1266, frame1267, 1267, frame1268, 1269, frame1270, 1283, frame1284, 1284, frame1285, 1295, frame1296, 1296, frame1297, 1297, frame1298, 1307, frame1308, 1319, frame1320, 1320, frame1321, 1339, frame1340, 1340, frame1341, 1354, frame1355, 1355, frame1356, 1370, frame1371, 1371, frame1372, 1404, frame1405, 1405, frame1406, 1442, frame1443, 1443, frame1444, 1451, frame1452, 1452, frame1453, 1524, frame1525, 1525, frame1526, 1562, frame1563, 1563, frame1564, 1578, frame1579, 1579, frame1580, 1588, frame1589, 1589, frame1590, 1620, frame1621, 1621, frame1622, 1624, frame1625, 1647, frame1648, 1648, frame1649, 1651, frame1652, 1673, frame1674, 1674, frame1675, 1690, frame1691, 1691, frame1692, 1704, frame1705, 1705, frame1706, 1724, frame1725, 1725, frame1726, 1766, frame1767, 1767, frame1768, 1781, frame1782, 1782, frame1783, 1794, frame1795, 1795, frame1796, 1818, frame1819);
        }

        public function emoteLoopFrame():int
        {
            var _local_1:int;
            while (_local_1 < currentLabels.length)
            {
                if (currentLabels[_local_1].name == currentLabel)
                {
                    return (currentLabels[_local_1].frame);
                };
                _local_1++;
            };
            return (8);
        }

        public function emoteLoop(_arg_1:int, _arg_2:Boolean=true):void
        {
            var _local_3:int = emoteLoopFrame();
            if (_local_3 > 8)
            {
                if (++animLoop < _arg_1)
                {
                    this.gotoAndPlay((_local_3 + 1));
                    return;
                };
            };
            if (_arg_2)
            {
                this.gotoAndPlay("Idle");
            };
        }

        public function showIdleFoot():*
        {
            frontfoot.visible = false;
            idlefoot.visible = true;
        }

        public function showFrontFoot():*
        {
            idlefoot.visible = false;
            frontfoot.visible = true;
        }

        public function endAction():*
        {
            this.gotoAndPlay("Idle");
        }

        internal function frame1():*
        {
            animLoop = 0;
            avtMC = null;
            gotoAndPlay("Idle");
        }

        internal function frame8():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
            stop();
        }

        internal function frame9():*
        {
            gotoAndStop("Idle");
        }

        internal function frame17():*
        {
            showFrontFoot();
            cape.cape.gotoAndPlay("Move");
        }

        internal function frame21():*
        {
            if (this.onMove)
            {
                gotoAndPlay("mountWalk");
            };
        }

        internal function frame28():*
        {
            showFrontFoot();
            cape.cape.gotoAndPlay("Move");
        }

        internal function frame33():*
        {
            if (this.onMove)
            {
                gotoAndPlay("horseWalk");
            };
        }

        internal function frame41():*
        {
            showFrontFoot();
            cape.cape.gotoAndPlay("Move");
        }

        internal function frame46():*
        {
            if (this.onMove)
            {
                gotoAndPlay("throneWalk");
            };
        }

        internal function frame54():*
        {
            showFrontFoot();
            cape.cape.gotoAndPlay("Move");
        }

        internal function frame68():*
        {
            if (this.onMove)
            {
                gotoAndPlay("Walk");
            };
        }

        internal function frame69():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame85():*
        {
            gotoAndPlay("Dance");
        }

        internal function frame86():*
        {
            animLoop = 0;
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame93():*
        {
            emoteLoop(3, false);
        }

        internal function frame99():*
        {
            stop();
        }

        internal function frame100():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame117():*
        {
            stop();
        }

        internal function frame118():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame131():*
        {
            gotoAndPlay("Use");
        }

        internal function frame132():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame156():*
        {
            emoteLoop(3, false);
        }

        internal function frame166():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame167():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame186():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame187():*
        {
            animLoop = 0;
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame201():*
        {
            emoteLoop(3, false);
        }

        internal function frame210():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame211():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame245():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame246():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame262():*
        {
            gotoAndPlay("Airguitar");
        }

        internal function frame263():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame272():*
        {
            showFrontFoot();
        }

        internal function frame281():*
        {
            showIdleFoot();
        }

        internal function frame289():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame290():*
        {
            showFrontFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame310():*
        {
            if (this.scaleX < 0)
            {
                emoteFX.scaleX = (emoteFX.scaleX * -1);
            };
        }

        internal function frame313():*
        {
            stop();
        }

        internal function frame314():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame346():*
        {
            if (this.onMove)
            {
                gotoAndPlay("Walk");
            };
            stop();
        }

        internal function frame347():*
        {
            showFrontFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame365():*
        {
            showIdleFoot();
        }

        internal function frame367():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame368():*
        {
            showFrontFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame393():*
        {
            gotoAndPlay("Dance2");
        }

        internal function frame394():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame458():*
        {
            gotoAndPlay("Swordplay");
        }

        internal function frame459():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame476():*
        {
            showFrontFoot();
        }

        internal function frame495():*
        {
            stop();
        }

        internal function frame503():*
        {
            animLoop = 0;
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame511():*
        {
            emoteLoop(3);
        }

        internal function frame512():*
        {
            stop();
        }

        internal function frame513():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame559():*
        {
            stop();
        }

        internal function frame560():*
        {
            showFrontFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame590():*
        {
            stop();
        }

        internal function frame591():*
        {
            animLoop = 0;
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame599():*
        {
            emoteLoop(3);
        }

        internal function frame600():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame608():*
        {
            weapon.visible = true;
        }

        internal function frame621():*
        {
            stop();
        }

        internal function frame622():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame633():*
        {
            stop();
        }

        internal function frame654():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame678():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame696():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame703():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame706():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame722():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame723():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame726():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame752():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame753():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame757():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame781():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame782():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame786():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame809():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame810():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame827():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame828():*
        {
            showFrontFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame849():*
        {
            stop();
        }

        internal function frame850():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame856():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame857():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame886():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame887():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame910():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame911():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame914():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame931():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame932():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame935():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame958():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame959():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame962():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame984():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame985():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame988():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1002():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1003():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1014():*
        {
            stop();
        }

        internal function frame1015():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1018():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1034():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1035():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1038():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1049():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1050():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1071():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1072():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1083():*
        {
            stop();
        }

        internal function frame1084():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1088():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1097():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1098():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1101():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1112():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1113():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1122():*
        {
            stop();
        }

        internal function frame1123():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1127():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1136():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1137():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1140():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1151():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1152():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1163():*
        {
            stop();
        }

        internal function frame1164():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1167():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1179():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1180():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1183():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1192():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1193():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1204():*
        {
            stop();
        }

        internal function frame1205():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
            avtMC = MovieClip(parent);
        }

        internal function frame1208():*
        {
            if ((((!(avtMC.spFX.strl == null)) && (!(avtMC.spFX.strl == ""))) && (!(avtMC.spFX.avts == null))))
            {
                MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null);
            };
        }

        internal function frame1222():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1223():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
            avtMC = MovieClip(parent);
        }

        internal function frame1227():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1244():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1248():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1254():*
        {
            stop();
        }

        internal function frame1255():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1258():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1267():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1268():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1270():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null, avtMC.spellDur);
            avtMC.spellDur = 0;
        }

        internal function frame1284():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1285():*
        {
            showFrontFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1296():*
        {
            showIdleFoot();
        }

        internal function frame1297():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1298():*
        {
            showFrontFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1308():*
        {
            showIdleFoot();
        }

        internal function frame1320():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1321():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1340():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1341():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1355():*
        {
            stop();
        }

        internal function frame1356():*
        {
            showFrontFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1371():*
        {
            stop();
        }

        internal function frame1372():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1405():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1406():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1443():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1444():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1452():*
        {
            gotoAndPlay("Cry2");
        }

        internal function frame1453():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1525():*
        {
            gotoAndPlay("Spar");
        }

        internal function frame1526():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1563():*
        {
            gotoAndPlay("Samba");
        }

        internal function frame1564():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1579():*
        {
            gotoAndPlay("Stepdance");
        }

        internal function frame1580():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1589():*
        {
            gotoAndPlay("Headbang");
        }

        internal function frame1590():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1621():*
        {
            gotoAndPlay("Dazed");
        }

        internal function frame1622():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1625():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null);
        }

        internal function frame1648():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1649():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1652():*
        {
            avtMC = MovieClip(parent);
            MovieClip(avtMC.parent.parent).castSpellFX(avtMC.pAV, avtMC.spFX, null);
        }

        internal function frame1674():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1675():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1691():*
        {
            gotoAndPlay("Danceweapon");
        }

        internal function frame1692():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1705():*
        {
            gotoAndPlay("Useweapon");
        }

        internal function frame1706():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1725():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1726():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1767():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1768():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1782():*
        {
            MovieClip(parent).endAction();
        }

        internal function frame1783():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1795():*
        {
            stop();
        }

        internal function frame1796():*
        {
            showIdleFoot();
            cape.cape.gotoAndStop("Idle");
        }

        internal function frame1819():*
        {
            MovieClip(parent).endAction();
        }


    }
}//package 

