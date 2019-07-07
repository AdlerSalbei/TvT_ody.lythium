#include "component.hpp"

params ["_area"];

[{
    params ["_area","_handle"];

    if (alive player && {!(player inArea _area)}) exitWith {
        ["grad_notification1", ["MELDUNG", "Zurück in die Spielzone!"]] call bis_fnc_showNotification;

        private _waitTime = if ((vehicle player) isKindOf "Air") then {40} else {12};

        [
            {
                player inArea _this
            },
            {

                ["grad_notification1",["MELDUNG", "Du bist zurück in der Spielzone."]] call bis_fnc_showNotification;
                [_this] call grad_common_fnc_restrictZonePFH;
            },
            _area,
            _waitTime,
            {
                player setDamage 1;
            }
        ] call CBA_fnc_waitAndExecute;

        [_handle] call CBA_fnc_removePerFrameHandler;
    };
}, 8, _area] call CBA_fnc_addPerFrameHandler;
