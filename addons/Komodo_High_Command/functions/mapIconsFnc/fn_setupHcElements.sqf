if (synchronizedObjects player findIf {typeOf _x == "HighCommand"} == -1) then {
	_group = createGroup sideLogic; 
	_HighCommand = _group createUnit ["HighCommand", [0, 0, 0], [], 0, "NONE"];
	_HighCommandSubordinate = _group createUnit ["HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"];
	_HighCommand synchronizeObjectsAdd [_HighCommandSubordinate, player];
} else {
    player hcRemoveGroup (group player);
};

setGroupIconsVisible[true, false];

if(pl_hide_enemy_3d_icons) then {
    [true] call KMD_fnc_hideEnemyMarker;
};

addMissionEventHandler ["Map", {
    params ["_mapIsOpened", "_mapIsForced"];
    if(pl_hide_enemy_3d_icons) then {    
        [!_mapIsOpened] call KMD_fnc_hideEnemyMarker;
    };
}];

addMissionEventHandler ["TeamSwitch", {
	params ["_previousUnit", "_newUnit"];

    _index = synchronizedObjects _previousUnit findIf {typeOf _x == "HighCommand"};
    if( _index >= 0 ) then {
        "The old unit had a hc command, setting up for the new unit" call KMD_fnc_debug;
        if (synchronizedObjects player findIf {typeOf _x == "HighCommand"} == -1) then {
            _group = createGroup sideLogic; 
            _HighCommand = _group createUnit ["HighCommand", [0, 0, 0], [], 0, "NONE"];
            _HighCommandSubordinate = _group createUnit ["HighCommandSubordinate", [0, 0, 0], [], 0, "NONE"];
            _HighCommand synchronizeObjectsAdd [_HighCommandSubordinate, _newUnit];
        };
    };

    {        
        _previousUnit hcRemoveGroup _x;
        if(_x != group _newUnit) then {
            _newUnit hcSetGroup [_x];
        };
    } forEach hcAllGroups _previousUnit;

    _group = group _previousUnit;
    _newUnit hcSetGroup [_group];
    _previousUnit enableAI "TEAMSWITCH";
    [_group] spawn KMD_fnc_reset;
    [_group] spawn KMD_fnc_setupAi;
    if(!isNull(_group)) then {
         _group setVariable ["MARTA_customicon", nil];
    };

    (group _newUnit) setVariable ["pl_show_info", false];
    if(pl_hide_player_hq_marker) then {
        call KMD_fnc_hidePlayerHqMarkerChanged;
    };

    setGroupIconsVisible[true, false];
}];

// need to wait everything is initialized after adding a group to hc to setting up the ongroupicon event handler
waituntil { 
    sleep 0.5;
    !isNil { player getvariable "BIS_HC_scope" } && !isNil { (player getvariable "BIS_HC_scope")getVariable "GUI_WP_GETIN" }
};
sleep 0.5;
"Setting up stuff after HC is initalized" call KMD_fnc_debug;
if(pl_hide_player_hq_marker) then {
    call KMD_fnc_hidePlayerHqMarkerChanged;
};
// disable Pointless Toltip
onGroupIconOverEnter {scriptname "HC: onGroupIconOverEnter";

    if !(hcshownbar) exitwith {};

    _is3D = _this select 0;
	_group = _this select 1;
	_wpID = _this select 2;
	_posx = _this select 3;
	_posy = _this select 4;
	_logic = player getvariable "BIS_HC_scope";

    if (_wpID < 0) then {
        _logic setvariable ["groupover",_group];
        _logic setvariable ["wpover",[grpnull]];
    } else {
        if (_group in hcallgroups player && !(_logic getvariable "LMB_hold")) then {
            _logic setvariable ["groupover",grpnull];
            _logic setvariable ["wpover",[_group,_wpID]];
        };
    };
};

