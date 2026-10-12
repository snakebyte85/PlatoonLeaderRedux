/*
Original name: pl_remove_from_hc
New name:      KMD_fnc_removeFromHC
Original url: "Plmod\pl_group_fnc.sqf"
*/
    params ["_group"];
    player hcRemoveGroup _group;
    //TODO: remove everything related to PL
    _group setVariable ["pl_show_info", false];