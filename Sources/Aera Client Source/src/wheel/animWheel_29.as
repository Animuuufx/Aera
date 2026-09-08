package wheel
{

    import flash.display.MovieClip;

    public dynamic class animWheel_29 extends MovieClip 
    {

        public var game:Game = Game.root;

        public function animWheel_29()
        {
            addFrameScript(0, frame1, 40, frame41, 74, frame75, 108, frame109, 142, frame143, 175, frame176, 209, frame210, 243, frame244, 277, frame278);
        }

        internal function frame1() : void
        {
            stop();
        }

        private function frame41() : void
        {
            game.mixer.playSound("ClickMagic");
            stop();
        }

        private function frame75() : void
        {
            game.mixer.playSound("ClickMagic");
            stop();
        }

        private function frame109() : void
        {
            game.mixer.playSound("ClickMagic");
            stop();
        }

        private function frame143(): void
        {
            game.mixer.playSound("ClickMagic");
            stop();
        }

        private function frame176() : void
        {
            game.mixer.playSound("Achievement");
            stop();
        }

        private function frame210() : void
        {
            game.mixer.playSound("ClickMagic");
            stop();
        }

        private function frame244() : void
        {
            game.mixer.playSound("ClickMagic");
            stop();
        }

        private function frame278() : void
        {
            game.mixer.playSound("ClickMagic");
            stop();
        }


    }
}//package town_fla

