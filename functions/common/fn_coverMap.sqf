#include "component.hpp"

params ["_logic"];

if (!isServer) exitWith {};
if !(_logic isKindOf "LocationArea_F") exitWith {ERROR_1("%1 is not an area logic.",_logic)};

//--- get area dimensions
private _pos = position _logic;
private _area = [0,0,0];

{
	_pos = position _x;
	_area = triggerarea _x;
} foreach (_logic call bis_fnc_moduleTriggers);

_pos params ["_posX", "_posY"];
_area params ["_sizeX", "_sizeY", "_dir"];

_sizeOut = 100000;


//--- create markers
for "_i" from 0 to 270 step 90 do {
	private _size1 = [_sizeX, _sizeY] select (abs cos _i);
	private _size2 = [_sizeX, _sizeY] select (abs sin _i);
	private _sizeMarker = [_size2, _sizeOut] select (abs sin _i);
	private _dirTemp = _dir + _i;
	private _markerPos = [
		_posX + (sin _dirTemp * _sizeOut),
		_posY + (cos _dirTemp * _sizeOut)
	];

	private _marker = format ["bis_fnc_moduleCoverMap_%1",_i];
	createmarker [_marker,_markerPos];
	_marker setmarkerpos _markerPos;
	_marker setmarkersize [_sizeMarker,_sizeOut - _size1];
	_marker setmarkerdir _dirTemp;
	_marker setmarkershape "rectangle";
	_marker setmarkerbrush "solid";
	_marker setmarkercolor "colorBlack";


	_markerPos = [
		_posX + (sin _dirTemp * _size1) + (sin (_dirTemp + 90) * _size2),
		_posY + (cos _dirTemp * _size1) + (cos (_dirTemp + 90) * _size2)
	];
	_marker = format ["bis_fnc_moduleCoverMap_dot_%1",_i];
	createmarker [_marker,_markerPos];
	_marker setmarkerpos _markerPos;
	_marker setmarkersize [0.75,0.75];
	_marker setmarkerdir _dir;
	_marker setmarkertype "mil_box_noShadow";
	_marker setmarkercolor "colorBlack";
};

//--- Frame
private _marker = "bis_fnc_moduleCoverMap_border";
createmarker [_marker,_pos];
_marker setmarkerpos _pos;
_marker setmarkersize [_sizeX,_sizeY];
_marker setmarkerdir _dir;
_marker setmarkershape "rectangle";
_marker setmarkerbrush "border";
_marker setmarkercolor "colorblack";
