#include "component.hpp"

params ["_winCondition"];

INFO_1("Initialized wincondition %1.", _winName);

[{
    params ["_args","_handle"];
    _args params ["_condition","_winName"];

    if (call _condition) exitWith {
        [_winName] call grad_endings_fnc_endMissionServer;
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
}, 5, [_condition,_winName]] call CBA_fnc_addPerFrameHandler;
