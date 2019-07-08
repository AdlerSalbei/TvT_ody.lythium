#include "component.hpp"

[{missionNamespace getVariable ["REPLAY_FINISHED", false]},{
    params [["_winners", []]];

    ["end1", playerSide in _winners, true, true, true] spawn BIS_fnc_endMission;
}, _this] call CBA_fnc_waitUntilAndExecute;
