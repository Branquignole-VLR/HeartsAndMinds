params ["_pos", "_range", ["_units", []]];

if (_units isEqualTo []) then {
    _units = _pos nearEntities [btc_civ_type_units, _range];
};

_units = _units select {side _x isEqualTo civilian};
[[_units,_units apply {format ["amovp%1mstpsnonwnondnon", ((animationState _x) select [5, 3])]}], {
    {
        _x switchMove (_this select 1 select _forEachIndex);
    } forEach (_this select 0);
}] remoteExec ["call", 0, false];

{
    if (btc_debug_log) then {
        [format ["%1 - %2", _x, side _x], __FILE__, [false]] call btc_fnc_debug_message;
    };

    _x call btc_fnc_rep_remove_eh;

    [_x] call btc_fnc_civ_add_weapons;

    [_x] joinSilent createGroup [btc_enemy_side, true];

    (group _x) setVariable ["getWeapons", true];

    (group _x) setBehaviour "AWARE";
    [group _x, getPos _x, 10, "GUARD", "UNCHANGED", "RED"] call CBA_fnc_addWaypoint;
} forEach _units;
