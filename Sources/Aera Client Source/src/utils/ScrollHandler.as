package utils {

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class ScrollHandler extends MovieClip {

    public var _mask:MovieClip;
    public var _lists:MovieClip;
    public var _scr:MovieClip;
    public var _maxY:int;
    public var _mDown:Boolean = false;
    public var _offSetY:int;

    public function ScrollHandler(listMask:MovieClip, lists:MovieClip, scr:MovieClip, maxY:int = 176, offSetY:int = 0)
    {
        _mask = listMask;
        _lists = lists;
        _scr = scr;
        _maxY = maxY;
        _offSetY = offSetY;
    }

    public function reset() : void
    {
        _scr.h.y = 0;
        _lists.y = (_mask.y + (_scr.h.y * ((_mask.height - _lists.height) / _maxY)));
    }

    public function open() : void
    {
        reset();

        if (_lists.height < _mask.height) {
            _scr.alpha = 0;
        } else {
            _scr.alpha = 1;
            _scr.hit.alpha = 0;

            _scr.hit.addEventListener(MouseEvent.MOUSE_DOWN, btnHold, false, 0, true);
            _scr.addEventListener(Event.ENTER_FRAME, onChange, false, 0, true);
            _lists.addEventListener(MouseEvent.MOUSE_WHEEL, onScroll, false, 0, true);
        }
    }

    public function close() : void
    {
        _scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN, btnHold);
        _scr.removeEventListener(Event.ENTER_FRAME, onChange);
        _lists.removeEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
    }

    private function btnHold(e:MouseEvent) : void {
        _mDown = true;
        Game.root.addEventListener(MouseEvent.MOUSE_UP, this.btnRelease, false, 0, true);
    }

    private function btnRelease(e:MouseEvent) : void {
        _mDown = false;
        Game.root.removeEventListener(MouseEvent.MOUSE_UP, this.btnRelease);
    }

    private function onChange(e:Event) : void {
        if (!_mDown || _lists.height < _mask.height) return;

        var point:Point = new Point(Game.root.mouseX, Game.root.mouseY);

        _scr.h.y = _scr.globalToLocal(point).y;

        if (_scr.h.y <= 0) {
            _scr.h.y = 0;
        }

        if (_scr.h.y >= _maxY) {
            _scr.h.y = _maxY;
        }

        _lists.y = (_mask.y + (_scr.h.y * ((_mask.height - _lists.height) / _maxY))) + _offSetY;
    }

    private function onScroll(e:MouseEvent) : void {
        if (_lists.height < _mask.height) return;

        e.delta = (e.delta * 6);
        _lists.y = (_lists.y + e.delta);

        if (_lists.y >= _mask.y) {
            _lists.y = _mask.y;
        }

        if (_lists.y <= (_mask.y + (_mask.height - _lists.height))) {
            _lists.y = (_mask.y + (_mask.height - _lists.height));
        }

        _scr.h.y = ((_lists.y - _mask.y) / ((_mask.height - _lists.height) / _maxY));
    }

}

}
