// Decompiled by AS3 Sorcerer 6.20
// www.as3sorcerer.com

//selBtnChar

package 
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.text.TextField;

    public dynamic class selBtnChar extends MovieClip 
    {

        public var btnSelectCharacter:SimpleButton;
        public var txtName:TextField;
        public var btnRemoveCharacter:SimpleButton;

        public function selBtnChar()
        {
            __setTab_btnSelectCharacter_playerbtn_Layer1_0();
            __setTab_btnRemoveCharacter_playerbtn_Layer1_0();
        }

        internal function __setTab_btnSelectCharacter_playerbtn_Layer1_0():*
        {
            btnSelectCharacter.tabIndex = 3;
        }

        internal function __setTab_btnRemoveCharacter_playerbtn_Layer1_0():*
        {
            btnRemoveCharacter.tabIndex = 3;
        }


    }
}//package 

