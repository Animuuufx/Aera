// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//soundController

package 
{
    import flash.display.MovieClip;
    import flash.media.SoundChannel;
    import flash.media.Sound;
    import flash.media.SoundTransform;
    import flash.media.SoundMixer;

    public class soundController 
    {

        private var rootClass:MovieClip;
        private var bSong:Boolean;
        private var songOn:Boolean;
        public var mChannel:SoundChannel;
        private var btnSong:MovieClip;
        private var songClass:Sound;

        public function soundController(_arg_1:Sound, _arg_2:MovieClip)
        {
            rootClass = _arg_2;
            mChannel = new SoundChannel();
            mChannel.soundTransform = new SoundTransform(((_arg_2.litePreference.data.dOptions["iSoundMusic"] != null) ? _arg_2.litePreference.data.dOptions["iSoundMusic"] : 0.35));
            bSong = false;
            songClass = _arg_1;
            songOn = true;
        }

        public function checkSound(_arg_1:MovieClip=null):void
        {
            if (rootClass.mixer.bSoundOn)
            {
                if (songOn)
                {
                    if (!bSong)
                    {
                        mChannel = songClass.play(0, 9999, mChannel.soundTransform);
                        bSong = true;
                        if (_arg_1 != null)
                        {
                            _arg_1.txtMusic.text = "Music On";
                        };
                    };
                }
                else
                {
                    if (_arg_1 != null)
                    {
                        _arg_1.txtMusic.text = "Music Off";
                    };
                };
            }
            else
            {
                if (_arg_1 != null)
                {
                    _arg_1.txtMusic.text = "Music Off";
                };
            };
        }

        public function stopMusic(_arg_1:MovieClip=null):void
        {
            SoundMixer.stopAll();
            songOn = false;
            if (_arg_1 != null)
            {
                _arg_1.txtMusic.text = "Music Off";
            };
        }

        public function buttonClick(_arg_1:MovieClip):void
        {
            if (bSong)
            {
                SoundMixer.stopAll();
                songOn = false;
                _arg_1.txtMusic.text = "Music Off";
            }
            else
            {
                if (rootClass.mixer.bSoundOn)
                {
                    mChannel = songClass.play(0, 9999, mChannel.soundTransform);
                    songOn = true;
                    _arg_1.txtMusic.text = "Music On";
                };
            };
            bSong = (!(bSong));
        }


    }
}//package 

