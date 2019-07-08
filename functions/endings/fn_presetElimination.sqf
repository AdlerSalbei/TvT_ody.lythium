#include "component.hpp"

params ["_winName", "_sides", ["_isRecursion", false], ["_taskID", "taskElimination"]];


if (!_isRecursion) then {
    _sides = _sides apply {call compile _x};

    private _winners = [missionConfigFile >> "CfgWinConditions" >> _winName, "winners", []] call BIS_fnc_returnConfigEntry;
    _winners = _winners apply {call compile _x};

    //CREATE TASK ==================================================================
    {_taskID = _taskID + "_w" + str _x} forEach _winners;
    {_taskID = _taskID + "_l" + str _x} forEach _sides;

    _taskDesc = format ["Eliminate all players of side %1", [_sides select 0] call grad_common_fnc_getSideDisplayName];
    {
        if (_forEachIndex > 0) then {
            _taskDesc = _taskDesc + "and " + ([_x] call grad_common_fnc_getSideDisplayName);
        };
    } forEach _sides;
    _taskDesc = _taskDesc + ".";

    [_taskID, _winners, [_taskDesc, "Eliminate Enemies", ""], objNull, "AUTOASSIGNED", 3, true, true, "kill"] call BIS_fnc_setTask;
};

//PFH ==========================================================================
private _fnc_check = {
    {(side _x) in _sides} count playableUnits == 0
};

[{
    params ["_args", "_handle"];
    _args params ["_winName", "_sides", "_taskID", "_fnc_check"];

    if (call _fnc_check) exitWith {

        [{
            params ["_winName", "_sides", "_taskID", "_fnc_check"];
            if (call _fnc_check) then {

                [_taskID,"SUCCEEDED",true] call BIS_fnc_taskSetState;
                [_winName] call grad_endings_fnc_endMissionServer;
            } else {
                [_winName, _sides, true, _taskID] call grad_endings_fnc_presetElimination;
            };
        }, [_winName, _sides, _taskID, _fnc_check], 10] call CBA_fnc_waitAndExecute;

        [_handle] call CBA_fnc_removePerFrameHandler;
    };
}, 10, [_winName, _sides, _taskID, _fnc_check]] call CBA_fnc_addPerFrameHandler;
