// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//SoundFX

package 
{
    import flash.events.EventDispatcher;
    import flash.system.ApplicationDomain;
    import flash.media.SoundTransform;

    public class SoundFX extends EventDispatcher 
    {

        private var sfx:Object = {};
        private var assetsDomain:ApplicationDomain;
        public var stf:SoundTransform = new SoundTransform(0.7, 0);
        public var bSoundOn:Boolean = true;

        public function SoundFX(_arg_1:ApplicationDomain)
        {
            this.assetsDomain = _arg_1;
            var _local_2:Array = ["Achievement", "Bad", "Click", "ClickBig", "ClickMagic", "Coins", "Energy", "Evil", "Fire", "Good", "Heal", "Hit1", "Hit2", "Hit3", "Miss", "VeryGood", "Water", "Wind"];
        }

        public function playSound(strSound:String):void
        {
            var AssetClass:Class;
            if (bSoundOn)
            {
                if (sfx[strSound] != null)
                {
                    sfx[strSound].play(0, 0, stf);
                }
                else
                {
                    try
                    {
                        if (assetsDomain.hasDefinition(strSound))
                        {
                            AssetClass = (assetsDomain.getDefinition(strSound) as Class);
                            sfx[strSound] = new (AssetClass)();
                            sfx[strSound].play(0, 0, stf);
                        };
                    }
                    catch(e:Error)
                    {
                    };
                };
            };
        }

        public function soundOn():void
        {
            bSoundOn = true;
        }

        public function soundOff():void
        {
            bSoundOn = false;
        }


    }
}//package 

