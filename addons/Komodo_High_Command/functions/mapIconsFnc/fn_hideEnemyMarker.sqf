params["_hide", ["_group",objnull]];

_hideGroupIcon = {
    private _g = _this select 0;
    _g setVariable ["PL_group_icons", (getGroupIcons _g)];
    _g setVariable ["MARTA_customicon", ["dummy"]];
    _g setGroupIcon[1, "dummy", [0,0,0,0]];
    _g setGroupIcon[2, "dummy", [0,0,0,0]];
    sleep 0.2;
    _g setGroupIcon[1, "dummy", [0,0,0,0]];
    _g setGroupIcon[2, "dummy", [0,0,0,0]];
};

_restoreGroupIcon = {
    private _g = _this select 0;
    _g setVariable ["MARTA_customicon", nil];
    private _icons = _g getVariable ["PL_group_icons", []];
    {
        _g setGroupIcon _x;
    } forEach _icons;
};


if(!isNull(_group)) then {
    if(_hide) then {
        [_group] spawn _hideGroupIcon;
    } else {
        [_group] call _restoreGroupIcon;
    };
} else {
    {
        if(_hide) then {
            [_x] spawn _hideGroupIcon;
        } else {
            [_x] call _restoreGroupIcon;

        };
    } foreach (allGroups select { [side player, side _x] call BIS_fnc_sideIsEnemy });
};