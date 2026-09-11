package
{
    import flash.display.MovieClip;

    /**
     * Link the FLA's regular NPC button MovieClip to this class:
     *     npcPanelButton
     *
     * DatabaseNPCPanel sets npcButtonData dynamically and fills the first
     * TextField in the symbol (or txtLabel/txtButton/buttonText if present).
     */
    dynamic public class npcPanelButton extends MovieClip
    {
        public var npcButtonData:Object;

        public function npcPanelButton()
        {
            super();
            stop();
        }
    }
}
