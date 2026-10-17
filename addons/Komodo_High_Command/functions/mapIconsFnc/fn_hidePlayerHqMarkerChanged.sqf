if(pl_hide_player_hq_marker) then {
    (group player) setVariable ["MARTA_customicon", ["dummy"]];
    (group player) setGroupIcon[2, "dummy", [0,0,0,0]];
} else {
    _sideId = [east,west,resistance,civilian] find (side player);
    _type = ["o_hq","b_hq","n_hq","n_hq"] select _sideId;
    (group player) setvariable ["MARTA_customicon",[_type],true];
};