
call compile preprocessFileLineNumbers "core\doc.sqf";

[{!isNull player}, {

    player addRating 9999;
    btc_player_respawn = getPosASL player;
    ["InitializePlayer", [player]] call BIS_fnc_dynamicGroups;

    player addEventHandler ["Respawn", btc_fnc_eh_player_respawn];
    player addEventHandler ["CuratorObjectPlaced", btc_fnc_eh_CuratorObjectPlaced];
    ["ace_treatmentSucceded", btc_fnc_eh_treatment] call CBA_fnc_addEventHandler;
    player addEventHandler ["WeaponAssembled", btc_fnc_civ_add_leaflets];

    call btc_fnc_int_add_actions;
    call btc_fnc_int_shortcuts;

    if (player getVariable ["interpreter", false]) then {player createDiarySubject [localize "STR_BTC_HAM_CON_INFO_ASKHIDEOUT_DIARYLOG", localize "STR_BTC_HAM_CON_INFO_ASKHIDEOUT_DIARYLOG"];};

    removeAllWeapons player;

    if !(btc_p_arsenal_Restrict isEqualTo 0) then {call btc_fnc_log_arsenalData;};

    [{scriptDone btc_intro_done}, {
        {[_x] call btc_fnc_task_create} foreach ((player call BIS_fnc_tasksUnit) select {[_x] call BIS_fnc_taskState isEqualTo "ASSIGNED"});
    }] call CBA_fnc_waitUntilAndExecute;
}] call CBA_fnc_waitUntilAndExecute;

if (btc_debug) then {

    onMapSingleClick "if (vehicle player == player) then {player setpos _pos} else {vehicle player setpos _pos}";
    player allowDamage false;

    waitUntil {!isNull (findDisplay 12)};
    private _eh = ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", btc_fnc_marker_debug];

    btc_marker_debug_cond = true;
    [_eh] spawn btc_fnc_systemchat_debug;
};
