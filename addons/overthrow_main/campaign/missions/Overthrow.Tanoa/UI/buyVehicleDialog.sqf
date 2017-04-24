private _town = player call OT_fnc_nearestTown;
_standing = player getVariable format['rep%1',_town];

private _items = OT_vehicles;

private _ob = (getpos player) call OT_fnc_nearestObjective;
_ob params ["_obpos","_obname"];
if(_obpos distance player < 250) then {
	if(_obname in (server getVariable ["NATOabandoned",[]])) then {
		_town = "Tanoa";
		_standing = 100;
		if((_obname in OT_allAirports) or OT_adminMode) then {
			_items = OT_helis + OT_vehicles + OT_staticBackpacks + [["Set_HMG"]];
		}else{
			_items = OT_vehicles + OT_boats + OT_staticBackpacks + [["Set_HMG"]];
		};
	}
};

if(OT_adminMode) then {
	_items = OT_helis + OT_vehicles + OT_boats + OT_staticBackpacks + [["Set_HMG"]];
};

createDialog "OT_dialog_buy";

{
	_cls = _x select 0;
	_price = 0;
	if !(_cls == "Set_HMG") then {
		_price = [_town,_cls,_standing] call OT_fnc_getPrice;
	};
	if("fuel depot" in (server getVariable "OT_NATOabandoned")) then {
		_price = round(_price * 0.5);
	};
	_name = "";
	_pic = "";
	if(_cls == "Set_HMG") then {
		_p = (cost getVariable "I_HMG_01_high_weapon_F") select 0;
		_p = _p + ((cost getVariable "I_HMG_01_support_high_F") select 0);
		private _quad = ((cost getVariable "C_Quadbike_01_F") select 0) + 60;
		_p = _p + _quad;
		_p = _p + 150; //Convenience cost
		_price = _p;
		_name = "Quad Bike w/ HMG Backpacks";
		_pic = "C_Quadbike_01_F" call ISSE_Cfg_Vehicle_GetPic;
	}else{
		_pic = _cls call ISSE_Cfg_Vehicle_GetPic;
		_name = _cls call ISSE_Cfg_Vehicle_GetName;
	};
	_idx = lbAdd [1500,format["%1",_name]];
	lbSetPicture [1500,_idx,_pic];
	lbSetData [1500,_idx,_cls];
	lbSetValue [1500,_idx,_price];
}foreach(_items);

_price = [_town,OT_item_UAV,_standing] call OT_fnc_getPrice;
_idx = lbAdd [1500,format["Quadcopter"]];
lbSetPicture [1500,_idx,OT_item_UAV call ISSE_Cfg_Vehicle_GetPic];
lbSetData [1500,_idx,OT_item_UAV];
lbSetValue [1500,_idx,_price];
