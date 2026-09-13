// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//RandomNumber

package 
{
    public class RandomNumber 
    {

        internal const MAX_RATIO:Number = 4.6566128752458E-10;
        internal const NEGA_MAX_RATIO:Number = -(MAX_RATIO);

        private var r:int = (Math.random() * int.MAX_VALUE);
        private var randNum:Number;


        public function rand(_arg_1:Number=0, _arg_2:Number=1):Number
        {
            randNum = ((XORandom() * (_arg_2 - _arg_1)) + _arg_1);
            return ((randNum < _arg_2) ? randNum : _arg_2);
        }

        private function XORandom():Number
        {
            r = (r ^ (r << 21));
            r = (r ^ (r >>> 35));
            r = (r ^ (r << 4));
            if (r > 0)
            {
                return (r * MAX_RATIO);
            };
            return (r * NEGA_MAX_RATIO);
        }

        public function newSeed():void
        {
            r = (Math.random() * int.MAX_VALUE);
        }


    }
}//package 

