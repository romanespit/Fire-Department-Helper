script_name("FireDeptHelper")
script_authors("romanespit")
script_description("Script for Fire Department.")
script_version("1.3.0-hotfix")
script_properties("work-in-pause")
setver = 1
 
require "lib.sampfuncs"
require "lib.moonloader"
local mem = require "memory"
local vkeys = require "vkeys"
local encoding = require "encoding"
encoding.default = "CP1251"
local u8 = encoding.UTF8
local dlstatus = require("moonloader").download_status
local SCRIPT_COLOR = 0xFFE5911A
local COLOR_MAIN = "{E5911A}"
local COLOR_SECONDARY = "{1AE591}"
local COLOR_WHITE = "{FFFFFF}"
local SCRIPT_PREFIX = COLOR_WHITE.."["..COLOR_MAIN.."FDHelper"..COLOR_WHITE.."]: "
local newversion = ""
local newdate = ""
local spawnCars = false
 
local sampfuncsNot = [[
 Íå îáíàðóæåí ôàéë SAMPFUNCS.asi â ïàïêå èãðû, âñëåäñòâèå ÷åãî
ñêðèïòó íå óäàëîñü çàïóñòèòüñÿ.

		Äëÿ ðåøåíèÿ ïðîáëåìû:
1. Çàêðîéòå èãðó;
2. Çàéäèòå âî âêëàäêó "Ìîäû" â ëàóí÷åðå Àðèçîíû.
Íàéäèòå âî âêëàäêå "Ìîäû" óñòàíîâùèê "Moonloader" è íàæìèòå êíîïêó "Óñòàíîâèòü".
Ïîñëå çàâåðøåíèÿ óñòàíîâêè âíîâü çàïóñòèòå èãðó. Ïðîáëåìà èñ÷åçíåò.

Ïî ïðîáëåìàì çàâîäèòå issue íà GitHub. Ññûëêà åñòü íà âêëàäêå: Î ñêðèïòå

Èãðà áûëà ñâåðíóòà, ïîýòîìó ìîæåòå ïðîäîëæèòü èãðàòü. 
]]

local errorText = [[
		  Âíèìàíèå! 
Íå îáíàðóæåíû íåêîòîðûå âàæíûå ôàéëû äëÿ ðàáîòû ñêðèïòà.
Â ñëåäñòâèè ÷åãî, ñêðèïò ïåðåñòàë ðàáîòàòü.
	Ñïèñîê íåîáíàðóæåííûõ ôàéëîâ:
		%s

		Äëÿ ðåøåíèÿ ïðîáëåìû:
1. Çàêðîéòå èãðó;
2. Çàéäèòå âî âêëàäêó "Ìîäû" â ëàóí÷åðå Àðèçîíû.
Íàéäèòå âî âêëàäêå "Ìîäû" óñòàíîâùèê "Moonloader" è íàæìèòå êíîïêó "Óñòàíîâèòü".
Ïîñëå çàâåðøåíèÿ óñòàíîâêè âíîâü çàïóñòèòå èãðó. Ïðîáëåìà èñ÷åçíåò.

Ïî ïðîáëåìàì çàâîäèòå issue íà GitHub. Ññûëêà åñòü íà âêëàäêå: Î ñêðèïòå

Èãðà áûëà ñâåðíóòà, ïîýòîìó ìîæåòå ïðîäîëæèòü èãðàòü. 
]]

local files = {
"/lib/imgui.lua",
"/lib/samp/events.lua",
"/lib/rkeysFD.lua",
"/lib/faIcons.lua",
"/lib/crc32ffi.lua",
"/lib/bitex.lua",
"/lib/MoonImGui.dll",
"/lib/matrix3x3.lua"
}

if doesFileExist(getWorkingDirectory().."/lib/rkeysFD.lua") then
	print("{82E28C}×òåíèå áèáëèîòåêè rkeysFD...")
	local f = io.open(getWorkingDirectory().."/lib/rkeysFD.lua")
	f:close()
else
	print("{F54A4A}Îøèáêà. Îòñóòñòâóåò áèáëèîòåêà rkeysFD {82E28C}Ñîçäàíèå áèáëèîòåêè rkeysFD...")
	local textrkeys = [[
local vkeys = require 'vkeys'

vkeys.key_names[vkeys.VK_LMENU] = "LAlt"
vkeys.key_names[vkeys.VK_RMENU] = "RAlt"
vkeys.key_names[vkeys.VK_LSHIFT] = "LShift"
vkeys.key_names[vkeys.VK_RSHIFT] = "RShift"
vkeys.key_names[vkeys.VK_LCONTROL] = "LCtrl"
vkeys.key_names[vkeys.VK_RCONTROL] = "RCtrl"

local tHotKey = {}
local tKeyList = {}
local tKeysCheck = {}
local iCountCheck = 0
local tBlockKeys = {[vkeys.VK_LMENU] = true, [vkeys.VK_RMENU] = true, [vkeys.VK_RSHIFT] = true, [vkeys.VK_LSHIFT] = true, [vkeys.VK_LCONTROL] = true, [vkeys.VK_RCONTROL] = true}
local tModKeys = {[vkeys.VK_MENU] = true, [vkeys.VK_SHIFT] = true, [vkeys.VK_CONTROL] = true}
local tBlockNext = {}
local module = {}
module._VERSION = "1.0.7"
module._MODKEYS = tModKeys
module._LOCKKEYS = false

local function getKeyNum(id)
   for k, v in pairs(tKeyList) do
      if v == id then
         return k
      end
   end
   return 0
end

function module.blockNextHotKey(keys)
   local bool = false
   if not module.isBlockedHotKey(keys) then
      tBlockNext[#tBlockNext + 1] = keys
      bool = true
   end
   return bool
end

function module.isHotKeyHotKey(keys, keys2)
   local bool
   for k, v in pairs(keys) do
      local lBool = true
      for i = 1, #keys2 do
         if v ~= keys2[i] then
            lBool = false
            break
         end
      end
      if lBool then
         bool = true
         break
      end
   end
   return bool
end


function module.isBlockedHotKey(keys)
   local bool, hkId = false, -1
   for k, v in pairs(tBlockNext) do
      if module.isHotKeyHotKey(keys, v) then
         bool = true
         hkId = k
         break
      end
   end
   return bool, hkId
end

function module.unBlockNextHotKey(keys)
   local result = false
   local count = 0
   while module.isBlockedHotKey(keys) do
      local _, id = module.isBlockedHotKey(keys)
      tHotKey[id] = nil
      result = true
      count = count + 1
   end
   local id = 1
   for k, v in pairs(tBlockNext) do
      tBlockNext[id] = v
      id = id + 1
   end
   return result, count
end

function module.isKeyModified(id)
   return (tModKeys[id] or false) or (tBlockKeys[id] or false)
end

function module.isModifiedDown()
   local bool = false
   for k, v in pairs(tModKeys) do
      if isKeyDown(k) then
         bool = true
         break
      end
   end
   return bool
end

lua_thread.create(function ()
   while true do
      wait(0)
      local tDownKeys = module.getCurrentHotKey()
      for k, v in pairs(tHotKey) do
         if #v.keys > 0 then
            local bool = true
            for i = 1, #v.keys do
               if i ~= #v.keys and (getKeyNum(v.keys[i]) > getKeyNum(v.keys[i + 1]) or getKeyNum(v.keys[i]) == 0) then
                  bool = false
                  break
               elseif i == #v.keys and (v.pressed and not wasKeyPressed(v.keys[i]) or not v.pressed and not isKeyDown(v.keys[i])) or (#v.keys == 1 and module.isModifiedDown()) then
                  bool = false
                  break
               end
            end
            if bool and ((module.onHotKey and module.onHotKey(k, v.keys) ~= false) or module.onHotKey == nil) then
               local result, id = module.isBlockedHotKey(v.keys)
               if not result then
                  v.callback(k, v.keys)
               else
                  tBlockNext[id] = nil
               end
            end
         end
      end
   end
end)

function module.registerHotKey(keys, pressed, callback)
   tHotKey[#tHotKey + 1] = {keys = keys, pressed = pressed, callback = callback}
   return true, #tHotKey
end

function module.getAllHotKey()
   return tHotKey
end

function module.unRegisterHotKey(keys)

   local result = false
   local count = 0
   while module.isHotKeyDefined(keys) do
      local _, id = module.isHotKeyDefined(keys)
      tHotKey[id] = nil
      result = true
      count = count + 1
   end
   local id = 1
   local tNewHotKey = {}
   for k, v in pairs(tHotKey) do
      tNewHotKey[id] = v
      id = id + 1
   end
   tHotKey = tNewHotKey
   return result, count
 
end

function module.isHotKeyDefined(keys)
   local bool, hkId = false, -1
   for k, v in pairs(tHotKey) do
      if module.isHotKeyHotKey(keys, v.keys) then
         bool = true
         hkId = k
         break
      end
   end
   return bool, hkId
end

function module.getKeysName(keys)
   local tKeysName = {}
   for k, v in ipairs(keys) do
      tKeysName[k] = vkeys.id_to_name(v)
   end
   return tKeysName
end

function module.getCurrentHotKey(type)
   local type = type or 0
   local tCurKeys = {}
   for k, v in pairs(vkeys) do
      if tBlockKeys[v] == nil then
         local num, down = getKeyNum(v), isKeyDown(v)
         if down and num == 0 then
            tKeyList[#tKeyList + 1] = v
         elseif num > 0 and not down then
            tKeyList[num] = nil
         end
      end
   end
   local i = 1
   for k, v in pairs(tKeyList) do
      tCurKeys[i] = type == 0 and v or vkeys.id_to_name(v)
      i = i + 1
   end
   return tCurKeys
end

return module

]]
	local f = io.open(getWorkingDirectory().."/lib/rkeysFD.lua", "w")
	f:write(textrkeys)
	f:close()			
end

local nofiles = {}
for i,v in ipairs(files) do
	if not doesFileExist(getWorkingDirectory()..v) then
		table.insert(nofiles, v)
	end
end

local ffi = require 'ffi'
ffi.cdef [[
		typedef int BOOL;
		typedef unsigned long HANDLE;
		typedef HANDLE HWND;
		typedef const char* LPCSTR;
		typedef unsigned UINT;
		
        void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
        uint32_t __stdcall CoInitializeEx(void*, uint32_t);
		
		BOOL ShowWindow(HWND hWnd, int  nCmdShow);
		HWND GetActiveWindow();
		
		
		int MessageBoxA(
		  HWND   hWnd,
		  LPCSTR lpText,
		  LPCSTR lpCaption,
		  UINT   uType
		);
		
		short GetKeyState(int nVirtKey);
		bool GetKeyboardLayoutNameA(char* pwszKLID);
		int GetLocaleInfoA(int Locale, int LCType, char* lpLCData, int cchData);
  ]]

local shell32 = ffi.load 'Shell32'
local ole32 = ffi.load 'Ole32'
ole32.CoInitializeEx(nil, 2 + 4)

if not doesFileExist(getGameDirectory().."/SAMPFUNCS.asi") then
	ffi.C.ShowWindow(ffi.C.GetActiveWindow(), 6)
	ffi.C.MessageBoxA(0, sampfuncsNot, "FireDeptHelper", 0x00000030 + 0x00010000) 
end
if #nofiles > 0 then
	ffi.C.ShowWindow(ffi.C.GetActiveWindow(), 6)
	ffi.C.MessageBoxA(0, errorText:format(table.concat(nofiles, "\n\t\t")), "FireDeptHelper", 0x00000030 + 0x00010000) 
end



local res, hook = pcall(require, 'lib.samp.events')
assert(res, "Áèáëèîòåêà SAMP Event íå íàéäåíà")
----------------------------------------
local res, imgui = pcall(require, "imgui")
assert(res, "Áèáëèîòåêà Imgui íå íàéäåíà")
-----------------------------------------
local res, fa = pcall(require, 'faIcons')
assert(res, "Áèáëèîòåêà faIcons íå íàéäåíà")
-----------------------------------------
local res, rkeys = pcall(require, 'rkeysFD')
assert(res, "Áèáëèîòåêà Rkeys íå íàéäåíà")
vkeys.key_names[vkeys.VK_RBUTTON] = "RBut"
vkeys.key_names[vkeys.VK_XBUTTON1] = "XBut1"
vkeys.key_names[vkeys.VK_XBUTTON2] = 'XBut2'
vkeys.key_names[vkeys.VK_NUMPAD1] = 'Num 1'
vkeys.key_names[vkeys.VK_NUMPAD2] = 'Num 2'
vkeys.key_names[vkeys.VK_NUMPAD3] = 'Num 3'
vkeys.key_names[vkeys.VK_NUMPAD4] = 'Num 4'
vkeys.key_names[vkeys.VK_NUMPAD5] = 'Num 5'
vkeys.key_names[vkeys.VK_NUMPAD6] = 'Num 6'
vkeys.key_names[vkeys.VK_NUMPAD7] = 'Num 7'
vkeys.key_names[vkeys.VK_NUMPAD8] = 'Num 8'
vkeys.key_names[vkeys.VK_NUMPAD9] = 'Num 9'
vkeys.key_names[vkeys.VK_MULTIPLY] = 'Num *'
vkeys.key_names[vkeys.VK_ADD] = 'Num +'
vkeys.key_names[vkeys.VK_SEPARATOR] = 'Separator'
vkeys.key_names[vkeys.VK_SUBTRACT] = 'Num -'
vkeys.key_names[vkeys.VK_DECIMAL] = 'Num .Del'
vkeys.key_names[vkeys.VK_DIVIDE] = 'Num /'
vkeys.key_names[vkeys.VK_LEFT] = 'Ar.Left'
vkeys.key_names[vkeys.VK_UP] = 'Ar.Up'
vkeys.key_names[vkeys.VK_RIGHT] = 'Ar.Right'
vkeys.key_names[vkeys.VK_DOWN] = 'Ar.Down'




--- Ôàéëîâàÿ ñèñòåìà
local deck = getFolderPath(0) -- äåñê
local doc = getFolderPath(5) -- screens
local dirml = getWorkingDirectory() -- Ìóí
local dirGame = getGameDirectory()
local scr = thisScript()
local font = renderCreateFont("Trebuchet MS", 14, 5)
local fontPD = renderCreateFont("Trebuchet MS", 12, 5)
local fontH =  renderGetFontDrawHeight(font)
local sx, sy = getScreenResolution()

local mainWin	= imgui.ImBool(false) -- Ãë.îêíî
local paramWin = imgui.ImBool(false) -- îêíî ïàðàìåòðîâ
local spurBig = imgui.ImBool(false) -- áîëüøîå îêíî øïîðû
local mainEditWin = imgui.ImBool(false)
local iconwin	= imgui.ImBool(false)
local profbWin = imgui.ImBool(false)
local select_menu = {true, false, false, false, false, false, false} -- äëÿ ïåðåêëþ÷åíèÿ ìåíþ




local setting = {
	nick = "",
	teg = "",
	org = 0,
	sex = 0,
	rank = 0,
	time = false,
	timeDo = false, 
	timeTx = "",
	rac = false,
	racTx = "",
	lec = "",
	med = "",
	upmed = "",
	rec = "",
	narko = "",
	tatu = "",
	chat1 = false,
	chat2 = false,
	chat3 = false,
	chathud = false,
	arp = false,
	setver = 1,
	imageUp = false
}
local buf_nick	= imgui.ImBuffer(256)
local buf_teg 	= imgui.ImBuffer(256)
local num_org		= imgui.ImInt(0)
local num_sex		= imgui.ImInt(0)
local num_rank	= imgui.ImInt(0)
local chgName = {}
chgName.inp = imgui.ImBuffer(100)
chgName.org = {u8"Ïîæàðíûé äåïàðòàìåíò"}
chgName.rank = {u8"Ðåêðóò", u8"Ñòàðøèé ðåêðóò", u8"Ìëàäøèé ïîæàðíûé", u8"Ïîæàðíûé", u8"Ñòàðøèé ïîæàðíûé", u8"Ïîæàðíûé èíñïåêòîð", u8"Ëåéòåíàíò", u8"Êàïèòàí", u8"Çàìåñòèòåëü íà÷àëüíèêà", u8"Íà÷àëüíèê äåïàðòàìåíòà"}

local list_org_BL = {"Ïîæàðíûé äåïàðòàìåíò"} 
local list_org	= {u8"Ïîæàðíûé äåïàðòàìåíò"}
local list_org_en = {"Fire Department"}
local list_sex	= {fa.ICON_MALE .. u8" Ìóæñêîé", fa.ICON_FEMALE .. u8" Æåíñêèé"} --ICON_MALE ICON_FEMALE 
local list_rank	= {u8"Ðåêðóò", u8"Ñòàðøèé ðåêðóò", u8"Ìëàäøèé ïîæàðíûé", u8"Ïîæàðíûé", u8"Ñòàðøèé ïîæàðíûé", u8"Ïîæàðíûé èíñïåêòîð", u8"Ëåéòåíàíò", u8"Êàïèòàí", u8"Çàìåñòèòåëü íà÷àëüíèêà", u8"Íà÷àëüíèê äåïàðòàìåíòà"}
--chat
local cb_chat1	= imgui.ImBool(false)
local cb_chat2	= imgui.ImBool(false)
local cb_chat3	= imgui.ImBool(false)
local cb_hud		= imgui.ImBool(false)
local hudPing = false
local cb_hudTime	= imgui.ImBool(false)
--RolePlay
local cb_time		= imgui.ImBool(false)
local cb_timeDo	= imgui.ImBool(false)
local cb_rac		= imgui.ImBool(false)
local buf_time	= imgui.ImBuffer(256)
local buf_rac		= imgui.ImBuffer(256)
--price
local buf_lec		= imgui.ImBuffer(10);
local buf_med		= imgui.ImBuffer(10);
local buf_upmed	= imgui.ImBuffer(10);
local buf_rec		= imgui.ImBuffer(10);
local buf_narko	= imgui.ImBuffer(10);
local buf_tatu	= imgui.ImBuffer(10);
--image
local cb_imageUp	= imgui.ImBool(false)
--shpora
local spur = {
text = imgui.ImBuffer(51200),
name = imgui.ImBuffer(256),
list = {},
select_spur = -1,
edit = false
}
--// menu setting
local PlayerSet = {}
function PlayerSet.name()
	if buf_nick.v ~= "" then
		return buf_nick.v
	else
		return u8"Íå óêàçàíû"
	end
end
function PlayerSet.teg()
if buf_teg.v ~= "" then
	return u8"(Ïîçûâíîé: "..buf_teg.v..u8")"
else
	return u8""
end
end
function PlayerSet.org()
	return chgName.org[num_org.v+1]
end
function PlayerSet.rank()
	return chgName.rank[num_rank.v+1]
end
function PlayerSet.sex()
	return list_sex[num_sex.v+1]
end


--cmd bind
local selected_cmd = 1
local currentKey	= {"",{}}
local cb_RBUT		= imgui.ImBool(false)
local cb_x1		= imgui.ImBool(false)
local cb_x2		= imgui.ImBool(false)
local isHotKeyDefined = false
local p_open = false

--Binder
binder = {
	list = {},
	select_bind,
	edit = false,
	sleep = imgui.ImFloat(0.5),
	name = imgui.ImBuffer(256),
	text = imgui.ImBuffer(51200),
	cmd = imgui.ImBuffer(256),
	key = {}
}
local helpd = {}
helpd.exp = imgui.ImBuffer(256)
helpd.exp.v =  u8[[
{dialog}
[name]=Âûäà÷à ìåä.êàðòû
[1]=Ïîëíîñòüþ çäîðîâûé
Îòûãðîâêà ¹1
Îòûãðîâêà ¹2
[2]=Èìåþòñÿ îòêëîíåíèÿ 
Îòûãðîâêà ¹1
Îòûãðîâêà ¹2
{dialogEnd}
]]
helpd.key = {
	{k = "MBUTTON", n = 'Êíîïêà ìûøè'},
	{k = "XBUTTON1", n = 'Áîêîâàÿ êíîïêà ìûøè 1'},
	{k = "XBUTTON2", n = 'Áîêîâàÿ êíîïêà ìûøè 2'},
	{k = "BACK", n = 'Backspace'},
	{k = "SHIFT", n = 'Shift'},
	{k = "CONTROL", n = 'Ctrl'},
	{k = "PAUSE", n = 'Pause'},
	{k = "CAPITAL", n = 'Caps Lock'},
	{k = "SPACE", n = 'Space'},
	{k = "PRIOR", n = 'Page Up'},
	{k = "NEXT", n = 'Page Down'},
	{k = "END", n = 'End'},
	{k = "HOME", n = 'Home'},
	{k = "LEFT", n = 'Ñòðåëêà âëåâî'},
	{k = "UP", n = 'Ñòðåëêà ââåðõ'},
	{k = "RIGHT", n = 'Ñòðåëêà âïðàâî'},
	{k = "DOWN", n = 'Ñòðåëêà âíèç'},
	{k = "SNAPSHOT", n = 'Print Screen'},
	{k = "INSERT", n = 'Insert'},
	{k = "DELETE", n = 'Delete'},
	{k = "0", n = '0'},
	{k = "1", n = '1'},
	{k = "2", n = '2'},
	{k = "3", n = '3'},
	{k = "4", n = '4'},
	{k = "5", n = '5'},
	{k = "6", n = '6'},
	{k = "7", n = '7'},
	{k = "8", n = '8'},
	{k = "9", n = '9'},
	{k = "A", n = 'A'},
	{k = "B", n = 'B'},
	{k = "C", n = 'C'},
	{k = "D", n = 'D'},
	{k = "E", n = 'E'},
	{k = "F", n = 'F'},
	{k = "G", n = 'G'},
	{k = "H", n = 'H'},
	{k = "I", n = 'I'},
	{k = "J", n = 'J'},
	{k = "K", n = 'K'},
	{k = "L", n = 'L'},
	{k = "M", n = 'M'},
	{k = "N", n = 'N'},
	{k = "O", n = 'O'},
	{k = "P", n = 'P'},
	{k = "Q", n = 'Q'},
	{k = "R", n = 'R'},
	{k = "S", n = 'S'},
	{k = "T", n = 'T'},
	{k = "U", n = 'U'},
	{k = "V", n = 'V'},
	{k = "W", n = 'W'},
	{k = "X", n = 'X'},
	{k = "Y", n = 'Y'},
	{k = "Z", n = 'Z'},
	{k = "NUMPAD0", n = 'Numpad 0'},
	{k = "NUMPAD1", n = 'Numpad 1'},
	{k = "NUMPAD2", n = 'Numpad 2'},
	{k = "NUMPAD3", n = 'Numpad 3'},
	{k = "NUMPAD4", n = 'Numpad 4'},
	{k = "NUMPAD5", n = 'Numpad 5'},
	{k = "NUMPAD6", n = 'Numpad 6'},
	{k = "NUMPAD7", n = 'Numpad 7'},
	{k = "NUMPAD8", n = 'Numpad 8'},
	{k = "NUMPAD9", n = 'Numpad 9'},
	{k = "MULTIPLY", n = 'Numpad *'},
	{k = "ADD", n = 'Numpad +'},
	{k = "SEPARATOR", n = 'Separator'},
	{k = "SUBTRACT", n = 'Numpad -'},
	{k = "DECIMAL", n = 'Numpad .'},
	{k = "DIVIDE", n = 'Numpad /'},
	{k = "F1", n = 'F1'},
	{k = "F2", n = 'F2'},
	{k = "F3", n = 'F3'},
	{k = "F4", n = 'F4'},
	{k = "F5", n = 'F5'},
	{k = "F6", n = 'F6'},
	{k = "F7", n = 'F7'},
	{k = "F8", n = 'F8'},
	{k = "F9", n = 'F9'},
	{k = "F10", n = 'F10'},
	{k = "F11", n = 'F11'},
	{k = "F12", n = 'F12'},
	{k = "F13", n = 'F13'},
	{k = "F14", n = 'F14'},
	{k = "F15", n = 'F15'},
	{k = "F16", n = 'F16'},
	{k = "F17", n = 'F17'},
	{k = "F18", n = 'F18'},
	{k = "F19", n = 'F19'},
	{k = "F20", n = 'F20'},
	{k = "F21", n = 'F21'},
	{k = "F22", n = 'F22'},
	{k = "F23", n = 'F23'},
	{k = "F24", n = 'F24'},
	{k = "LSHIFT", n = 'Ëåâûé Shift'},
	{k = "RSHIFT", n = 'Ïðàâûé Shift'},
	{k = "LCONTROL", n = 'Ëåâûé Ctrl'},
	{k = "RCONTROL", n = 'Ïðàâûé Ctrl'},
	{k = "LMENU", n = 'Ëåâûé Alt'},
	{k = "RMENU", n = 'Ïðàâûé Alt'},
	{k = "OEM_1", n = '; :'},
	{k = "OEM_PLUS", n = '= +'},
	{k = "OEM_MINUS", n = '- _'},
	{k = "OEM_COMMA", n = ', <'},
	{k = "OEM_PERIOD", n = '. >'},
	{k = "OEM_2", n = '/ ?'},
	{k = "OEM_4", n = ' { '},
	{k = "OEM_6", n = ' } '},
	{k = "OEM_5", n = '\\ |'},
	{k = "OEM_8", n = '! §'},
	{k = "OEM_102", n = '> <'}
}


-- buf_nick
local errorspawn = false

--edit main bind
local buf_mainedit = imgui.ImBuffer(51200) 
local error_mce = ""

--chathud
local BuffSize = 32
local KeyboardLayoutName = ffi.new("char[?]", BuffSize)
local LocalInfo = ffi.new("char[?]", BuffSize)
local textFont = renderCreateFont("Trebuchet MS", 12, FCR_BORDER + FCR_BOLD)
local fontPing = renderCreateFont("Trebuchet MS", 10, 5)
local pingLog = {}

lua_thread.create(function()
	while true do
		repeat wait(100) until isSampAvailable()
		repeat wait(100) until sampIsLocalPlayerSpawned()
		wait(1500)
		if sampIsLocalPlayerSpawned() then
			local ping = sampGetPlayerPing(myid)
			table.insert(pingLog, ping)
			if #pingLog == 41 then table.remove(pingLog, 1) end
		end
	end
end)
--Xyinya
local week = {"Âîñêðåñåíüå", "Ïîíåäåëüíèê", "Âòîðíèê", "Ñðåäà", "×åòâåðã", "Ïÿòíèöà", "Ñóááîòà"}
local month = {"ßíâàðü", "Ôåâðàëü", "Ìàðò", "Àïðåëü", "Ìàé", "Èþíü", "Èþëü", "Àâãóñò", "Ñåíòÿáðü", "Îêòÿáðü", "Íîÿáðü", "Äåêàáðü"}
editKey = false
keysList = {}
arep = false
needSave = false
needSaveColor = imgui.ImColor(250, 66, 66, 102):GetVec4()

local postCP = nil
local postCPcoords = {}
postCPcoords.x = nil
postCPcoords.y = nil
postCPcoords.z = nil

local BlockKeys = {{vkeys.VK_T}, {vkeys.VK_F6}, {vkeys.VK_F8}, {vkeys.VK_RETURN}, {vkeys.VK_OEM_3}, {vkeys.VK_LWIN}, {vkeys.VK_RWIN}}

rkeys.isBlockedHotKey = function(keys)
	local bool, hkId = false, -1
	for k, v in pairs(BlockKeys) do
	   if rkeys.isHotKeyHotKey(keys, v) then
		  bool = true
		  hkId = k
		  break
	   end
	end
	return bool, hkId
end

-- rkeys.blockNextHotKey = function(keys)
-- 	local bool = false
-- 	if not rkeys.isBlockedHotKey(keys) then
-- 	   tBlockNext[#tBlockNext + 1] = keys
-- 	   bool = true
-- 	end
-- 	return bool
-- end
 


-- for i,v in ipairs(BlockKeys) do
-- 	rkeys.blockNextHotKey({v})
-- end



function rkeys.isHotKeyExist(keys)
local bool = false
	for i,v in ipairs(keysList) do
		if table.concat(v,"+") == table.concat(keys, "+") then
			if #keys ~= 0 then
				bool = true
				break
			end
		end
	end
	return bool
end

function unRegisterHotKey(keys)
	for i,v in ipairs(keysList) do
		if v == keys then
			keysList[i] = nil
			break
		end
	end
	local listRes = {}
	for i,v in ipairs(keysList) do
		if #v > 0 then
			listRes[#listRes+1] = v
		end
	end
	keysList = listRes
end


cmdBind = {
	[1] = {
		cmd = "/fd",
		key = {},
		desc = "Ãëàâíîå ìåíþ ñêðèïòà",
		rank = 1,
		rb = false
	},
	[2] = {
		cmd = "/r",
		key = {},
		desc = "Êîìàíäà äëÿ âûçîâà ðàöèè ñ òåãîì (åñëè ïðîïèñàí)",
		rank = 1,
		rb = false
	},
	[3] = {
		cmd = "/rb",
		key = {},
		desc = "Êîìàíäà äëÿ íàïèñàíèÿ ÍîíÐï ñîîáùåíèÿ â ðàöèþ. ",
		rank = 1,
		rb = false
	},
	[4] = {
		cmd = "/mb",
		key = {},
		desc = "Ñîêðàù¸ííàÿ êîìàíäà /members",
		rank = 1,
		rb = false
	},
	[5] = {
		cmd = "/post",
		key = {},
		desc = "Äîêëàä ñ ïîñòà. Òàêæå èíôîðìàöèÿ î ïîñòàõ.",
		rank = 1,
		rb = false
	},
	[6] = {
		cmd = "/fracrp",
		key = {},
		desc = "Âûäàòü îòìåòêó îá ó÷àñòèè â ÐÏ ïðîöåññå",
		rank = 6,
		rb = false
	},
	[7] = {
		cmd = "/+warn",
		key = {},
		desc = "Âûäà÷à âûãîâîðà ñîòðóäíèêó",
		rank = 9,
		rb = false
	},
	[8] = {
		cmd = "/-warn",
		key = {},
		desc = "Ñíÿòü âûãîâîð ñîòðóäíèêó",
		rank = 9,
		rb = false
	},
	[9] = {
		cmd = "/+mute",
		key = {},
		desc = "Âûäàòü ìóò ñîòðóäíèêó",
		rank = 9,
		rb = false
	},
	[10] = {
		cmd = "/-mute",
		key = {},
		desc = "Ñíÿòü ìóò ñîòðóäíèêó",
		rank = 9,
		rb = false
	},
	[11] = {
		cmd = "/gr",
		key = {},
		desc = "Èçìåíèòü ðàíã (äîëæíîñòü) ñîòðóäíèêó",
		rank = 9,
		rb = false
	},
	[12] = {
		cmd = "/inv",
		key = {},
		desc = "Ïðèíÿòü â îðãàíèçàöèþ èãðîêà",
		rank = 9,
		rb = false
	},
	[13] = {
		cmd = "/unv",
		key = {},
		desc = "Óâîëèòü ñîòðóäíèêà èç îðãàíèçàöèè",
		rank = 9,
		rb = false
	},
	[14] = {
		cmd = "/fspcars",
		key = {},
		desc = "Çàñïàâíèòü ôðàêöèîííûé òðàíñïîðò",
		rank = 9,
		rb = false
	},
	[15] = {
		cmd = "/ts",
		key = {},
		desc = "Áûñòðûé ñêðèíøîò ñ àâòîìàòè÷åñêèì ââîäîì /time",
		rank = 1,
		rb = false
	}
}



function styleWin()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ScrollbarSize = 15.0
    style.WindowRounding = 2.0
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 3.0
	style.FramePadding = imgui.ImVec2(5, 3)
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    
    colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered]          = imgui.ImColor(228, 83, 83, 200):GetVec4() --ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive]           = imgui.ImColor(225, 0, 0, 200):GetVec4()
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.06, 0.06, 0.06, 0.90) --ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = ImVec4(0.08, 0.08, 0.08, 0.90)
    colors[clr.Border]                 = imgui.ImColor(190, 0, 0, 200):GetVec4() --ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = imgui.ImColor(100, 100, 100, 225):GetVec4()
end
styleWin()


function ButtonMenu(desk, bool) -- ïîäñâåòêà êíîïêè âûáðàííîãî ìåíþ
	local retBool = false
	if bool then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(230, 73, 45, 220):GetVec4())
		retBool = imgui.Button(desk, imgui.ImVec2(140, 25))
		imgui.PopStyleColor(1)
	elseif not bool then
		 retBool = imgui.Button(desk, imgui.ImVec2(140, 25))
	end
	return retBool
end

local fa_font = nil
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })
function imgui.BeforeDrawFrame()
  if fa_font == nil then
    local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
    font_config.MergeMode = true

    fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/FDHelper/files/font-icon.ttf', 15.0, font_config, fa_glyph_ranges)
  end
end


function main()
	repeat wait(100) until isSampAvailable()
	local base = getModuleHandle("samp.dll")
	local sampVer = mem.tohex( base + 0xBABE, 10, true )
	if sampVer == "E86D9A0A0083C41C85C0" then
		sampIsLocalPlayerSpawned = function()
			local res, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
			return sampGetGamestate() == 3 and res and sampGetPlayerAnimationId(id) ~= 0
		end
	end
	if script.this.filename:find("%.luac") then
		os.rename(getWorkingDirectory().."\\FireDeptHelper.luac", getWorkingDirectory().."\\FireDeptHelper.lua") 
	end
--	repeat wait(100) until sampIsLocalPlayerSpawned()
	------------
	thread = lua_thread.create(function() return end)
	lua_thread.create(function()
		while true do
		wait(1000)
		needSaveColor = imgui.ImColor(250, 66, 66, 102):GetVec4()
			if needSave then
				wait(1000)
				needSaveColor = imgui.ImColor(230, 40, 40, 220):GetVec4()
			end
		end
	end)  
	------------
		
		print("{82E28C}Ïðîâåðêà èçîáðàæåíèé..")
		if not doesFileExist(dirml.."/FDHelper/files/logo-firedepthelper.png") then print("{FF2525}Îøèáêà: {FFD825}Îòñóòñòâóåò èçîáðàæåíèå logo-firedepthelper.png"); scr:unload() end
		logoFDH = imgui.CreateTextureFromFile(dirml.."/FDHelper/files/logo-firedepthelper.png") 
		
		--Ïðîâåðêà íà ñóùåñòâîâàíèå ïàïêîê
		if not doesDirectoryExist(dirml.."/FDHelper/files/") then
			print("{F54A4A}Îøèáêà. Îòñóòñòâóåò ïàïêà. {82E28C}Ñîçäàíèå ïàïêè ïîä ôàéëû")
			createDirectory(dirml.."/FDHelper/files/")
		end
		if not doesDirectoryExist(dirml.."/FDHelper/Binder/") then
			print("{F54A4A}Îøèáêà. Îòñóòñòâóåò ïàïêà. {82E28C}Ñîçäàíèå ïàïêè äëÿ áèíäåðà.")
			createDirectory(dirml.."/FDHelper/Binder/")
		end
		if not doesDirectoryExist(dirml.."/FDHelper/Øïàðãàëêè/") then
			print("{F54A4A}Îøèáêà. Îòñóòñòâóåò ïàïêà. {82E28C}Ñîçäàíèå ïàïêè äëÿ øïîð")
			createDirectory(dirml.."/FDHelper/Øïàðãàëêè/")
		end
		if doesFileExist(dirml.."/FDHelper/main.txt") then
			local f = io.open(dirml.."/FDHelper/main.txt")
			buf_mainedit.v =  u8(f:read("*a"))
			f:close()
			print("{82E28C}×òåíèå ãëàâíîé îòûãðîâêè...")
		else 
			local textrp = [[
{sleep:0}
{dialog}
[name]=×òî äåëàåì?
[1]=Äîêëàä
{dialog}
[name]=Î ÷åì äîêëàäûâàåì?
[1]=Ïîñò
/post
[2]=Ïðèíÿë âûçîâ äèñïåò÷åðà
/r Ïðèíÿë{sex:|à} âûçîâ îò äèñïåò÷åðà!
/r Â ñðî÷íîì ïîðÿäêå âûåçæàþ íà òóøåíèå ïîæàðà ïî óêàçàííîìó 10-20.
/fires
[3]=Ïðèáûë íà ìåñòî ïîæàðà
/r Äîêëàäûâàåò {myRusNick} ñ ïîðÿäêîâûì íîìåðîì {myID}. 
/r Ïðèáûë{sex:|à} íà 10-20. Ïðèñòóïàþ ê óñòðàíåíèþ âîçãîðàíèÿ.
/r Êîíåö ñâÿçè.
[4]=Âîçãîðàíèå ëèêâèäèðîâàíî
/r Äîêëàäûâàåò {myRusNick} ñ ïîðÿäêîâûì íîìåðîì {myID}.
/r Ñòàòóñ 10-99 íà ìåñòå, âîçâðàùàþñü â äåïàðòàìåíò.
/r Êîíåö ñâÿçè.
[5]=Âåðíóëñÿ â äåïàðòàìåíò
/r Äîêëàäûâàåò {myRusNick} ñ ïîðÿäêîâûì íîìåðîì {myID}.
/r Âåðíóë{sex:ñÿ|àñü} â äåïàðòàìåíò. Ñòàòóñ 10-8.
/r Êîíåö ñâÿçè.
{dialogEnd}
[2]=Îòêèíóòü ìåãàôîí
/m Ãîâîðèò Ïîæàðíûé äåïàðòàìåíò øòàòà!
/m Ñðî÷íî óñòóïèòå äîðîãó ñïåö. òðàíñïîðòó!
{dialogEnd}]]  
			local f = io.open(dirml.."/FDHelper/main.txt", "w")
			f:write(textrp) 
			f:close()
			buf_mainedit.v = u8(textrp)
		end
		if doesFileExist(dirml.."/FDHelper/MainSetting.fd") then
		print("{82E28C}×òåíèå íàñòðîåê...")
		local f = io.open(dirml.."/FDHelper/MainSetting.fd")
			local setf = f:read("*a")
			f:close()
			local res, set = pcall(decodeJson, setf)
			if res and type(set) == "table" then 
				buf_nick.v = u8(set.nick)
				buf_teg.v = u8(set.teg)
				num_org.v = set.org
				num_sex.v = set.sex
				num_rank.v = set.rank
				cb_time.v = set.time
				buf_time.v = u8(set.timeTx)
				cb_timeDo.v = set.timeDo
				cb_rac.v = set.rac
				buf_rac.v = u8(set.racTx)
				cb_chat1.v = set.chat1
				cb_chat2.v = set.chat2
				cb_chat3.v = set.chat3
				cb_hud.v = set.chathud
				arep = set.arp
				setver = set.setver
				hudPing = set.hping
				cb_hudTime.v = set.htime
				if set.orgl then
					for i,v in ipairs(set.orgl) do
						chgName.org[tonumber(i)] = u8(v)
					end
				end
				if set.rankl then
					for i,v in ipairs(set.rankl) do
						chgName.rank[tonumber(i)] = u8(v)
					end
				end
			else
				os.remove(dirml.."/FDHelper/MainSetting.fd")
				print("{F54A4A}Îøèáêà. Ôàéë íàñòðîåê ïîâðåæä¸í.")
				print("{82E28C}Ñîçäàíèå íîâûõ ñîáñòâåííûõ íàñòðîåê...")
				
				buf_time.v = u8"/me çàêàòàâ ðóêàâ, ïîñìîòðåë íà ÷àñû ñ ãðàâèðîâêîé \"FireDept\""
				buf_rac.v = u8"/me ñíÿâ ðàöèþ ñ ïîÿñà, ÷òî-òî ñêàçàë â íå¸"
			end
		else
			print("{F54A4A}Îøèáêà. Ôàéë íàñòðîåê íå íàéäåí.")
			print("{82E28C}Ñîçäàíèå ñîáñòâåííûõ íàñòðîåê...")
			
			buf_time.v = u8"/me çàêàòàâ ðóêàâ, ïîñìîòðåë íà ÷àñû ñ ãðàâèðîâêîé \"FireDept\""
			buf_rac.v = u8"/me ñíÿâ ðàöèþ ñ ïîÿñà, ÷òî-òî ñêàçàë â íå¸"
			
		end

	print("{82E28C}×òåíèå íàñòðîåê êîìàíä...")
	if doesFileExist(dirml.."/FDHelper/cmdSetting.fd") then
	--register cmd
		local f = io.open(dirml.."/FDHelper/cmdSetting.fd")
		local res, keys = pcall(decodeJson, f:read("*a"))
		f:flush()
		f:close()
		if res and type(keys) == "table" then
			for i, v in ipairs(keys) do
				if #v.key > 0 then
					
					rkeys.registerHotKey(v.key, true, onHotKeyCMD)
					cmdBind[i].key = v.key
					table.insert(keysList, v.key)
				end
			end
		else
			print("{F54A4A}Îøèáêà. Ôàéë íàñòðîåê êîìàíä ïîâðåæä¸í.")
			print("{82E28C}Ïðèìåíåíû ñòàíäàðòíûå íàñòðîéêè")
			os.remove(dirml.."/FDHelper/cmdSetting.fd")
		end
	else
		print("{F54A4A}Îøèáêà. Ôàéë íàñòðîåê êîìàíä íå íàéäåí.")
		print("{82E28C}Ïðèìåíåíû ñòàíäàðòíûå íàñòðîéêè")
	end
	
	--register binder 
	print("{82E28C}×òåíèå íàñòðîåê áèíäåðà...")
	if doesFileExist(dirml.."/FDHelper/bindSetting.fd") then
		local f = io.open(dirml.."/FDHelper/bindSetting.fd")
		local res, list = pcall(decodeJson, f:read("*a"))
		f:flush()
		f:close()
		if res and type(list) == "table" then
			binder.list = list
			for i, v in ipairs(binder.list) do
				if #v.key > 0 then
					binder.list[i].key = v.key
					rkeys.registerHotKey(v.key, true, onHotKeyBIND)
					sampRegisterChatCommand(v.cmd, function() binderCmdStart() end)
					table.insert(keysList, v.key)
				end
			end
		else
			os.remove(dirml.."/FDHelper/bindSetting.fd")
			print("{F54A4A}Îøèáêà. Ôàéë íàñòðîåê áèíäåðà ïîâðåæä¸í.")
			print("{82E28C}Ïðèìåíåíû ñòàíäàðòíûå íàñòðîéêè")
		end
	else 
		print("{F54A4A}Îøèáêà. Ôàéë íàñòðîåê áèíäåðà íå íàéäåí.")
		print("{82E28C}Ïðèìåíåíû ñòàíäàðòíûå íàñòðîéêè")
	end
	
	lockPlayerControl(false)
		sampfuncsRegisterConsoleCommand("arep", function(bool) 
			if tonumber(bool) == 1 then 
				arep = true 
				print("Rep: On")
			else 
				arep = false 
			end 
		end)
		sampRegisterChatCommand("fd", function() mainWin.v = not mainWin.v end)
		sampRegisterChatCommand("fdrl", function() scr:reload() end)
		sampRegisterChatCommand("+warn", funCMD.warn)
		sampRegisterChatCommand("fracrp", funCMD.fracrp)
		sampRegisterChatCommand("-warn", funCMD.uwarn)
		sampRegisterChatCommand("gr", funCMD.rank)
		sampRegisterChatCommand("inv", funCMD.inv)
		sampRegisterChatCommand("unv", funCMD.unv)
		sampRegisterChatCommand("fspcars", funCMD.spawncars)
		sampRegisterChatCommand("+mute", funCMD.mute)
		sampRegisterChatCommand("-mute", funCMD.umute)
		sampRegisterChatCommand("mb", funCMD.memb)
		sampRegisterChatCommand("post", funCMD.post)
		sampRegisterChatCommand("ts", funCMD.time)
		
		for i,v in ipairs(binder.list) do
			sampRegisterChatCommand(binder.list[i].cmd, function() binderCmdStart() end)
		end
		repeat wait(100) until sampIsLocalPlayerSpawned()
		_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
		myNick = sampGetPlayerNickname(myid)
		
		sampAddChatMessage(string.format(SCRIPT_PREFIX.."Ïðèâåòñòâóþ, %s. Ñêðèïò óñïåøíî çàãðóæåí. Âåðñèÿ ñêðèïòà: %s", sampGetPlayerNickname(myid):gsub("_"," "),scr.version), SCRIPT_COLOR)
		sampAddChatMessage(SCRIPT_PREFIX.."Êîìàíäû: Ãëàâíîå ìåíþ - "..COLOR_SECONDARY.."/fd"..COLOR_WHITE..". Ãëàâíàÿ îòûãðîâêà - "..COLOR_SECONDARY.."êíîïêà O (àíãë)", SCRIPT_COLOR)
		updateCheck()
		wait(200)
		if buf_nick.v == "" then 
			sampAddChatMessage(SCRIPT_PREFIX.."Ïîõîæå ó òåáÿ íå íàñòðîåíà îñíîâíàÿ èíôîðìàöèÿ. ", SCRIPT_COLOR)
			sampAddChatMessage(SCRIPT_PREFIX.."Çàéäè â ãëàâíîì ìåíþ â ðàçäåë \"Íàñòðîéêè\" è íàñòðîé ñåáå âñ¸ ïî \"ôýí-øóþ\".", SCRIPT_COLOR)
		end
  while true do
	wait(0)
		if postCP ~= nil then
			local x, y, z = getCharCoordinates(PLAYER_PED)
			if getDistanceBetweenCoords3d(x,y,z,postCPcoords.x,postCPcoords.y,postCPcoords.z) < 3 then
				deleteCheckpoint(postCP)
				postCP = nil
				postCPcoords.x = nil
				postCPcoords.y = nil 
				postCPcoords.z = nil				
				addOneOffSound(0, 0, 0, 1058)
			end
		end
		resTarg, pedTar = getCharPlayerIsTargeting(PLAYER_HANDLE)
		if resTarg then
			_, targID = sampGetPlayerIdByCharHandle(pedTar)
		end
	if isKeyDown(VK_LMENU) and isKeyJustPressed(VK_K) and not sampIsChatInputActive() then
		mainWin.v = not mainWin.v 
	end
	
	if isKeyJustPressed(VK_O) and not sampIsChatInputActive() and not sampIsDialogActive() then
		if thread:status() ~= "dead" then
			thread:terminate()
			funCMD.main()
		else
			funCMD.main()
		end
	end
	if thread:status() ~= "dead" and not isGamePaused() then 
		renderFontDrawText(fontPD, "Îòûãðîâêà: [{F25D33}Page Down{FFFFFF}] - Ïðèîñòàíîâèòü", 20, sy-30, 0xFFFFFFFF)
		if isKeyJustPressed(VK_NEXT) and not sampIsChatInputActive() and not sampIsDialogActive() then
			thread:terminate()
		end
	end
	if sampIsDialogActive() then
		if arep then
			local idD = sampGetCurrentDialogId()
			if idD == 1333 then
				HideDialog()
			lockPlayerControl(false)
			end
		end
	end
	if cb_hud.v then showInputHelp() end
	if cb_hudTime.v and not isPauseMenuActive() then hudTimeF() end
	--if hudPing and not isPauseMenuActive() then pingGraphic(sx/9*8-20, sy/4) end
		imgui.Process = mainWin.v or iconwin.v
  end
end
function binderCmdStart()
	local factCommand = sampGetChatInputText()
	for i,v in ipairs(binder.list) do
		local sverkaCommand = string.format("/%s", binder.list[i].cmd)
		if sverkaCommand == factCommand then
		local numberMassive = i
		local nameMassive = binder.list[i].name
		for k, v in pairs(binder.list) do
			if thread:status() == "dead" then
				thread = lua_thread.create(function()
				local dir = dirml.."/FDHelper/Binder/bind-"..nameMassive..".txt"
				local tb = {}
				tb = strBinderTable(dir)
				tb.sleep = binder.list[i].sleep
				playBind(tb)
				return end)	
			end
		end
	end
end
end

function HideDialog(bool)
	lua_thread.create(function()
		repeat wait(0) until sampIsDialogActive()
		while sampIsDialogActive() do
			local memory = require 'memory'
			memory.setint64(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
			sampToggleCursor(bool)
		end
	end)
end
imgui.GetIO().FontGlobalScale = 1.1

function mainSet()
	imgui.SetCursorPosX(25)
	imgui.BeginGroup()
	imgui.PushItemWidth(300);
		if imgui.InputText(u8"Èìÿ è Ôàìèëèÿ ", buf_nick, imgui.InputTextFlags.CallbackCharFilter, filter(1, "[à-ß%s]+")) then needSave = true end

			if not imgui.IsItemActive() and buf_nick.v == "" then
				imgui.SameLine()
				ShowHelpMarker(u8"Èìÿ è Ôàìèëèÿ çàïîëíÿåòñÿ íà \nðóññêîì áåç íèæíåãî ïîä÷¸ðêèâàíèÿ.\n\n  Ïðèìåð: Èâàí Èâàíîâ")
				imgui.SameLine()
				imgui.SetCursorPosX(30)
				imgui.TextColored(imgui.ImColor(200, 200, 200, 200):GetVec4(), u8"Ââåäèòå Âàøå Èìÿ è Ôàìèëèþ");
			else
			imgui.SameLine()
			ShowHelpMarker(u8"Èìÿ è Ôàìèëèÿ çàïîëíÿåòñÿ íà \nðóññêîì áåç íèæíåãî ïîä÷¸ðêèâàíèÿ.\n\n  Ïðèìåð: Èâàí Èâàíîâ")
			end
		if imgui.InputText(u8"Ïîçûâíîé ", buf_teg) then needSave = true end
		if not imgui.IsItemActive() and buf_teg.v == "" then
			imgui.SameLine()
			imgui.SetCursorPosX(432)
			imgui.TextColored(imgui.ImColor(200, 200, 200, 200):GetVec4(), u8"Ââåäèòå âàø ïîçûâíîé, åñëè îí åñòü");
		end
		imgui.SameLine(); ShowHelpMarker(u8"Ïîçûâíîé ìîæåò áûòü íåîáÿçàòåëüíûì,\n óòî÷íèòå ó äðóãèõ ñîòðóäíèêîâ èëè Ëèäåðà.\n\nÈñïîëüçóåòñÿ èñêëþ÷èòåëüíî äëÿ îòûãðîâîê ÷åðåç ïåðåìåííóþ {myTag}.")
		imgui.PushItemWidth(278);
			imgui.PushStyleVar(imgui.StyleVar.FramePadding, imgui.ImVec2(1, 3))
				if imgui.Button(fa.ICON_COG.."##1", imgui.ImVec2(21,20)) then
					chgName.inp.v = chgName.org[num_org.v+1]
					imgui.OpenPopup(u8"FDH | Èçìåíåíèå íàçâàíèÿ îðãàíèçàöèè")
				end
			imgui.PopStyleVar(1)
			imgui.SameLine(22)
			if imgui.Combo(u8"Îðãàíèçàöèÿ ", num_org, chgName.org) then needSave = true end
			imgui.PushStyleVar(imgui.StyleVar.FramePadding, imgui.ImVec2(1, 3))
				if imgui.Button(fa.ICON_COG.."##2", imgui.ImVec2(21,20)) then
					chgName.inp.v = chgName.rank[num_rank.v+1]
					imgui.OpenPopup(u8"FDH | Èçìåíåíèå íàçâàíèÿ äîëæíîñòè")
				end
			imgui.PopStyleVar(1)
			imgui.SameLine(22)
			if imgui.Combo(u8"Äîëæíîñòü ", num_rank, chgName.rank) then needSave = true end
		imgui.PopItemWidth()						
		if imgui.Combo(u8"Âàø ïîë ", num_sex, list_sex) then needSave = true end
	imgui.PopItemWidth()
	imgui.EndGroup()
	if imgui.BeginPopupModal(u8"FDH | Èçìåíåíèå íàçâàíèÿ îðãàíèçàöèè", null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
		imgui.Text(u8"Íàçâàíèå îðãàíèçàöèè áóäåò ïðèìåíåíî ê òåêóùåìó íàçâàíèþ")

		imgui.PushItemWidth(390)
			imgui.InputText(u8"##inpcastname", chgName.inp, 512, filter(1, "[%s%a%-]+"))
		imgui.PopItemWidth()
		if imgui.Button(u8"Ñîõðàíèòü", imgui.ImVec2(126,23)) then
			local exist = false
			for i,v in ipairs(chgName.org) do
				if v == chgName.inp.v and i ~= num_org.v+1 then
					exist = true
				end
			end
			if not exist then
				chgName.org[num_org.v+1] = chgName.inp.v
				needSave = true
				imgui.CloseCurrentPopup()
			end
		end
		imgui.SameLine()
		if imgui.Button(u8"Ñáðîñèòü", imgui.ImVec2(128,23)) then
			chgName.org[num_org.v+1] = list_org[num_org.v+1]
			needSave = true
			imgui.CloseCurrentPopup()
		end
		imgui.SameLine()
		if imgui.Button(u8"Îòìåíà", imgui.ImVec2(126,23)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
	if imgui.BeginPopupModal(u8"FDH | Èçìåíåíèå íàçâàíèÿ äîëæíîñòè", null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
		imgui.Text(u8"Íàçâàíèå äîëæíîñòè áóäåò ïðèìåíåíî ê òåêóùåìó íàçâàíèþ")

		imgui.PushItemWidth(200)
			imgui.InputText(u8"##inpcastname", chgName.inp, 512, filter(1, "[%s%a%-]+"))
		imgui.PopItemWidth()
		if imgui.Button(u8"Ñîõðàíèòü", imgui.ImVec2(126,23)) then
			local exist = false
			for i,v in ipairs(chgName.rank) do
				if v == chgName.inp.v and i ~= num_rank.v+1 then
					exist = true
				end
			end
			if not exist then
				chgName.rank[num_rank.v+1] = chgName.inp.v
				needSave = true
				imgui.CloseCurrentPopup()
			end
		end
		imgui.SameLine()
		if imgui.Button(u8"Ñáðîñèòü", imgui.ImVec2(128,23)) then
			chgName.rank[num_rank.v+1] = list_rank[num_rank.v+1]
			needSave = true
			imgui.CloseCurrentPopup()
		end
		imgui.SameLine()
		if imgui.Button(u8"Îòìåíà", imgui.ImVec2(126,23)) then
			imgui.CloseCurrentPopup()
		end
		imgui.EndPopup()
	end
end

function imgui.OnDrawFrame()
	if mainWin.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(850, 450), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.ICON_FIRE .. " Fire Department Helper v"..scr.version..(newversion ~= scr.version and u8" (ÅÑÒÜ ÎÁÍÎÂËÅÍÈÅ)" or ""), mainWin, imgui.WindowFlags.NoResize);
			--imgui.SetWindowFontScale(1.1)
			--///// Func menu button
			imgui.BeginChild("Main menu", imgui.ImVec2(155, 0), true)
				if ButtonMenu(fa.ICON_USERS .. u8"  Ãëàâíîå", select_menu[1]) then select_menu = {true, false, false, false, false, false, false}; end
					imgui.Spacing()
				imgui.Separator()
					imgui.Spacing()
				if ButtonMenu(fa.ICON_WRENCH .. u8"  Íàñòðîéêè", select_menu[2]) then select_menu = {false, true, false, false, false, false, false} end
					imgui.Spacing()
				imgui.Separator()
					imgui.Spacing()
				if ButtonMenu(fa.ICON_FILE .. u8"  Øïîðû", select_menu[3]) then 
					select_menu = {false, false, true, false, false, false, false}; 
					getSpurFile() 
					spur.name.v = ""
					spur.text.v = ""
					spur.edit = false
					spurBig.v = false
					spur.select_spur = -1
				end
					imgui.Spacing()
				imgui.Separator()
					imgui.Spacing()
				if ButtonMenu(fa.ICON_TERMINAL .. u8"  Êîìàíäû", select_menu[4]) then select_menu = {false, false, false, true , false, false, false} end	
					imgui.Spacing()
				imgui.Separator()
					imgui.Spacing()
				if ButtonMenu(fa.ICON_KEYBOARD_O .. u8"  Áèíäåð", select_menu[5]) then select_menu = {false, false, false, false, true, false, false} end
					imgui.Spacing()
				imgui.Separator()
					imgui.Spacing()
				--[[if ButtonMenu(fa.ICON_QUESTION .. u8"  Ïîìîùü", select_menu[6]) then select_menu = {false, false, false, false, false, true, false} end
					imgui.Spacing()
				imgui.Separator()
					imgui.Spacing()]]
				if ButtonMenu(fa.ICON_SEARCH .. u8"  Î ñêðèïòå", select_menu[7]) then select_menu = {false, false, false, false, false, false, true} end
					imgui.Spacing()
			imgui.EndChild();
			--///// Main menu
			if select_menu[1] then
			imgui.SameLine()
			imgui.BeginGroup()
				if logoFDH then
					imgui.Image(logoFDH, imgui.ImVec2(670, 200))
				end
				local colorInfo = imgui.ImColor(240, 170, 40, 255):GetVec4()
				imgui.Separator()
				imgui.SetCursorPosX(425)
				imgui.Text(u8"Èíôîðìàöèÿ î ñîòðóäíèêå");
					imgui.Dummy(imgui.ImVec2(0, 25))
					imgui.Indent(10)
					imgui.Text(fa.ICON_ADDRESS_CARD .. u8"  Èìÿ Ôàìèëèÿ ñîòðóäíèêà: ");
						imgui.SameLine();
						imgui.TextColored(colorInfo, PlayerSet.name())
						imgui.SameLine();
						imgui.TextColored(colorInfo, PlayerSet.teg())
						imgui.Dummy(imgui.ImVec2(0, 5))
					imgui.Text(fa.ICON_HOSPITAL_O .. u8"  Ñîñòîèò â îðãàíèçàöèè: ");
						imgui.SameLine();
						imgui.TextColored(colorInfo, PlayerSet.org());
						imgui.Dummy(imgui.ImVec2(0, 5))
					imgui.Text(fa.ICON_USER .. u8"  Äîëæíîñòü: ");
						imgui.SameLine();
						imgui.TextColored(colorInfo, PlayerSet.rank());
						imgui.Dummy(imgui.ImVec2(0, 5))
					imgui.Text(fa.ICON_TRANSGENDER .. u8"  Ïîë: ");
						imgui.SameLine();
						imgui.TextColored(colorInfo, PlayerSet.sex())
				imgui.EndGroup()
			end
			--/////Setting
			if select_menu[2] then
			imgui.SameLine()
			imgui.BeginGroup()
			imgui.BeginChild("setting", imgui.ImVec2(0, 390), true)
				imgui.Text(fa.ICON_ANGLE_RIGHT .. u8" Äàííûé ðàçäåë ïðåäíàçíà÷åí äëÿ ïîëíîé íàñòðîéêè ñêðèïòà ïîä ñâîé âêóñ");
				imgui.Separator()
				imgui.Dummy(imgui.ImVec2(0, 5))
				imgui.Indent(10) -- imgui.SetCursorPosX
				if imgui.CollapsingHeader(u8"Îñíîâíàÿ èíôîðìàöèÿ") then
					mainSet()
				end
				imgui.Dummy(imgui.ImVec2(0, 3))
				if imgui.CollapsingHeader(u8"Íàñòðîéêè ÷àòà") then
					imgui.SetCursorPosX(25)
					imgui.BeginGroup()
						if imgui.Checkbox(u8"Ñêðûòü îáúÿâëåíèÿ", cb_chat1) then needSave = true end
						if imgui.Checkbox(u8"Ñêðûòü ïîäñêàçêè ñåðâåðà", cb_chat2) then needSave = true end
						if imgui.Checkbox(u8"Ñêðûòü íîâîñòè ÑÌÈ", cb_chat3) then needSave = true end
						if imgui.Checkbox(u8"ChatHUD", cb_hud) then needSave = true end;
						imgui.SameLine(); ShowHelpMarker(u8"Ïîëåçíàÿ èíôîðìàöèÿ ïîä \nîêíîì ââîäà ÷àòà")
						if imgui.Checkbox(u8"TimeHUD", cb_hudTime) then needSave = true end
						imgui.SameLine(); ShowHelpMarker(u8"Îòîáðæåíèå âðåìåíè, ÿçûêà è Caps Lock\n â íèæíåé ëåâîé ÷àñòè ýêðàíà")
					imgui.EndGroup()
				end
				imgui.Dummy(imgui.ImVec2(0, 3))
				if imgui.CollapsingHeader(u8"Îòûãðîâêè") then
					imgui.Separator()
					imgui.SetCursorPosX(25)
					imgui.BeginGroup()
						imgui.PushItemWidth(400); 
							imgui.SetCursorPosX(255)
							imgui.Text(u8"×àñû")
							if imgui.Checkbox(u8"Îòûãðîâêà /me", cb_time) then needSave = true end
							if imgui.Checkbox(u8"Îòûãðîâêà /do", cb_timeDo) then needSave = true end
							if imgui.InputText(u8"Òåêñò îòûãðîâêè", buf_time) then needSave = true end
							imgui.Separator()
							imgui.SetCursorPosX(255)
							imgui.Text(u8"Ðàöèÿ")
							if imgui.Checkbox(u8"Îòûãðîâêà /me##1", cb_rac) then needSave = true end
							if imgui.InputText(u8"Òåêñò îòûãðîâêè##1", buf_rac) then needSave = true end
						imgui.PopItemWidth()
						imgui.Spacing()
						if imgui.Button(u8"Ðåäàêòèðîâàòü ãëàâíóþ îòûãðîâêó", imgui.ImVec2(250, 25)) then 
							mainEditWin.v = not mainEditWin.v
						end
					imgui.EndGroup();
				end
				

			imgui.EndChild();
			
			imgui.PushStyleColor(imgui.Col.Button, needSaveColor) -- 
			if imgui.Button(u8"Ñîõðàíèòü", imgui.ImVec2(672, 20)) then
		
			setting.nick = u8:decode(buf_nick.v)
			setting.teg = u8:decode(buf_teg.v)
			setting.org = num_org.v
			setting.sex = num_sex.v
			setting.rank = num_rank.v
			setting.time = cb_time.v
			setting.timeTx = u8:decode(buf_time.v)
			setting.timeDo = cb_timeDo.v
			setting.rac = cb_rac.v
			setting.racTx = u8:decode(buf_rac.v)
			setting.chat1 = cb_chat1.v
			setting.chat2 = cb_chat2.v
			setting.chat3 = cb_chat3.v
			setting.chathud = cb_hud.v
			setting.arp = arep
			setting.setver = setver
			setting.htime = cb_hudTime.v
			setting.hping = hudPing
			setting.orgl = {}
			setting.rankl = {}
			for i,v in ipairs(chgName.org) do
				setting.orgl[i] = u8:decode(v)
			end
			for i,v in ipairs(chgName.rank) do
				setting.rankl[i] = u8:decode(v)
			end
				local f = io.open(dirml.."/FDHelper/MainSetting.fd", "w")
				f:write(encodeJson(setting))
				f:flush()
				f:close()
				sampAddChatMessage(SCRIPT_PREFIX.."Íàñòðîéêè ñîõðàíåíû.", SCRIPT_COLOR)
				needSave = false
			end
			imgui.PopStyleColor(1)
			imgui.EndGroup()
			end
			--/////shpora
			if select_menu[3] then
			imgui.SameLine()
				imgui.BeginGroup()
					imgui.BeginChild("spur list", imgui.ImVec2(140, 390), true)
						imgui.SetCursorPosX(10)
						imgui.Text(u8"Ñïèñîê øïàðãàëîê")
						imgui.Separator()
							for i,v in ipairs(spur.list) do
								if imgui.Selectable(u8(spur.list[i]), spur.select_spur == i) then 
									spur.select_spur = i 
									spur.text.v = ""
									spur.name.v = ""
									spur.edit = false
									spurBig.v = false
								end
							end
					imgui.EndChild()
					if imgui.Button(u8"Äîáàâèòü", imgui.ImVec2(140, 20)) then
						if #spur.list ~= 20 then
							for i = 1, 20 do
								if not table.concat(spur.list, "|"):find("Øïàðãàëêà '"..i.."'") then
									table.insert(spur.list, "Øïàðãàëêà '"..i.."'")
									spur.edit = true
									spur.select_spur = #spur.list
									spur.name.v = ""
									spur.text.v = ""
									spurBig.v = false
									local f = io.open(dirml.."/FDHelper/Øïàðãàëêè/Øïàðãàëêà '"..i.."'.txt", "w")
									f:write("")
									f:flush()
									f:close()
									break
								end
							end
						end
					end
				imgui.EndGroup()
					imgui.SameLine()
				imgui.BeginGroup()
					--	
						if spur.edit and not spurBig.v then
							imgui.SetCursorPosX(515)
							imgui.Text(u8"Ïîëå äëÿ çàïîëíåíèÿ")
							imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImColor(70, 70, 70, 200):GetVec4())
							imgui.InputTextMultiline("##spur", spur.text, imgui.ImVec2(525, 315))
							imgui.PopStyleColor(1)
							imgui.PushItemWidth(400)
						--	imgui.SetCursorPosX(155+140+110)
							if imgui.Button(u8"Îòêðûòü áîëüøîé ðåäàêòîð/ïðîñìîòð", imgui.ImVec2(525, 20)) then spurBig.v = not spurBig.v end
							imgui.Spacing() 
						--	imgui.SetCursorPosX(445)
							imgui.InputText(u8"Íàçâàíèå øïîðû", spur.name, imgui.InputTextFlags.CallbackCharFilter, filter(1, "[%wà-ß%+%¹%#%(%)]"))
							imgui.Spacing()
							imgui.PopItemWidth()
						--	imgui.SetCursorPosX(415)
							if imgui.Button(u8"Óäàëèòü", imgui.ImVec2(260, 20)) then
								if doesFileExist(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt") then
									os.remove(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt")
								end
								table.remove(spur.list, spur.select_spur) 
								spur.edit = false
								spur.select_spur = -1
								spur.name.v = ""
								spur.text.v = ""
							end
							imgui.SameLine()
							if imgui.Button(u8"Ñîõðàíèòü", imgui.ImVec2(260, 20)) then
								local name = ""
								local bool = false
								if spur.name.v ~= "" then 
										name = u8:decode(spur.name.v)
										if doesFileExist(dirml.."/FDHelper/Øïàðãàëêè/"..name..".txt") and spur.list[spur.select_spur] ~= name then
											bool = true
											imgui.OpenPopup(u8"Îøèáêà")
										else
											os.remove(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt")
											spur.list[spur.select_spur] = u8:decode(spur.name.v)
										end
								else
									name = spur.list[spur.select_spur]
								end
								if not bool then
									local f = io.open(dirml.."/FDHelper/Øïàðãàëêè/"..name..".txt", "w")
									f:write(u8:decode(spur.text.v))
									f:flush()
									f:close()
									spur.text.v = ""
									spur.name.v = ""
									spur.edit = false
								end
							end
						elseif spurBig.v then
							imgui.Dummy(imgui.ImVec2(0, 150))
							imgui.SetCursorPosX(500)
							imgui.TextColoredRGB("Âêëþ÷åíî áîëüøîå îêíî")
						elseif not spurBig.v and (spur.select_spur >= 1 and spur.select_spur <= 20) then
							imgui.Dummy(imgui.ImVec2(0, 150))
							imgui.SetCursorPosX(515)
							imgui.Text(u8"Âûáåðèòå äåéñòâèå")
							imgui.Spacing()
							imgui.Spacing()
							imgui.SetCursorPosX(490)
							if imgui.Button(u8"Îòêðûòü äëÿ ïðîñìîòðà", imgui.ImVec2(170, 20)) then
								spurBig.v = true
							end
							imgui.Spacing()
							imgui.SetCursorPosX(490)
							if imgui.Button(u8"Ðåäàêòèðîâàòü", imgui.ImVec2(170, 20)) then
								spur.edit = true
								local f = io.open(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt", "r")
								spur.text.v = u8(f:read("*a"))
								f:close()
								spur.name.v = u8(spur.list[spur.select_spur])
							end
							imgui.Spacing()
							imgui.SetCursorPosX(490)
							if imgui.Button(u8"Óäàëèòü", imgui.ImVec2(170, 20)) then
								if doesFileExist(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt") then
									os.remove(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt")
								end
								table.remove(spur.list, spur.select_spur) 
								spur.select_spur = -1
							end
						else
						imgui.Dummy(imgui.ImVec2(0, 150))
						imgui.SetCursorPosX(370)
						imgui.TextColoredRGB("Íàæìèòå íà êíîïêó {FF8400}\"Äîáàâèòü\"{FFFFFF}, ÷òîáû ñîçäàòü íîâóþ øïàðãàëêó\n\t\t\t\t\t\t\t\t\tèëè âûáåðèòå óæå ñóùåñòâóþùèé.")
						end

				imgui.EndGroup()
			end
			--/////Command
			if select_menu[4] then
			imgui.SameLine()
			imgui.BeginGroup()
				imgui.Text(u8"Çäåñü íàõîäèòñÿ ñïèñîê íîâûõ êîìàíä, ê êîòîðûì ìîæåòå ïðèìåíèòü êëàâèøó àêòèâàöèè.")
				imgui.Separator();
				imgui.Dummy(imgui.ImVec2(0, 5))
				imgui.BeginChild("cmd list", imgui.ImVec2(0, 335), true)
					imgui.Columns(3, "keybinds", true); 
					imgui.SetColumnWidth(-1, 80); 
					imgui.Text(u8"Êîìàíäà"); 
					imgui.NextColumn();
					imgui.SetColumnWidth(-1, 450); 
					imgui.Text(u8"Îïèñàíèå"); 
					imgui.NextColumn(); 
					imgui.Text(u8"Êëàâèøà"); 
					imgui.NextColumn(); 
					imgui.Separator();
					for i,v in ipairs(cmdBind) do
						if num_rank.v+1 >= v.rank then
							if imgui.Selectable(u8(v.cmd), selected_cmd == i, imgui.SelectableFlags.SpanAllColumns) then selected_cmd = i end
							imgui.NextColumn(); 
							imgui.Text(u8(v.desc)); 
							imgui.NextColumn();
							if #v.key == 0 then imgui.Text(u8"Íåò") else imgui.Text(table.concat(rkeys.getKeysName(v.key), " + ")) end	
							imgui.NextColumn()
						else
							imgui.PushStyleColor(imgui.Col.Text, imgui.ImColor(228, 70, 70, 202):GetVec4())
							if imgui.Selectable(u8(v.cmd), selected_cmd == i, imgui.SelectableFlags.SpanAllColumns) then selected_cmd = i end
							imgui.NextColumn(); 
							imgui.Text(u8(v.desc)); 
							imgui.NextColumn(); 
							if #v.key == 0 then imgui.Text(u8"Íåò") else imgui.Text(table.concat(rkeys.getKeysName(v.key), " + ")) end	
							imgui.NextColumn()
							imgui.PopStyleColor(1)
						end
					end
				imgui.EndChild();
					if cmdBind[selected_cmd].rank <= num_rank.v+1 then
						imgui.Text(u8"Âûáåðèòå ñíà÷àëà èíòåðåñóþùóþ Âàñ êîìàíäó, ïîñëå ÷åãî ìîæåòå ïðîèçâîäèòü ðåäàêòèðîâàíèå.")
						if imgui.Button(u8"Íàçíà÷èòü êëàâèøó", imgui.ImVec2(140, 20)) then 
							imgui.OpenPopup(u8"FDH | Óñòàíîâêà êëàâèøè äëÿ àêòèâàöèè");
							lockPlayerControl(true)
							editKey = true
						end
						imgui.SameLine();
						if imgui.Button(u8"Î÷èñòèòü àêòèâàöèþ", imgui.ImVec2(140, 20)) then 
							rkeys.unRegisterHotKey(cmdBind[selected_cmd].key)
							unRegisterHotKey(cmdBind[selected_cmd].key)
							cmdBind[selected_cmd].key = {}
								local f = io.open(dirml.."/FDHelper/cmdSetting.fd", "w")
								f:write(encodeJson(cmdBind))
								f:flush()
								f:close()
						end
						imgui.SameLine();
					else
						imgui.Text(u8"Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Äîñòóïíà òîëüêî îò " .. cmdBind[selected_cmd].rank .. u8" ðàíãà")
						imgui.Text(u8"Åñëè Âàø ðàíã ñîîòâåòñòâóåò òðåáîâàíèÿì, ïîæàëóéñòà èçìåíèòå äîëæíîñòü â íàñòðîéêàõ.")
					end
					
			imgui.EndGroup()

			end
			--//////Binder
			if select_menu[5] then
				imgui.SameLine()
				imgui.BeginGroup()
					imgui.BeginChild("bind list", imgui.ImVec2(140, 390), true)
						imgui.SetCursorPosX(20)
						imgui.Text(u8"Ñïèñîê áèíäîâ")
						imgui.Separator()
							for i,v in ipairs(binder.list) do
								if imgui.Selectable(u8(binder.list[i].name), binder.select_bind == i) then 
									binder.select_bind = i;
									
									binder.name.v = u8(binder.list[binder.select_bind].name)
									binder.sleep.v = binder.list[binder.select_bind].sleep
									binder.key = binder.list[binder.select_bind].key
									binder.cmd.v = (binder.list[binder.select_bind].cmd ~= nil and u8(binder.list[binder.select_bind].cmd) or "")
									if doesFileExist(dirml.."/FDHelper/Binder/bind-"..binder.list[binder.select_bind].name..".txt") then
										local f = io.open(dirml.."/FDHelper/Binder/bind-"..binder.list[binder.select_bind].name..".txt", "r")
										binder.text.v = u8(f:read("*a"))
										f:flush()
										f:close()
									end
									binder.edit = true 
								end
							end
					imgui.EndChild()
					if imgui.Button(u8"Äîáàâèòü", imgui.ImVec2(140, 20)) then
						if #binder.list < 100 then
							for i = 1, 100 do
								local bool = false
								for ix,v in ipairs(binder.list) do
									if v.name == "Noname bind '"..i.."'" then bool = true end
								end
								if not bool then
									binder.list[#binder.list+1] = {name = "Noname bind '"..i.."'", key = {}, sleep = 0.5}
									binder.edit = true
									binder.select_bind = #binder.list
									binder.name.v = ""
									binder.sleep.v = 0.5
									binder.text.v = ""
									binder.cmd.v = ""
									binder.key = {}
									break 
								end
							end
						end
					end

				imgui.EndGroup() 
					imgui.SameLine()
				imgui.BeginGroup()
					--	
						if binder.edit then
							imgui.SetCursorPosX(500)
							imgui.Text(u8"Ïîëå äëÿ çàïîëíåíèÿ")
							imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImColor(70, 70, 70, 200):GetVec4())
							imgui.InputTextMultiline("##bind", binder.text, imgui.ImVec2(525, 275))
							imgui.PopStyleColor(1)
							imgui.PushItemWidth(150)
							imgui.InputText(u8"Íàçâàíèå áèíäà", binder.name, imgui.InputTextFlags.CallbackCharFilter, filter(1, "[%wà-ß%+%¹%#%(%)]"))
							
							--[[imgui.TextColoredRGB("Òåêóùàÿ êîìàíäà: /")
							imgui.SameLine()
							imgui.InputText(u8"##cmd", binder.cmd, imgui.InputTextFlags.CallbackCharFilter, filter(1, "[%wà-ß%+%¹%#%(%)]"))
							---
							if isHotKeyDefined then
								imgui.SameLine()
								imgui.TextColoredRGB("{FF0000}Äàííàÿ êîìàíäà óæå ñóùåñòâóåò!")
							end
							if russkieBukviNahyi then
								imgui.SameLine()
								imgui.TextColoredRGB("{FF0000}Íåëüçÿ èñïîëüçîâàòü ðóññêèå áóêâû!")
							end
							if dlinaStroki then
								imgui.SameLine()
								imgui.TextColoredRGB("{FF0000}Ìàêñèìàëüíàÿ äëèíà êîìàíäû - 15 áóêâ!")
							end		
							if binder.cmd.v:find("%A") then
								russkieBukviNahyi = true
								isHotKeyDefined = false
								dlinaStroki = false
								exits = true
							elseif binder.cmd.v:len() > 15 then
								dlinaStroki = true
								russkieBukviNahyi = false
								isHotKeyDefined = false
								exits = true
							end
							for i,v in ipairs(cmdBind) do
								if v.cmd == binder.cmd.v then
									exits = true
									isHotKeyDefined = true
									russkieBukviNahyi = false
									dlinaStroki = false
								end
							end
							for i,v in ipairs(binder.list) do
								if binder.list[i].cmd == binder.cmd.v and binder.cmd.v ~= binder.cmd.v and binder.cmd.v ~= "" then
									exits = true
									isHotKeyDefined = true
									russkieBukviNahyi = false
									dlinaStroki = false
								end
							end
							---]]
							if imgui.Button(u8"Çàäàòü êîìàíäó", imgui.ImVec2(150, 20)) then 
								chgName.inp.v = binder.cmd.v
								unregcmd = chgName.inp.v
								imgui.OpenPopup(u8"FDH | Ðåäàêòèðîâàíèå êîìàíäû áèíäà")
								editKey = true
							end
							if imgui.BeginPopupModal(u8"FDH | Ðåäàêòèðîâàíèå êîìàíäû áèíäà", null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
								isHotKeyDefined = false
								russkieBukviNahyi = false
								dlinaStroki = false
								editKey = false
								unregcmd = ""
								imgui.SetCursorPosX(70)
								imgui.Text(u8"Ââåäèòå íîâóþ êîìàíäó íà ýòîò áèíä, êîòîðóþ Âû ïîæåëàåòå."); imgui.Separator()
								imgui.Text(u8"Ïðèìå÷àíèÿ:")
								imgui.Bullet()	imgui.TextColoredRGB("{00ff8c}Ðàçðåøàåòñÿ çàìåíÿòü ñåðâåðíûå êîìàíäû.")
								imgui.Bullet()	imgui.TextColoredRGB("{00ff8c}Åñëè Âû çàìåíèòå ñåðâåðíóþ êîìàíäó - Âàøà êîìàíäà ñòàíåò ïðèîðèòåòíîé.")
								imgui.Bullet()	imgui.TextColoredRGB("{00ff8c}Íåëüçÿ èñïîëüçîâàòü öèôðû è ñèìâîëû. Òîëüêî àíãëèéñêèå áóêâû.")
								imgui.Text(u8"/");
								imgui.SameLine();
								imgui.PushItemWidth(520)
								imgui.InputText(u8"##inpcastname", chgName.inp, 512, filter(1, "[%a]+"))
								if isHotKeyDefined then
									imgui.TextColoredRGB("{FF0000}[Îøèáêà]{FFFFFF} Äàííàÿ êîìàíäà óæå ñóùåñòâóåò!")
								end
								if russkieBukviNahyi then
									imgui.TextColoredRGB("{FF0000}[Îøèáêà]{FFFFFF} Íåëüçÿ èñïîëüçîâàòü ðóññêèå áóêâû!")
								end
								if dlinaStroki then
									imgui.TextColoredRGB("{FF0000}[Îøèáêà]{FFFFFF} Ìàêñèìàëüíàÿ äëèíà êîìàíäû - 15 áóêâ!")
								end		
								if select_menu[5] then
									if imgui.Button(u8"Ïðèìåíèòü", imgui.ImVec2(174, 0)) then
										local exits = false
										if chgName.inp.v:find("%A") then
											russkieBukviNahyi = true
											isHotKeyDefined = false
											dlinaStroki = false
											exits = true
										elseif chgName.inp.v:len() > 15 then
											dlinaStroki = true
											russkieBukviNahyi = false
											isHotKeyDefined = false
											exits = true
										end
										for i,v in ipairs(cmdBind) do
											if v.cmd == chgName.inp.v then
												exits = true
												isHotKeyDefined = true
												russkieBukviNahyi = false
												dlinaStroki = false
											end
										end
										for i,v in ipairs(binder.list) do
											if binder.list[i].cmd == chgName.inp.v and chgName.inp.v ~= binder.cmd.v and chgName.inp.v ~= "" then
												exits = true
												isHotKeyDefined = true
												russkieBukviNahyi = false
												dlinaStroki = false
											end
										end
										if not exits then
											if binder.cmd.v == chgName.inp.v then
												unregcmd = ""
												isHotKeyDefined = false
												russkieBukviNahyi = false
												dlinaStroki = false
												imgui.CloseCurrentPopup();
												editKey = false
											else
												isHotKeyDefined = false
												russkieBukviNahyi = false
												dlinaStroki = false
												binder.cmd.v = chgName.inp.v
												imgui.CloseCurrentPopup();
												editKey = false
											end
										end
									end
								end				
								imgui.SameLine();
								if imgui.Button(u8"Çàêðûòü", imgui.ImVec2(174, 0)) then 
									imgui.CloseCurrentPopup(); 
									currentKey = {"",{}}
									cb_RBUT.v = false
									cb_x1.v, cb_x2.v = false, false
									lockPlayerControl(false)
									isHotKeyDefined = false
									russkieBukviNahyi = false
									dlinaStroki = false
									editKey = false
									unregcmd = ""
								end 
								imgui.SameLine()
								if select_menu[5] then
									if imgui.Button(u8"Î÷èñòèòü ñòðîêó", imgui.ImVec2(174, 0)) then
										chgName.inp.v = ""
										isHotKeyDefined = false
										russkieBukviNahyi = false
										dlinaStroki = false
									end
								end
							imgui.EndPopup()
						end
							imgui.SetCursorPosX(50)
							if binder.cmd.v == "" then
								imgui.SameLine()
								imgui.TextColoredRGB("Òåêóùàÿ êîìàíäà: {F02626}Îòñóòñòâóåò")
							else
								imgui.SameLine()
								imgui.TextColoredRGB("Òåêóùàÿ êîìàíäà: {1AEB1D}/"..binder.cmd.v)
							end
							---
							if imgui.Button(u8"Íàçíà÷èòü êëàâèøó", imgui.ImVec2(150, 20)) then 
								imgui.OpenPopup(u8"FDH | Óñòàíîâêà êëàâèøè äëÿ àêòèâàöèè")
								editKey = true
							end 
							imgui.SameLine()
							imgui.TextColoredRGB("Àêòèâàöèÿ: "..table.concat(rkeys.getKeysName(binder.key), " + "))
							imgui.DragFloat("##sleep", binder.sleep, 0.1, 0.5, 10.0, u8"Çàäåðæêà = %.1f ñåê.")
							imgui.SameLine()
							if imgui.Button("-", imgui.ImVec2(20, 20)) and binder.sleep.v ~= 0.5 then binder.sleep.v = binder.sleep.v - 0.1 end
							imgui.SameLine()
							if imgui.Button("+", imgui.ImVec2(20, 20)) and binder.sleep.v ~= 10 then binder.sleep.v = binder.sleep.v + 0.1 end
							imgui.PopItemWidth()
							imgui.SameLine()
							imgui.Text(u8"Èíòåðâàë âðåìåíè ìåæäó ïðîèãðûâàíèåì ñòðîê")
						--	imgui.SetCursorPosX(345)
							if imgui.Button(u8"Óäàëèòü", imgui.ImVec2(127, 20)) then
								binder.text.v = ""
								binder.sleep.v = 0.5
								binder.name.v = ""
								sampUnregisterChatCommand(binder.cmd.v)
								binder.cmd.v = ""
								binder.edit = false 
								rkeys.unRegisterHotKey(binder.key)
								unRegisterHotKey(binder.key)
								binder.key = {}
								if doesFileExist(dirml.."/FDHelper/Binder/bind-"..binder.list[binder.select_bind].name..".txt") then
									os.remove(dirml.."/FDHelper/Binder/bind-"..binder.list[binder.select_bind].name..".txt")
								end
								table.remove(binder.list, binder.select_bind) 
								local f = io.open(dirml.."/FDHelper/bindSetting.fd", "w")
								f:write(encodeJson(binder.list))
								f:flush()
								f:close()
								binder.select_bind = -1 
							end
							imgui.SameLine()
							if imgui.Button(u8"Ñîõðàíèòü", imgui.ImVec2(127, 20)) then
								local bool = false
									if binder.name.v ~= "" then
										for i,v in ipairs(binder.list) do
											if v.name == u8:decode(binder.name.v) and i ~= binder.select_bind then bool = true end
										end
										if not bool then
											binder.list[binder.select_bind].name = u8:decode(binder.name.v)
										else
											imgui.OpenPopup(u8"Îøèáêà")
										end
									end
								if not bool then
									rkeys.registerHotKey(binder.key, true, onHotKeyBIND)
									binder.list[binder.select_bind].key = binder.key
									local sec = string.format("%.1f", binder.sleep.v)
									binder.list[binder.select_bind].sleep = sec
									binder.list[binder.select_bind].cmd = binder.cmd.v:gsub("/","")
									sampUnregisterChatCommand(unregcmd)
									local text = u8:decode(binder.text.v)
									local saveJS = encodeJson(binder.list) 
									for i,v in ipairs(binder.list) do
										sampRegisterChatCommand(binder.list[i].cmd, function() binderCmdStart() end)
									end
									local f = io.open(dirml.."/FDHelper/bindSetting.fd", "w")
									local ftx = io.open(dirml.."/FDHelper/Binder/bind-"..binder.list[binder.select_bind].name..".txt", "w")
									f:write(saveJS)
									ftx:write(text)
									f:flush()
									ftx:flush()
									f:close()
									ftx:close()
								end
							end
							imgui.SameLine()
							if imgui.Button(u8"Òåã-ôóíêöèè", imgui.ImVec2(127, 20)) then paramWin.v = not paramWin.v end
							imgui.SameLine()
							if imgui.Button(u8"Ðàñøèðåííûå", imgui.ImVec2(127, 20)) then profbWin.v = not profbWin.v end
							
							
						else
						
						imgui.Dummy(imgui.ImVec2(0, 150))
						imgui.SetCursorPosX(380)
						imgui.TextColoredRGB("Íàæìèòå íà êíîïêó {FF8400}\"Äîáàâèòü\"{FFFFFF}, ÷òîáû ñîçäàòü íîâûé áèíä\n\t\t\t\t\t\t\t\tèëè âûáåðèòå óæå ñóùåñòâóþùèé.")
						end

				imgui.EndGroup()
			end
			--//////Help
			if select_menu[6] then
				imgui.SameLine()
				imgui.BeginChild("help but", imgui.ImVec2(0,0), true)
					imgui.Text(u8"Íåìíîãî èíôîðìàöèè, êîòîðàÿ ìîæåò ïîìî÷ü Âàì.")
					imgui.Separator()
					--
					imgui.Bullet(); imgui.SameLine()
					imgui.TextColoredRGB("{FFB700}Âêëàäêà \"Íàñòðîéêè\"")
					imgui.TextWrapped(u8"\tÁàçîâûå íàñòðîéêè, êîòîðûå òðåáóåòñÿ âûñòàâèòü ïåðåä íà÷àëîì ðàáîòû, ñàìûå ãëàâíûå êîòîðûå èç íèõ \"Îñíîâíàÿ èíôîðìàöèÿ\".")
					--
					imgui.Bullet(); imgui.SameLine()
					imgui.TextColoredRGB("{FFB700}Âêëàäêà \"Øïîðû\"")
					imgui.TextWrapped(u8"\tÌîæíî çàïîëíÿòü ëþáîãî ðîäà èíôîðìàöèåé, òàêæå ìîæíî ñàìîìó ñîçäàòü òåêñòîâûé ôàéë â ïàïêå øïàðãàëîê.")
					imgui.TextColoredRGB("{5BF165}Îòêðûòü ïàïêó Øïàðãàëîê")
					if imgui.IsItemHovered() then 
						imgui.SetTooltip(u8"Êëèêíèòå, ÷òîáû îòêðûòü ïàïêó.")
					end
					if imgui.IsItemClicked(0) then
						print(shell32.ShellExecuteA(nil, 'open', dirml.."/FDHelper/Øïàðãàëêè/", nil, nil, 1))
					end
					--
					imgui.Bullet(); imgui.SameLine()
					imgui.TextColoredRGB("{FFB700}Âêëàäêà \"Êîìàíäû\"")
					imgui.TextWrapped(u8"\tÎñîáåííîñòüþ àêòèâàöèåé êîìàíä ÿâëÿåòñÿ â òîì, ÷òî êîìàíäû òðåáóþùèå â óêàçàíèè id èãðîêà, ìîãóò áûòü àêòèâèðîâàíû ïðè ñî÷åòàíèè íàâåäíèè ìûøêè íà èãðîêà è íàæàòèè áèíä-àêòèâàöèè. Â ðåçóëüàòå ÷åãî, êîìàíäà àâòîìàòè÷åñêè ââåä¸òñÿ ñ óêàçàííûì id èãðîêà èëè îòêðîåòñÿ ÷àò ñ ââåä¸ííûì id.")
					imgui.TextColoredRGB("\t\tÄîïîëíèòåëüíûå êîìàíäû, íå âíåñ¸ííûå â ðàçäåë:")
					imgui.TextColoredRGB("{FF5F29}/fdrl {FFFFFF}- êîìàíäà äëÿ ïåðåçàãðóçêè ñêðèïòà.")
					--
					imgui.Separator()
					imgui.Spacing()
					imgui.TextColoredRGB("Â ñëó÷àå âîçíèêíîâåíèÿ ïðîáëåìû ñ çàïóñêîì ñêðèïòà ïîïðîáóéòå óäàëèòü ôàéëû íàñòðîåê ïîñëå\n ÷åãî ïåðåçàãðóçèòü ïàïêó moonloader êîìàíäîé {67EE7E}/rl:\n\t{FF5F29}MainSetting.fd \n\t{FF5F29}cmdSetting.fd \n\t{FF5F29}bindSetting.fd \n\tÒàêæå ïàïêó {FF5F29}Binder")
				imgui.EndChild()
			end
			--//////About
			if select_menu[7] then
				imgui.SameLine()
				imgui.BeginChild("about", imgui.ImVec2(0, 0), true)
					imgui.SetCursorPosX(280)
					imgui.Text(u8"Èíôîðìàöèÿ î ñêðèïòå")
					imgui.Spacing()
					
						imgui.Dummy(imgui.ImVec2(0, 40))
						imgui.SetCursorPosX(20)
						imgui.Text(fa.ICON_LINK)
						imgui.SameLine()
						imgui.TextColoredRGB("Àêòóàëüíàÿ âåðñèÿ - íà {74BAF4}GitHub")
							if imgui.IsItemHovered() then imgui.SetTooltip(u8"Êëèê ËÊÌ, ÷òîáû ñêîïèðîâàòü, èëè ÏÊÌ, ÷òîáû îòêðûòü â áðàóçåðå")  end
							if imgui.IsItemClicked(0) then setClipboardText("https://github.com/romanespit/Fire-Department-Helper/releases/latest") end
							if imgui.IsItemClicked(1) then print(shell32.ShellExecuteA(nil, 'open', 'https://github.com/romanespit/Fire-Department-Helper/releases/latest', nil, nil, 1)) end
						
					imgui.Bullet()
					imgui.TextColoredRGB("Ðàçðàáîò÷èê - {74BAF4}romanespit (Êîíñåðâà ñ 07)")
					if imgui.IsItemHovered() then imgui.SetTooltip(u8"Êëèê ËÊÌ, ÷òîáû ñêîïèðîâàòü, èëè ÏÊÌ, ÷òîáû îòêðûòü â áðàóçåðå")  end
					if imgui.IsItemClicked(0) then setClipboardText("https://romanespit.ru") end
					if imgui.IsItemClicked(1) then print(shell32.ShellExecuteA(nil, 'open', 'https://romanespit.ru', nil, nil, 1)) end
					imgui.Bullet()
					imgui.TextColoredRGB("Îñíîâà {74BAF4}MedicalHelper by Kevin Hatiko")
					if imgui.IsItemHovered() then imgui.SetTooltip(u8"Êëèê ËÊÌ, ÷òîáû ñêîïèðîâàòü, èëè ÏÊÌ, ÷òîáû îòêðûòü â áðàóçåðå")  end
					if imgui.IsItemClicked(0) then setClipboardText("https://github.com/TheMrThor/MedicalHelper") end
					if imgui.IsItemClicked(1) then print(shell32.ShellExecuteA(nil, 'open', 'https://github.com/TheMrThor/MedicalHelper', nil, nil, 1)) end	
					imgui.Bullet()
					imgui.TextColoredRGB("Ôèêñèë MedicalHelper {FFB700}ñûðíûé Alexandr_Morenzo c 07")
					imgui.Bullet()
					imgui.Text(fa.ICON_HEART)
					imgui.SameLine()
					imgui.TextColoredRGB(" {ad59ff}First Club")
					if imgui.IsItemHovered() then imgui.SetTooltip(u8"Êëèê ËÊÌ, ÷òîáû ñêîïèðîâàòü, èëè ÏÊÌ, ÷òîáû îòêðûòü â áðàóçåðå")  end
					if imgui.IsItemClicked(0) then setClipboardText("https://discord.com/invite/first-family") end
					if imgui.IsItemClicked(1) then print(shell32.ShellExecuteA(nil, 'open', 'https://discord.com/invite/first-family', nil, nil, 1)) end
					imgui.SameLine()
					imgui.TextColoredRGB(" â ñåðäå÷êå")
					imgui.TextColoredRGB("Òåêñòû, âûäåëåííûå {74BAF4}òàêèì öâåòîì {FFFFFF}êëèêàáåëüíû è âåäóò íà ñîîòâåòñòâóþùèå ðåñóðñû")
						imgui.Spacing()
						imgui.Dummy(imgui.ImVec2(0, 20))
						if imgui.Button(fa.ICON_WRENCH..u8" Ïåðåçàãðóçèòü ñêðèïò", imgui.ImVec2(180, 30)) then showCursor(false); scr:reload() end
						if newversion ~= scr.version then
							imgui.Dummy(imgui.ImVec2(0, 20))
							if imgui.Button(fa.ICON_FIRE..u8" Îáíîâèòü äî v"..newversion, imgui.ImVec2(180, 30)) then updateScript() end
						end
						
						imgui.EndChild()
			end

			--///Óñòàíîâêà êëàâèøè è êìä
				imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(0.06, 0.06, 0.06, 0.94))
				
				if imgui.BeginPopupModal(u8"FDH | Óñòàíîâêà êëàâèøè äëÿ àêòèâàöèè", null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
					
					imgui.Text(u8"Íàæìèòå íà êëàâèøó èëè ñî÷åòàíèå êëàâèø äëÿ óñòàíîâêè àêòèâàöèè."); imgui.Separator()
					imgui.Text(u8"Äîïóñêàþòñÿ êëàâèøè:")
					imgui.Bullet()	imgui.TextDisabled(u8"Êëàâèøè äëÿ ñî÷åòàíèé - Alt, Ctrl, Shift")
					imgui.Bullet()	imgui.TextDisabled(u8"Àíãëèéñêèå áóêâû")
					imgui.Bullet()	imgui.TextDisabled(u8"Ôóíêöèîíàëüíûå êëàâèøè F1-F12")
					imgui.Bullet()	imgui.TextDisabled(u8"Öèôðû âåðõíåé ïàíåëè")
					imgui.Bullet()	imgui.TextDisabled(u8"Áîêîâàÿ ïàíåëü Numpad")
					imgui.Checkbox(u8"Èñïîëüçîâàòü ÏÊÌ â êîìáèíàöèè ñ êëàâèøàìè", cb_RBUT)
					imgui.Separator()
					if imgui.TreeNode(u8"Äëÿ ïîëüçîâàòåëåé 5-êíîïî÷íîé ìûøè") then
						imgui.Checkbox(u8"X Button 1", cb_x1)
						imgui.Checkbox(u8"X Button 2", cb_x2)
						imgui.Separator()
					imgui.TreePop();
					end
					imgui.Text(u8"Òåêóùàÿ êëàâèøà(è): ");
					imgui.SameLine();
					
					if imgui.IsMouseClicked(0) then
						lua_thread.create(function()
							wait(500)
							
							setVirtualKeyDown(3, true)
							wait(0)
							setVirtualKeyDown(3, false)
						end)
					end
					
					if #(rkeys.getCurrentHotKey()) ~= 0 and not rkeys.isBlockedHotKey(rkeys.getCurrentHotKey()) then
						
						if not rkeys.isKeyModified((rkeys.getCurrentHotKey())[#(rkeys.getCurrentHotKey())]) then
							currentKey[1] = table.concat(rkeys.getKeysName(rkeys.getCurrentHotKey()), " + ")
							currentKey[2] = rkeys.getCurrentHotKey()
							
						end
					end
 
					imgui.TextColored(imgui.ImColor(255, 205, 0, 200):GetVec4(), currentKey[1])
						if isHotKeyDefined then
							imgui.TextColored(imgui.ImColor(45, 225, 0, 200):GetVec4(), u8"Äàííûé áèíä óæå ñóùåñòâóåò!")
						end
						if imgui.Button(u8"Óñòàíîâèòü", imgui.ImVec2(150, 0)) then
							if select_menu[4] then
								if cb_RBUT.v then table.insert(currentKey[2], 1, vkeys.VK_RBUTTON) end
								if cb_x1.v then table.insert(currentKey[2], vkeys.VK_XBUTTON1) end
								if cb_x2.v then table.insert(currentKey[2], vkeys.VK_XBUTTON2) end
								if rkeys.isHotKeyExist(currentKey[2]) then 
									isHotKeyDefined = true
								else
									rkeys.unRegisterHotKey(cmdBind[selected_cmd].key)
									unRegisterHotKey(cmdBind[selected_cmd].key)
									cmdBind[selected_cmd].key = currentKey[2]
									rkeys.registerHotKey(currentKey[2], true, onHotKeyCMD)
									table.insert(keysList, currentKey[2])
									currentKey = {"",{}}
									lockPlayerControl(false)
									cb_RBUT.v = false
									cb_x1.v, cb_x2.v = false, false
									isHotKeyDefined = false
									imgui.CloseCurrentPopup();
										local f = io.open(dirml.."/FDHelper/cmdSetting.fd", "w")
										f:write(encodeJson(cmdBind))
										f:flush()
										f:close()
										editKey = false
								end
							elseif select_menu[5] then
								if cb_RBUT.v then table.insert(currentKey[2], 1, vkeys.VK_RBUTTON) end
								if cb_x1.v then table.insert(currentKey[2], vkeys.VK_XBUTTON1) end
								if cb_x2.v then table.insert(currentKey[2], vkeys.VK_XBUTTON2) end
								if rkeys.isHotKeyExist(currentKey[2]) then 
									isHotKeyDefined = true
								else	
									rkeys.unRegisterHotKey(binder.list[binder.select_bind].key)
									unRegisterHotKey(binder.list[binder.select_bind].key)
									binder.key = currentKey[2]
									currentKey = {"",{}}
									lockPlayerControl(false)
									cb_RBUT.v = false
									cb_x1.v, cb_x2.v = false, false
									isHotKeyDefined = false
									imgui.CloseCurrentPopup();
									editKey = false
								end
							end
						end
						imgui.SameLine();
						if imgui.Button(u8"Çàêðûòü", imgui.ImVec2(150, 0)) then 
							imgui.CloseCurrentPopup(); 
							currentKey = {"",{}}
							cb_RBUT.v = false
							cb_x1.v, cb_x2.v = false, false
							lockPlayerControl(false)
							isHotKeyDefined = false
							editKey = false
						end 
						imgui.SameLine()
						if imgui.Button(u8"Î÷èñòèòü", imgui.ImVec2(150, 0)) then
							currentKey = {"",{}}
							cb_x1.v, cb_x2.v = false, false
							cb_RBUT.v = false
							isHotKeyDefined = false
						end
				imgui.EndPopup()
				end
				--remove script
				--[[
				if imgui.BeginPopupModal(u8"Óäàëåíèå ñêðèïòà", null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
					
					imgui.Text(u8"Âû òî÷íî óâåðåíû, ÷òî õîòèòå óäàëèòü ñêðèïò?");

						if imgui.Button(u8"Óäàëèòü", imgui.ImVec2(150, 0)) then
						end
						if imgui.Button(u8"Îòìåíà", imgui.ImVec2(150, 0)) then
							imgui.CloseCurrentPopup(); 
						end
				imgui.EndPopup()
				end
				]]
			
				
				if imgui.BeginPopupModal(u8"Îøèáêà", null, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoMove) then
					imgui.Text(u8"Äàííîå íàçâàíèå óæå ñóùåñòâóåò")
					imgui.SetCursorPosX(60)
					if imgui.Button(u8"Îê", imgui.ImVec2(120, 20)) then imgui.CloseCurrentPopup() end
				imgui.EndPopup()
				end
				
				imgui.PopStyleColor(1)
			imgui.End()
	end
	if iconwin.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(250, 900), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin("Icons ", iconwin, imgui.WindowFlags.NoResize);
			for i,v in pairs(fa) do
				if imgui.Button(fa[i].." - "..i, imgui.ImVec2(200, 25)) then setClipboardText(i) end
			end
			
		imgui.End()
	
	end
	if paramWin.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(820, 580), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		
		imgui.Begin(u8"Êîä-ïàðàìåòðû äëÿ áèíäåðà", paramWin, imgui.WindowFlags.NoResize);
		imgui.SetWindowFontScale(1.1)
		imgui.SetCursorPosX(50)
		imgui.TextColoredRGB("[center]{FFFF41}Êëèêíè ìûøêîé ïî ñàìîìó òåãó, ÷òîáû ñêîïèðîâàòü åãî.", imgui.GetMaxWidthByText("Êëèêíè ìûøêîé ïî ñàìîìó òåãó, ÷òîáû ñêîïèðîâàòü åãî."))
		imgui.Dummy(imgui.ImVec2(0, 15))
		
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myID}")
		imgui.SameLine()
		if imgui.IsItemHovered(0) then setClipboardText("{myID}") end
		imgui.TextColoredRGB("{C1C1C1} - Âàø id - {ACFF36}"..tostring(myid))
		
		imgui.Spacing()	
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myNick}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{myNick}");  end
		imgui.TextColoredRGB("{C1C1C1} - Âàø ïîëíûé íèê (ïî àíã.) - {ACFF36}"..tostring(myNick:gsub("_"," ")))
		
		imgui.Spacing()	
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myRusNick}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{myRusNick}") end
		imgui.TextColoredRGB("{C1C1C1} - Âàø íèê, óêàçàííûé â íàñòðîéêàõ - {ACFF36}"..tostring(u8:decode(buf_nick.v)))
		
		imgui.Spacing()	
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myHP}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{myHP}") end
		imgui.TextColoredRGB("{C1C1C1} - Âàø óðîâåíü ÕÏ - {ACFF36}"..tostring(getCharHealth(PLAYER_PED)))
		
		imgui.Spacing()	
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myArmo}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{myArmo}") end
		imgui.TextColoredRGB("{C1C1C1} - Âàø òåêóùèé óðîâåíü áðîíè - {ACFF36}"..tostring(getCharArmour(PLAYER_PED)))
		
		imgui.Spacing()	
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myOrg}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{myOrg}") end
		imgui.TextColoredRGB("{C1C1C1} - íàçâàíèå Âàøåé îðãàíèçàöèè - {ACFF36}"..tostring(u8:decode(chgName.org[num_org.v+1])))
		
		imgui.Spacing()	
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myOrgEn}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{myOrgEn}") end
		imgui.TextColoredRGB("{C1C1C1} - ïîëíîå íàçâàíèå Âàøåé îðãàíèçàöèè íà àíã. - {ACFF36}"..tostring(u8:decode(list_org_en[num_org.v+1])))
		
		imgui.Spacing()	
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myTag}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{myTag}") end
		imgui.TextColoredRGB("{C1C1C1} - Âàø ïîçûâíîé  - {ACFF36}"..tostring(u8:decode(buf_teg.v)))
		
		imgui.Spacing()		
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{myRank}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{myRank}") end
		imgui.TextColoredRGB("{C1C1C1} - Âàøà òåêóùàÿ äîëæíîñòü - {ACFF36}"..tostring(u8:decode(chgName.rank[num_rank.v+1])))
		
		imgui.Spacing()	
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{time}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{time}") end
		imgui.TextColoredRGB("{C1C1C1} - âðåìÿ â ôîðìàòå ÷àñû:ìèíóòû:ñåêóíäû - {ACFF36}"..tostring(os.date("%X")))
		
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{day}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{day}") end
		imgui.TextColoredRGB("{C1C1C1} - òåêóùèé äåíü ìåñÿöà - {ACFF36}"..tostring(os.date("%d")))

		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{week}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{week}") end
		imgui.TextColoredRGB("{C1C1C1} - òåêóùàÿ íåäåëÿ - {ACFF36}"..tostring(week[tonumber(os.date("%w"))+1]))

		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{month}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{month}") end
		imgui.TextColoredRGB("{C1C1C1} - òåêóùèé ìåñÿö - {ACFF36}"..tostring(month[tonumber(os.date("%m"))]))
		--
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{getNickByTarget}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{getNickByTarget}") end
		imgui.TextColoredRGB("{C1C1C1} - ïîëó÷àåò Íèê èãðîêà íà êîòîðîãî ïîñëåäíèé ðàç öåëèëñÿ.")
		--
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{target}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{target}") end
		imgui.TextColoredRGB("{C1C1C1} - ïîñëåäíèé ID èãðîêà, íà êîòîðîãî öåëèëñÿ (íàâåäåíà ìûøü) - {ACFF36}"..tostring(targID))
		--
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), "{pause}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{pause}") end
		imgui.TextColoredRGB("{C1C1C1} - ñîçäàíèå ïàóçû ìåæäó îòïðàâêè ñòðîêè â ÷àò. {EC3F3F}Ïðîïèñûâàòü îòäåëüíî, ò.å. ñ íîâîé ñòðîêè.")
		--
		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), u8"{sleep:âðåìÿ}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{sleep:1000}") end
		imgui.TextColoredRGB("{C1C1C1} - Çàäà¸ò ñâîé èíòåðâàë âðåìåíè ìåæäó ñòðî÷êàìè. \n\tÏðèìåð: {sleep:2500}, ãäå 2500 âðåìÿ â ìñ (1 ñåê = 1000 ìñ)")

		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), u8"{sex:òåêñò1|òåêñò2}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{sex:text1|text2}") end
		imgui.TextColoredRGB("{C1C1C1} - Âîçâðàùàåò òåêñò â çàâèñèìîñòè îò âûáðàííîãî ïîëà.  \n\tÏðèìåð, {sex:ïîíÿë|ïîíÿëà}, âåðí¸ò 'ïîíÿë', åñëè âûáðàí ìóæñêîé ïîë èëè 'ïîíÿëà', åñëè æåíñêèé")

		imgui.Spacing()
		imgui.TextColored(imgui.ImVec4(1,0.52,0,1), u8"{getNickByID:èä èãðîêà}")
		imgui.SameLine()
		if imgui.IsItemClicked(0) then setClipboardText("{getNickByID:}") end
		imgui.TextColoredRGB("{C1C1C1} - Âîçðàùàåò íèê èãðîêà ïî åãî ID. \n\tÏðèìåð, {getNickByID:25}, âåðí¸ò íèê èãðîêà ïîä ID 25.)")

		
		imgui.End()
	end
	if spurBig.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(1098, 790), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Ðåäàêòîð Øïàðãàëêè", spurBig, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoTitleBar);
	--	imgui.SetWindowFontScale(1.1)
		if spur.edit then
				imgui.SetCursorPosX(350)
				imgui.Text(u8"Áîëüøîå îêíî äëÿ ðåäàêòèðîâàíèÿ/ïðîñìîòðà øïàðãàëîê")
				imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImColor(70, 70, 70, 200):GetVec4())
				imgui.InputTextMultiline("##spur", spur.text, imgui.ImVec2(1081, 700))
				imgui.PopStyleColor(1)
				if imgui.Button(u8"Ñîõðàíèòü", imgui.ImVec2(357, 20)) then
					local name = ""
					local bool = false
					if spur.name.v ~= "" then 
							name = u8:decode(spur.name.v)
							if doesFileExist(dirml.."/FDHelper/Øïàðãàëêè/"..name..".txt") and spur.list[spur.select_spur] ~= name then
								bool = true
								imgui.OpenPopup(u8"Îøèáêà")
							else
								os.remove(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt")
								spur.list[spur.select_spur] = u8:decode(spur.name.v)
							end
					else
						name = spur.list[spur.select_spur]
					end
					if not bool then
						local f = io.open(dirml.."/FDHelper/Øïàðãàëêè/"..name..".txt", "w")
						f:write(u8:decode(spur.text.v))
						f:flush()
						f:close()
						spur.text.v = ""
						spur.name.v = ""
						spur.edit = false
					end
				end
				imgui.SameLine()
				if imgui.Button(u8"Óäàëèòü", imgui.ImVec2(357, 20)) then
					spur.text.v = ""
					table.remove(spur.list, spur.select_spur) 
					spur.select_spur = -1
					if doesFileExist(dirml.."/FDHelper/Øïàðãàëêè/"..u8:decode(spur.select_spur)..".txt") then
						os.remove(dirml.."/FDHelper/Øïàðãàëêè/"..u8:decode(spur.select_spur)..".txt")
					end
					spur.name.v = ""
					spurBig.v = false
					spur.edit = false
				end
				imgui.SameLine()
				if imgui.Button(u8"Âêëþ÷èòü ïðîñìîòð", imgui.ImVec2(357, 20)) then spur.edit = false end
				if imgui.Button(u8"Çàêðûòü", imgui.ImVec2(1081, 20)) then spurBig.v = not spurBig.v end
		else
			imgui.SetCursorPosX(380)
			imgui.Text(u8"Áîëüøîå îêíî äëÿ ðåäàêòèðîâàíèÿ/ïðîñìîòðà øïàðãàëîê")
			imgui.BeginChild("spur spec", imgui.ImVec2(1081, 730), true)
				if doesFileExist(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt") then
					for line in io.lines(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt") do
						imgui.TextWrapped(u8(line))
					end
				end
			imgui.EndChild()
			if imgui.Button(u8"Âêëþ÷èòü ðåäàêòèðîâàíèå", imgui.ImVec2(537, 20)) then 
				spur.edit = true
				local f = io.open(dirml.."/FDHelper/Øïàðãàëêè/"..spur.list[spur.select_spur]..".txt", "r")
				spur.text.v = u8(f:read("*a"))
				f:close()
			end
			imgui.SameLine()
			if imgui.Button(u8"Çàêðûòü", imgui.ImVec2(537, 20)) then spurBig.v = not spurBig.v end
		end
		imgui.End()
	end
	
	if mainEditWin.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(650, 420), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Ðåäàêòèðîâàíèå ãëàâíîé îòûãðîâêè", mainEditWin, imgui.WindowFlags.NoResize);
		imgui.SetWindowFontScale(1.1)
			imgui.InputTextMultiline("##mainedit", buf_mainedit, imgui.ImVec2(634, 350))
			if imgui.Button(u8"Ñîõðàíèòü", imgui.ImVec2(155, 25)) then
				local f = io.open(dirml.."/FDHelper/main.txt", "w")
				f:write(u8:decode(buf_mainedit.v))
				f:close() 
			end
			imgui.SameLine()
			if imgui.Button(u8"Ñáðîñèòü", imgui.ImVec2(155, 25)) then
				local textrp = [[
{sleep:0}
{dialog}
[name]=×òî äåëàåì?
//
[1]=Äîêëàä
{dialog}
[name]=Î ÷åì äîêëàäûâàåì?
[1]=Ïîñò
{dialog}
[name]=Êàêîé ïîñò?
[1]=Ïîñò 1
#postNumber=1
[2]=Ïîñò 2
#postNumber=2
[3]=Ïîñò 3
#postNumber=3
[4]=Ïîñò 4
#postNumber=4
[5]=Ïîñò 5
#postNumber=5
{dialogEnd}
{dialog}
[name]=Çàñòóïèë èëè óæå ñòîèøü?
[1]=Óæå ñòîþ
#zastup=Ïîñò
[2]=Çàñòóïèë
#zastup=Çàñòóïèë{sex:|à} íà ïîñò
{dialogEnd}
/r Äîêëàäûâàåò {myRusNick} ñ ïîðÿäêîâûì íîìåðîì {myID}. 
/r #zastup ¹#postNumber. Ñîñòîÿíèå: Ñòàáèëüíîå. ß ñòàòóñ 10-8
/r Êîíåö ñâÿçè.
[2]=Ïðèíÿë âûçîâ äèñïåò÷åðà
/r Ïðèíÿë{sex:|à} âûçîâ îò äèñïåò÷åðà!
/r Â ñðî÷íîì ïîðÿäêå âûåçæàþ íà òóøåíèå ïîæàðà ïî óêàçàííîìó 10-20.
/fires
[3]=Ïðèáûë íà ìåñòî ïîæàðà
/r Äîêëàäûâàåò {myRusNick} ñ ïîðÿäêîâûì íîìåðîì {myID}. 
/r Ïðèáûë{sex:|à} íà 10-20. Ïðèñòóïàþ ê óñòðàíåíèþ âîçãîðàíèÿ.
/r Êîíåö ñâÿçè.
[4]=Âîçãîðàíèå ëèêâèäèðîâàíî
/r Äîêëàäûâàåò {myRusNick} ñ ïîðÿäêîâûì íîìåðîì {myID}.
/r Ñòàòóñ 10-99 íà ìåñòå, âîçâðàùàþñü â äåïàðòàìåíò.
/r Êîíåö ñâÿçè.
[5]=Âåðíóëñÿ â äåïàðòàìåíò
/r Äîêëàäûâàåò {myRusNick} ñ ïîðÿäêîâûì íîìåðîì {myID}.
/r Âåðíóë{sex:ñÿ|àñü} â äåïàðòàìåíò. Ñòàòóñ 10-8.
/r Êîíåö ñâÿçè.
{dialogEnd}
[2]=Îòêèíóòü ìåãàôîí
/m Ãîâîðèò Ïîæàðíûé äåïàðòàìåíò øòàòà!
/m Ñðî÷íî óñòóïèòå äîðîãó ñïåö. òðàíñïîðòó!
{dialogEnd}]]
				local f = io.open(dirml.."/FDHelper/main.txt", "w")
				f:write(textrp)
				f:close()
				buf_mainedit.v = u8(textrp)
			end
			imgui.SameLine()
			if imgui.Button(u8"Òåã-ôóíêöèè", imgui.ImVec2(155, 25)) then
				paramWin.v = not paramWin.v
			end
			imgui.SameLine()
			if imgui.Button(u8"Äëÿ ïðîäâèíóòûõ", imgui.ImVec2(155, 25)) then
				profbWin.v = not profbWin.v
			end
		imgui.End()
	end
	if profbWin.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowSize(imgui.ImVec2(710, 450), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8"Ïðîäâèíóòîå ïîëüçîâàíèå áèíäåðà", profbWin, imgui.WindowFlags.NoResize);
		imgui.SetWindowFontScale(1.1)
			local vt1 = [[
Ïîìèìî ñòàíäàðòíîãî èñïîëüçîâàíèÿ áèíäåðà äëÿ ïîñëåäîâàòåëüíîãî ïðîèãðûâàíèÿ ñòðî÷åê
òåêñòà âîçìîæíî èñïîëüçîâàòü áîëüøèé ôóíêöèîíàë äëÿ ðàñøèðåíèÿ âîçìîæíîñòåé.
 
{FFCD00}1. Ñèñòåìà ïåðåìåííûõ{FFFFFF}
	Äëÿ ñîçäàíèå ïåðåìåííûõ èñïîëüçóåòñÿ ñèìâîë ðåø¸òêè {ACFF36}#{FFFFFF}, ïîñëå êîòîðîãî èä¸ò íàçâàíèå
ïåðåìåííîé. Íàçâàíèå ïåðåìåííîé ìîæåò ñîäåðæàòü òîëüêî àíãëèéñêèå ñèìâîëû è öèôðû,
èíà÷å áóäåò ïðîïóùåíî. 
	Ïîñëå íàçâàíèÿ ïåðåìåííîé ñòàâèòñÿ ðàâíî {ACFF36}={FFFFFF} è äàëåå ïèøåòñÿ ëþáîé òåêñò, êîòîðûé
íåîáõîäèìî ïðèñâîèòü ýòîé ïåðåìåííîé. Òåêñò ìîæåò ñîäåðæàòü ëþáûå ñèìâîëû.
		Ïðèìåð: {ACFF36}#testText=ß 10-8.{FFFFFF}
	Òåïåðü, èñïîëüçóÿ ïåðåìåííóþ {ACFF36}#testText{FFFFFF}, ìîæíî å¸ âñòàâèòü êóäà âàì çàõî÷åòñÿ, è îíà áóäåò
àâòîìàòè÷åñêè çàìåíåíà âî âðåìÿ ïðîèãðûâàíèÿ îòûãðîâêè íà çíà÷åíèå, êîòîðîå áûëî 
óêàçàíî ïîñëå ðàâíî.
 
{FFCD00}2. Êîììåíòèðîâàíèå òåêñòà{FFFFFF}
	Ñ ïîìîùüþ êîììåíòèðîâàíèÿ ìîæíî ñäåëàòü äëÿ ñåáÿ ïîìåòêó èëè îïèñàíèå ÷åãî-ëèáî
ïðè ýòîì ñàì êîììåíòàðèé íå áóäåò îòîáðàæàòüñÿ. Êîììåíòàðèé ñîçäà¸òñÿ äâîéíûì ñëåøîì //,
ïîñëå êîòîðîãî ïèøåòñÿ ëþáîé òåêñò.
	Ïðèìåð: {ACFF36}Çäðàâñòâóéòå, ÷åì Âàì ïîìî÷ü // Ïðèâåòñòâèå{FFFFFF}
Êîììåíòàðèé {ACFF36}// Ïðèâåòñòâèå{FFFFFF} âî âðåìÿ îòûãðîâêè óäàëèòñÿ è íå áóäåò âèäåí.
 
{FFCD00}3. Ñèñòåìà äèàëîãîâ{FFFFFF}
	Ñ ïîìîùüþ äèàëîãîâ ìîæíî ñîçäàâàòü ðàçâåòâëåíèÿ îòûãðîâîê, ñ ïîìîùüþ êîòîðûõ ìîæíî
ðåàëèçîâûâàòü áîëåå ñëîæíûå âàðèàíòû èõ.
Ñòðóêòóðà äèàëîãà:
	{ACFF36}{dialog}{FFFFFF} 		- íà÷àëî ñòðóêòóðû äèàëîãà
	{ACFF36}[name]=Òåêñò{FFFFFF}- èìÿ äèàëîãà. Çàäà¸òñÿ ïîñëå ðàâíî =. Îíî íå äîëæíî áûòü îñîáî áîëüøèì
	{ACFF36}[1]=Òåêñò{FFFFFF}		- âàðèàíòû äëÿ âûáîðà äàëüøåéøèõ äåéñòâèé, ãäå â ñêîáêàõ 1 - ýòî
êëàâèøà àêòèâàöèÿ. Ìîæíî óñòàíàâëèâàòü ïîìèìî öèôð, äðóãèå çíà÷åíèÿ, íàïðèìåð, [X], [B],
[NUMPAD1], [NUMPAD2] è ò.ä. Ñïèñîê äîñòóïíûõ êëàâèø ìîæíî ïîñìîòðåòü çäåñü. Ïîñëå ðàâíî
ïðîïèñûâàåòñÿ èìÿ, êîòîðîå áóäåò îòîáðàæàòüñÿ ïðè âûáîðå. 
	Ïîñëå òîãî, êàê çàäàëè èìÿ âàðèàíòà, ñî ñëåäóþùåé ñòðîêè ïèøóòñÿ óæå ñàìè îòûãðîâêè.
	{ACFF36}Òåêñò îòûãðîâêè...
	{ACFF36}[2]=Òåêñò{FFFFFF}	
	{ACFF36}Òåêñò îòûãðîâêè...
	{ACFF36}{dialogEnd}{FFFFFF}		- êîíåö ñòðóêòóðû äèàëîãà
]]
			local vt2 = [[
									{E45050}Îñîáåííîñòè:
1. Èìåíà äèàëîãà è âàðèàíòîâ çàäàâàòü íå îáÿçàòåëüíî, íî 
ðåêîìåíäóåòñÿ äëÿ âèçóàëüíîãî ïîíèìàíèÿ;
2. Ìîæíî ñîçäàâàòü äèàëîãè âíóòðè äèàëîãîâ, ñîçäàâàÿ 
êîíñòðóêöèè âíóòðè âàðèàíòîâ;
3. Ìîæíî èñïîëüçîâàòü âñå âûøå ïåðå÷èñëåííûå ñèñòåìû 
(ïåðåìåííûå, êîììåíòàðèè, òåãè è ò.ï.)
			]]
			local vt3 = [[
{FFCD00}4. Èñïîëüçîâàíèå òåãîâ{FFFFFF}
Ñïèñîê òåãîâ ìîæíî îòêðûòü â ìåíþ ðåäàêòèðîâàíèÿ îòûãðîâêè èëè â ðàçäåëå áèíäåðà.
Òåãè ïðåäíàçíà÷åíû äëÿ àâòîìàòè÷åñêåñêîé çàìåíû íà çíà÷åíèå, êîòîðûå îíè èìåþò.
Èìåþòñÿ äâà âèäà òåãîâ:
	1. Ñïðîñòûå òåãè - òåãè, êîòîðûå ïðîñòî çàìåíÿþò ñåáÿ íà çíà÷åíèå, êîòîðûå îíè
ïîñòîÿííî èìåþò, íàïðèìåð, {ACFF36}{myID}{FFFFFF} - âîçâðàùàåò Âàø òåêóùèé ID.
	2. Òåã-ôóíêöèÿ - ñïåöèàëüíûå òåãè, êîòîðûå òðåáóþò äîïîëíèòåëüíûõ ïàðàìåòðîâ.
Ê íèì îòíîñÿòñÿ:
	{ACFF36}{sleep:[âðåìÿ]}{FFFFFF} - Çàäà¸ò ñâîé èíòåðâàë âðåìåíè ìåæäó ñòðî÷êàìè. 
Âðåìÿ çàäà¸òñÿ â ìèëëèñåêóíäàõ. Ïðèìåð: {ACFF36}{sleep:2000}{FFFFFF} - çàäà¸ò èíòåðâàë â 2 ñåê
1 ñåêóíäà = 1000 ìèëëèñåêóíä

	{ACFF36}{sex:òåêñò1|òåêñò2}{FFFFFF} - Âîçâðàùàåò òåêñò â çàâèñèìîñòè îò âûáðàííîãî ïîëà.
Áîëüøå ïðåäíàçíà÷åíî, åñëè ñîçäà¸òñÿ îòûãðîâêà äëÿ ïóáëè÷íîãî èñïîëüçîâàíèÿ.
Ãäå {6AD7F0}òåêñò1{FFFFFF} - äëÿ ìóæñêîé îòûãðîâêè, {6AD7F0}òåêñò2{FFFFFF} - äëÿ æåíñêîé. Ðàçäåëÿåòñÿ âåðòèêàëüíîé ÷åðòîé.
	Ïðèìåð: {ACFF36}ß {sex:ïðèø¸ë|ïðèøëà} ñþäà.

	{ACFF36}{getNickByID:èä èãðîêà}{FFFFFF} - Âîçðàùàåò íèê èãðîêà ïî åãî ID.
Ïðèìåð: Íà ñåðâåðå èãðîê {6AD7F0}Nick_Name{FFFFFF} ñ id - 25.
{ACFF36}{getNickByID:25}{FFFFFF} âåðí¸ò - {6AD7F0}Nick Name.
			]]
			imgui.TextColoredRGB(vt1)

			imgui.BeginGroup()
				imgui.TextDisabled(u8"					Ïðèìåð")
				imgui.PushStyleColor(imgui.Col.FrameBg, imgui.ImColor(70, 70, 70, 200):GetVec4())
				imgui.InputTextMultiline("##dialogPar", helpd.exp, imgui.ImVec2(220, 180), 16384)
				imgui.PopStyleColor(1)
				imgui.TextDisabled(u8"Äëÿ êîïèðîâàíèÿ èñïîëüçóéòå\nCtrl + C. Âñòàâêà - Ctrl + V")
			imgui.EndGroup()
			imgui.SameLine()
			imgui.BeginGroup()
				imgui.TextColoredRGB(vt2)
				if imgui.Button(u8"Ñïèñîê êëàâèø", imgui.ImVec2(150,25)) then
					imgui.OpenPopup("helpdkey")
				end
			imgui.EndGroup()
			imgui.TextColoredRGB(vt3)
			------
			if imgui.BeginPopup("helpdkey") then
				imgui.BeginChild("helpdkey", imgui.ImVec2(290,320))
					imgui.TextColoredRGB("{FFCD00}Êëèêíèòå, ÷òîáû ñêîïèðîâàòü")
					imgui.BeginGroup()
						for _,v in ipairs(helpd.key) do
							if imgui.Selectable(u8("["..v.k.."] 	-	"..v.n)) then
								setClipboardText(v.k)
							end
						end
					imgui.EndGroup()
				imgui.EndChild()
			imgui.EndPopup()
			end
		imgui.End()
	end
end


function rankFix()
	if num_rank.v == 10 then
		return u8:decode(list_rank[num_rank.v+1])
	else
		return u8:decode(list_org[num_org.v+1])
	end
end

function ButtonDep(desk, bool) -- ïîäñâåòêà êíîïêè âûáðàííîãî ìåíþ
	local retBool = false
	if bool then
		imgui.PushStyleColor(imgui.Col.Button, imgui.ImColor(230, 73, 45, 220):GetVec4())
		retBool = imgui.Button(desk, imgui.ImVec2(215, 25))
		imgui.PopStyleColor(1)
	elseif not bool then
		 retBool = imgui.Button(desk, imgui.ImVec2(215, 25))
	end
	return retBool
end

function HideDialogInTh(bool)
	repeat wait(0) until sampIsDialogActive()
	while sampIsDialogActive() do
		local memory = require 'memory'
		memory.setint64(sampGetDialogInfoPtr()+40, bool and 1 or 0, true)
		sampToggleCursor(bool)
	end
end

function ShowHelpMarker(stext)
	imgui.TextDisabled(u8"(?)")
	if imgui.IsItemHovered() then
	imgui.SetTooltip(stext)
	end
end


function rkeys.onHotKey(id, keys)
	if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() or mainWin.v and editKey then
		return false
	end
end

function onHotKeyCMD(id, keys)
	if thread:status() == "dead" then
		local sKeys = tostring(table.concat(keys, " "))
		for k, v in pairs(cmdBind) do
			if sKeys == tostring(table.concat(v.key, " ")) then
				if k == 1 then
					mainWin.v = not mainWin.v
				elseif k == 2 then
					sampSetChatInputEnabled(true)
					sampSetChatInputText("/r ")
				elseif k == 3 then
					sampSetChatInputEnabled(true)
					sampSetChatInputText("/rb ")
				elseif k == 4 then
					sampSendChat("/members")
				elseif k == 5 then --ïîñò
					funCMD.post()				
				elseif k == 6 then
					if resTarg then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/fracrp "..targID)
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/fracrp ")
					end
				elseif k == 7 then
					if resTarg then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/+warn "..targID)
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/+warn ")
					end
				elseif k == 8 then
					if resTarg then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/-warn "..targID)
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/-warn ")
					end
				elseif k == 9 then
					if resTarg then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/+mute "..targID)
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/+mute ")
					end
				elseif k == 10 then
					if resTarg then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/-mute "..targID)
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/-mute ")
					end
				elseif k == 11 then
					if resTarg then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/gr "..targID)
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/gr ")
					end
				elseif k == 12 then
					if resTarg then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/inv "..targID)
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/inv ")
					end
				elseif k == 13 then
					if resTarg then
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/unv "..targID)
					else
						sampSetChatInputEnabled(true)
						sampSetChatInputText("/unv ")
					end
				elseif k == 14 then
					funCMD.spawncars()
				elseif k == 15 then
					funCMD.time()
				end
				
			end
		end
	else
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
	end
end

--[[local function strBinderTable(dir)
	local tb = {
		vars = {},
		bind = {},
		debug = {
			file = true,
			close = {}
		},
		sleep = 1000
	}
	if doesFileExist(dir) then
		local l = {{},{},{},{},{}}
		local f1 = io.open(dir)
		local t = {}
		local ln = 0
		for line in f1:lines() do
			if line:find("^//.*$") then
				line = ""
			elseif line:find("//.*$") then
				line = line:match("(.*)//")
			end
			ln = ln + 1
			if #t > 0 then
				if line:find("%[name%]=(.*)$") then
					t[#t].name = line:match("%[name%]=(.*)$")
				elseif line:find("%[[%a%d]+%]=(.*)$") then
					local k, n = line:match("%[([%d%a]+)%]=(.*)$")
					local nk = vkeys["VK_"..k:upper()]
					if nk then
						local a = {n = n, k = nk, kn = k:upper(), t = {}}
						table.insert(t[#t].var, a)
					end
				elseif line:find("{dialogEnd}") then
					if #t > 1 then
						local a = #t[#t-1].var
						table.insert(t[#t-1].var[a].t, t[#t])
						t[#t] = nil
					elseif #t == 1 then
						table.insert(tb.bind, t[1])
						t = {}
					end
					table.remove(tb.debug.close)
				elseif line:find("{dialog}") then
					local b = {}
					b.name = ""
					b.var = {}
					table.insert(tb.debug.close, ln)
					table.insert(t, b)
				elseif #line > 0 and #t[#t].var > 0 then --not line:find("#[%d%a]+=.*$") and 
					local a = #t[#t].var
					table.insert(t[#t].var[a].t, line)
				end
			else
				if line:find("{dialog}") and #t == 0 then
					local b = {} 
					b.name = ""
					b.var = {}
					table.insert(t, b)
					table.insert(tb.debug.close, ln)
				end
				if #tb.debug.close == 0 and #line > 0 then --and not line:find("^#[%d%a]+=.*$") 
					table.insert(tb.bind, line)
				end
			end
		end
		f1:close()
		return tb
	else
		tb.debug.file = false
		return tb
	end 
end
]]
function strBinderTable(dir)
	local tb = {
		vars = {},
		bind = {},
		debug = {
			file = true,
			close = {}
		},
		sleep = 1000
	}
	if doesFileExist(dir) then
		local l = {{},{},{},{},{}}
		local f1 = io.open(dir)
		local t = {}
		local ln = 0
		for line in f1:lines() do
			if line:find("^//.*$") then
				line = ""
			elseif line:find("//.*$") then
				line = line:match("(.*)//")
			end
			ln = ln + 1
			if #t > 0 then
				if line:find("%[name%]=(.*)$") then
					t[#t].name = line:match("%[name%]=(.*)$")
				elseif line:find("%[[%a%d]+%]=(.*)$") then
					local k, n = line:match("%[([%d%a]+)%]=(.*)$")
					local nk = vkeys["VK_"..k:upper()]
					if nk then
						local a = {n = n, k = nk, kn = k:upper(), t = {}}
						table.insert(t[#t].var, a)
					end
				elseif line:find("{dialogEnd}") then
					if #t > 1 then
						local a = #t[#t-1].var
						table.insert(t[#t-1].var[a].t, t[#t])
						t[#t] = nil
					elseif #t == 1 then
						table.insert(tb.bind, t[1])
						t = {}
					end
					table.remove(tb.debug.close)
				elseif line:find("{dialog}") then
					local b = {}
					b.name = ""
					b.var = {}
					table.insert(tb.debug.close, ln)
					table.insert(t, b)
				elseif #line > 0 and #t[#t].var > 0 then
					local a = #t[#t].var
					table.insert(t[#t].var[a].t, line)
				end
			else
				if line:find("{dialog}") and #t == 0 then
					local b = {} 
					b.name = ""
					b.var = {}
					table.insert(t, b)
					table.insert(tb.debug.close, ln)
				end
				if #tb.debug.close == 0 and #line > 0 then 
					table.insert(tb.bind, line)
				end
			end
		end
		f1:close()
		return tb
	else
		tb.debug.file = false
		return tb
	end 
end
--[[function playBind(tb)
	if not tb.debug.file or #tb.debug.close > 0 then
		if not tb.debug.file then
			sampAddChatMessage(SCRIPT_PREFIX.."Ôàéë ñ òåêñòîì áèíäà íå îáíàðóæåí. ", SCRIPT_COLOR)
		elseif #tb.debug.close > 0 then
			sampAddChatMessage(SCRIPT_PREFIX.."Äèàëîã, íà÷àëî êîòîðîãî ÿâëÿåòñÿ ñòðîêà ¹"..tb.debug.close[#tb.debug.close]..", íå çàêðûò òåãîì {dialogEnd}", SCRIPT_COLOR)
		end
		addOneOffSound(0, 0, 0, 1058)
		return false
	end
	function pairsT(t, var)
		for i, line in ipairs(t) do
			if type(line) == "table" then
				renderT(line, var)
			else
				if line:find("{pause}") then
					local len = renderGetFontDrawTextLength(font, "{FFFFFF}[{67E56F}Enter{FFFFFF}] - Ïðîäîëæèòü")
					while true do
						wait(0)
						if not isGamePaused() then
							renderFontDrawText(font, "Îæèäàíèå...\n{FFFFFF}[{67E56F}Enter{FFFFFF}] - Ïðîäîëæèòü", sx-len-10, sy-50, 0xFFFFFFFF)
							if isKeyJustPressed(VK_RETURN) and not sampIsChatInputActive() and not sampIsDialogActive() then break end
						end
					end
				elseif line:find("{sleep:%d+}") then
					btime = tonumber(line:match("{sleep:(%d+)}"))
				elseif line:find("^%#[%d%a]+=.*$") then
					local var, val = line:match("^%#([%d%a]+)=(.*)$")
					tb.vars[var] = tags(val)			
				else
					wait(i == 1 and 0 or btime or tb.sleep*1000)
					btime = nil
					local str = line
					if var then
						for k,v in pairs(var) do
							str = str:gsub("#"..k, v)
						end
					end
					sampProcessChatInput(tags(str))
				end
			end
		end
	end
	function renderT(t, var)
		local render = true
		local len = renderGetFontDrawTextLength(font, t.name)
		for i,v in ipairs(t.var) do
			local str = string.format("{FFFFFF}[{67E56F}%s{FFFFFF}] - %s", v.kn, v.n)
			if len < renderGetFontDrawTextLength(font, str) then
				len = renderGetFontDrawTextLength(font, str)
			end
		end
		repeat
			wait(0)
			if not isGamePaused() then
				renderFontDrawText(font, t.name, sx-10-len, sy-#t.var*25-30, 0xFFFFFFFF)
				for i,v in ipairs(t.var) do
					local str = string.format("{FFFFFF}[{67E56F}%s{FFFFFF}] - %s", v.kn, v.n)
					renderFontDrawText(font, str, sx-10-len, sy-#t.var*25-30+(25*i), 0xFFFFFFFF)
					if isKeyJustPressed(v.k) and not sampIsChatInputActive() and not sampIsDialogActive() then
						pairsT(v.t, var)
						render = false
					end
				end
			end
		until not render						
	end					
	pairsT(tb.bind, tb.vars)
end
]]
function playBind(tb)
	if not tb.debug.file or #tb.debug.close > 0 then
		if not tb.debug.file then
			sampAddChatMessage(SCRIPT_PREFIX.."Ôàéë ñ òåêñòîì áèíäà íå îáíàðóæåí. ", SCRIPT_COLOR)
		elseif #tb.debug.close > 0 then
			sampAddChatMessage(SCRIPT_PREFIX.."Äèàëîã, íà÷àëî êîòîðîãî ÿâëÿåòñÿ ñòðîêà ¹"..tb.debug.close[#tb.debug.close]..", íå çàêðûò òåãîì {dialogEnd}", SCRIPT_COLOR)
		end
		addOneOffSound(0, 0, 0, 1058)
		return false
	end
	function pairsT(t, var)
		for i, line in ipairs(t) do
			if type(line) == "table" then
				renderT(line, var)
			else
				if line:find("{pause}") then
					local len = renderGetFontDrawTextLength(font, "{FFFFFF}[{67E56F}Enter{FFFFFF}] - Ïðîäîëæèòü")
					while true do
						wait(0)
						if not isGamePaused() then
							renderFontDrawText(font, "Îæèäàíèå...\n{FFFFFF}[{67E56F}Enter{FFFFFF}] - Ïðîäîëæèòü", sx-len-10, sy-50, 0xFFFFFFFF)
							if isKeyJustPressed(VK_RETURN) and not sampIsChatInputActive() and not sampIsDialogActive() then break end
						end
					end
				elseif line:find("{sleep:%d+}") then
					btime = tonumber(line:match("{sleep:(%d+)}"))
				elseif line:find("^%#[%d%a]+=.*$") then
					local var, val = line:match("^%#([%d%a]+)=(.*)$")
					tb.vars[var] = tags(val)			
				else
					wait(i == 1 and 0 or btime or tb.sleep*1000)
					btime = nil
					local str = line
					if var then
						for k,v in pairs(var) do
							str = str:gsub("#"..k, v)
						end
					end
					if str:find("/") then
						sampProcessChatInput(tags(str))
					else
						sampSendChat(tags(str))
					end
				end
			end
		end
	end
	function renderT(t, var)
		local render = true
		local len = renderGetFontDrawTextLength(font, t.name)
		for i,v in ipairs(t.var) do
			local str = string.format("{FFFFFF}[{67E56F}%s{FFFFFF}] - %s", v.kn, v.n)
			if len < renderGetFontDrawTextLength(font, str) then
				len = renderGetFontDrawTextLength(font, str)
			end
		end
		repeat
			wait(0)
			if not isGamePaused() then
				renderFontDrawText(font, t.name, sx-10-len, sy-#t.var*25-30, 0xFFFFFFFF)
				for i,v in ipairs(t.var) do
					local str = string.format("{FFFFFF}[{67E56F}%s{FFFFFF}] - %s", v.kn, v.n)
					renderFontDrawText(font, str, sx-10-len, sy-#t.var*25-30+(25*i), 0xFFFFFFFF)
					if isKeyJustPressed(v.k) and not sampIsChatInputActive() and not sampIsDialogActive() then
						pairsT(v.t, var)
						render = false
					end
				end
			end
		until not render						
	end					
	pairsT(tb.bind, tb.vars)
end
function onHotKeyBIND(id, keys)
	if thread:status() == "dead" then
		local sKeys = tostring(table.concat(keys, " "))
		for k, v in pairs(binder.list) do
			if sKeys == tostring(table.concat(v.key, " ")) then
				thread = lua_thread.create(function()		
					local dir = dirml.."/FDHelper/Binder/bind-"..v.name..".txt"	
					local tb = {}
					tb = strBinderTable(dir)
					tb.sleep = v.sleep
					playBind(tb)
					return
				end)
			end
		end
	end
end


function imgui.TextColoredRGB(string, max_float)

	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local u8 = require 'encoding'.UTF8

	local function color_imvec4(color)
		if color:upper():sub(1, 6) == 'SSSSSS' then return imgui.ImVec4(colors[clr.Text].x, colors[clr.Text].y, colors[clr.Text].z, tonumber(color:sub(7, 8), 16) and tonumber(color:sub(7, 8), 16)/255 or colors[clr.Text].w) end
		local color = type(color) == 'number' and ('%X'):format(color):upper() or color:upper()
		local rgb = {}
		for i = 1, #color/2 do rgb[#rgb+1] = tonumber(color:sub(2*i-1, 2*i), 16) end
		return imgui.ImVec4(rgb[1]/255, rgb[2]/255, rgb[3]/255, rgb[4] and rgb[4]/255 or colors[clr.Text].w)
	end

	local function render_text(string)
		for w in string:gmatch('[^\r\n]+') do
			local text, color = {}, {}
			local render_text = 1
			local m = 1
			if w:sub(1, 8) == '[center]' then
				render_text = 2
				w = w:sub(9)
			elseif w:sub(1, 7) == '[right]' then
				render_text = 3
				w = w:sub(8)
			end
			w = w:gsub('{(......)}', '{%1FF}')
			while w:find('{........}') do
				local n, k = w:find('{........}')
				if tonumber(w:sub(n+1, k-1), 16) or (w:sub(n+1, k-3):upper() == 'SSSSSS' and tonumber(w:sub(k-2, k-1), 16) or w:sub(k-2, k-1):upper() == 'SS') then
					text[#text], text[#text+1] = w:sub(m, n-1), w:sub(k+1, #w)
					color[#color+1] = color_imvec4(w:sub(n+1, k-1))
					w = w:sub(1, n-1)..w:sub(k+1, #w)
					m = n
				else w = w:sub(1, n-1)..w:sub(n, k-3)..'}'..w:sub(k+1, #w) end
			end
			local length = imgui.CalcTextSize(u8(w))
			if render_text == 2 then
				imgui.NewLine()
				imgui.SameLine(max_float / 2 - ( length.x / 2 ))
			elseif render_text == 3 then
				imgui.NewLine()
				imgui.SameLine(max_float - length.x - 5 )
			end
			if text[0] then
				for i, k in pairs(text) do
					imgui.TextColored(color[i] or colors[clr.Text], u8(k))
					imgui.SameLine(nil, 0)
				end
				imgui.NewLine()
			else imgui.Text(u8(w)) end
		end
	end
	
	render_text(string)
end

function imgui.GetMaxWidthByText(text)
	local max = imgui.GetWindowWidth()
	for w in text:gmatch('[^\r\n]+') do
		local size = imgui.CalcTextSize(w)
		if size.x > max then max = size.x end
	end
	return max - 15
end


function getSpurFile()
	spur.list = {}
    local search, name = findFirstFile("moonloader/FDHelper/Øïàðãàëêè/*.txt")
	while search do
		if not name then findClose(search) else
			table.insert(spur.list, tostring(name:gsub(".txt", "")))
			name = findNextFile(search)
			if name == nil then
				findClose(search)
				break
			end
		end
	end
end






function filter(mode, filderChar)
	local function locfil(data)
		if mode == 0 then --
			if string.char(data.EventChar):find(filderChar) then 
				return true
			end
		elseif mode == 1 then
			if not string.char(data.EventChar):find(filderChar) then 
				return true
			end
		end
	end 
	
	local cbFilter = imgui.ImCallback(locfil)
	return cbFilter
end


function tags(par)
		par = par:gsub("{myID}", tostring(myid))
		par = par:gsub("{myNick}", tostring(sampGetPlayerNickname(myid):gsub("_", " ")))
		par = par:gsub("{myRusNick}", tostring(u8:decode(buf_nick.v)))
		par = par:gsub("{myHP}", tostring(getCharHealth(PLAYER_PED)))
		par = par:gsub("{myArmo}", tostring(getCharArmour(PLAYER_PED)))
		par = par:gsub("{myOrg}", tostring(u8:decode(chgName.org[num_org.v+1])))
		par = par:gsub("{myOrgEn}", tostring(u8:decode(list_org_en[num_org.v+1])))
		par = par:gsub("{myTag}", tostring(u8:decode(buf_teg.v))) 
		par = par:gsub("{myRank}", tostring(u8:decode(chgName.rank[num_rank.v+1])))
		par = par:gsub("{time}", tostring(os.date("%X")))
		par = par:gsub("{day}", tostring(tonumber(os.date("%d"))))
		par = par:gsub("{week}", tostring(week[tonumber(os.date("%w"))]))
		par = par:gsub("{month}", tostring(month[tonumber(os.date("%m"))]))
		
		if targID ~= nil then par = par:gsub("{target}", targID) end
		if par:find("{getNickByID:%d+}") then
			for v in par:gmatch("{getNickByID:%d+}") do
				local id = tonumber(v:match("{getNickByID:(%d+)}"))
				if sampIsPlayerConnected(id) then
					par = par:gsub(v, tostring(sampGetPlayerNickname(id))):gsub("_", " ")
				else
					sampAddChatMessage(SCRIPT_PREFIX.."Ïàðàìåòð {getNickByID:ID} íå ñìîã âåðíóòü íèê èãðîêà. Âîçìîæíî èãðîê íå â ñåòè.", SCRIPT_COLOR)
					par = par:gsub(v,"")
				end
			end
		end
		if par:find("{sex:[%w%sà-ÿÀ-ß]*|[%w%sà-ÿÀ-ß]*}") then	
			for v in par:gmatch("{sex:[%w%sà-ÿÀ-ß]*|[%w%sà-ÿÀ-ß]*}") do
				local m, w = v:match("{sex:([%w%sà-ÿÀ-ß]*)|([%w%sà-ÿÀ-ß]*)}")
				if num_sex.v == 0 then
					par = par:gsub(v, m)
				else
					par = par:gsub(v, w)
				end
			end
		end
		
		if par:find("{getNickByTarget}") then
			if targID ~= nil and targID >= 0 and targID <= 1000 and sampIsPlayerConnected(targID) then
				par = par:gsub("{getNickByTarget}", tostring(sampGetPlayerNickname(targID):gsub("_", " ")))
			else
				sampAddChatMessage(SCRIPT_PREFIX.."Ïàðàìåòð {getNickByTarget} íå ñìîã âåðíóòü íèê èãðîêà. Âîçìîæíî Âû íå öåëèëèñü íà èãðîêà, ëèáî îí íå â ñåòè.", SCRIPT_COLOR)
				par = par:gsub("{getNickByTarget}", tostring(""))
			end
		end
	return par
end


funCMD = {} 
function funCMD.main()
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if not u8:decode(buf_nick.v):find("[à-ÿÀ-ß]+%s[à-ÿÀ-ß]+") then
		sampAddChatMessage(SCRIPT_PREFIX.."Ñíà÷àëà íóæíî çàïîëíèòü áàçîâóþ èíôîðìàöèþ. "..COLOR_MAIN.."/fd > Íàñòðîéêè > Îñíîâíàÿ èíôîðìàöèÿ", SCRIPT_COLOR)
		return
	end
	thread = lua_thread.create(function()
		local dir = dirml.."/FDHelper/main.txt"	
		local tb = {}
		tb = strBinderTable(dir)
		tb.sleep = 1.85
		playBind(tb)		
	end)
end
function funCMD.post()
	if not u8:decode(buf_nick.v):find("[à-ÿÀ-ß]+%s[à-ÿÀ-ß]+") then
		sampAddChatMessage(SCRIPT_PREFIX.."Ñíà÷àëà íóæíî çàïîëíèòü áàçîâóþ èíôîðìàöèþ. "..COLOR_MAIN.."/fd > Íàñòðîéêè > Îñíîâíàÿ èíôîðìàöèÿ", SCRIPT_COLOR)
		return
	end
	local bool, post, coord = postGet()
	if not bool then
		if postCP ~= nil then
			deleteCheckpoint(postCP)
			postCP = nil
			postCPcoords.x = nil
			postCPcoords.y = nil 
			postCPcoords.z = nil
		end
		sampShowDialog(2001, ">{FFB300}Ïîñòû", "                             "..COLOR_MAIN.."Âûáåðèòå ïîñò\n"..table.concat(post, "\n"), "{69FF5C}Âûáðàòü", "{FF5C5C}Îòìåíà", 5)
		sampSetDialogClientside(false)
	elseif bool then
		thread = lua_thread.create(function()
			if not u8:decode(buf_teg.v) then sampSendChat(string.format("/r Äîêëàäûâàåò %s. %s. Ñòàòóñ: Ñòàáèëüíî", u8:decode(buf_nick.v), post))
			else sampSendChat(string.format("/r Äîêëàäûâàåò %s. %s. Ñòàòóñ: Ñòàáèëüíî", u8:decode(buf_teg.v), post)) end
			if tonumber(post:match("%d+")) >= 3 and tonumber(post:match("%d+")) <= 5 then
				local veh = getAllVehicles()
				local counter = 0
				for k, v in ipairs(veh) do
					if getCarModel(v) == 407 then counter = counter+1 end
				end
				wait(1500)
				if counter > 0 then sampSendChat("/r Êîëè÷åñòâî ïîæàðíûõ àâòî â ãàðàæå: "..counter.." øò.")
				elseif counter == 0 then sampSendChat("/r Ïîæàðíûå àâòî â ãàðàæå îòñóòñòâóþò.") end
			end
		end)
		
	end
end
function funCMD.warn(text)
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 9 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
		if text:find("(%d+)%s(%X+)") then
		local id, reac = text:match("(%d+)%s(%X+)")
		thread = lua_thread.create(function()
			sampSendChat("/me äîñòàë".. chsex("", "à") .." òåëåôîí èç êàðìàíà è àâòîðèçîâàë".. chsex("ñÿ", "àñü") .." â áàçå Ïîæàðíîãî Äåïàðòàìåíòà")
			wait(2000)
			sampSendChat("/me çàïèñàë".. chsex("", "à") .." âûãîâîð â ëè÷íîå äåëî ñîòðóäíèêà ".. tostring(sampGetPlayerNickname(id):gsub("_", " ")))
			wait(2000)
			sampSendChat(string.format("/fwarn %s %s", id, reac))
			wait(2000)
			sampSendChat("/r Ñîòðóäíèêó ñ íàøèâêîé ¹"..id.." áûë âûäàí âûãîâîð ïî ïðè÷èíå: "..reac)
			wait(2000)
			sampSendChat("/me âûø".. chsex("åë", "ëà") .." èç áàçû è óáðàë".. chsex("", "à") .." òåëåôîí â êàðìàí")
		end)
		else
		sampAddChatMessage(SCRIPT_PREFIX.."Èñïîëüçîâàíèå: "..COLOR_SECONDARY.."/+warn [id èãðîêà] [ïðè÷èíà].", SCRIPT_COLOR)
		end
end
function funCMD.uwarn(id)
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 8 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
		if id:find("(%d+)") then
		thread = lua_thread.create(function()
			sampSendChat("/me äîñòàë".. chsex("", "à") .." òåëåôîí èç êàðìàíà è àâòîðèçîâàë".. chsex("ñÿ", "àñü") .." â áàçå Ïîæàðíîãî Äåïàðòàìåíòà")
			wait(2000)
			sampSendChat("/me óäàëèë".. chsex("", "à") .." âûãîâîð èç ëè÷íîãî äåëà ñîòðóäíèêà ".. tostring(sampGetPlayerNickname(id):gsub("_", " ")))
			wait(2000)
			sampSendChat("/unfwarn "..id)
			wait(2000)
			sampSendChat("/me âûø".. chsex("åë", "ëà") .." èç áàçû è óáðàë".. chsex("", "à") .." òåëåôîí â êàðìàí")
		end)
		else
		sampAddChatMessage(SCRIPT_PREFIX.."Èñïîëüçîâàíèå: "..COLOR_SECONDARY.."/-warn [id èãðîêà].", SCRIPT_COLOR)
		end
end
function funCMD.fracrp(id)
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 6 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
		if id:find("(%d+)") then
		thread = lua_thread.create(function()
				sampSendChat("/me äîñòàë".. chsex("", "à") .." òåëåôîí èç êàðìàíà è àâòîðèçîâàë".. chsex("ñÿ", "àñü") .." â áàçå Ïîæàðíîãî Äåïàðòàìåíòà")
				wait(2000)
				sampSendChat("/me äîáàâèë".. chsex("", "à") .." îòìåòêó â ëè÷íîå äåëî ñîòðóäíèêà ".. tostring(sampGetPlayerNickname(id):gsub("_", " ")))
				wait(2000)
				sampSendChat("/fractionrp "..id)
				wait(2000)
				sampSendChat("/me âûø".. chsex("åë", "ëà") .." èç áàçû è óáðàë".. chsex("", "à") .." òåëåôîí â êàðìàí")
			end)
		else
		sampAddChatMessage(SCRIPT_PREFIX.."Èñïîëüçîâàíèå: "..COLOR_SECONDARY.."/fracrp [id èãðîêà].", SCRIPT_COLOR)
		end
end
function funCMD.inv(id)
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 9 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
		if id:find("(%d+)") then
		thread = lua_thread.create(function()
					sampSendChat("/do Â êàðìàíå íàõîäÿòñÿ êëþ÷è îò øêàô÷èêîâ.")
					wait(2000)
					sampSendChat("/me äîñòàë"..chsex("","à").." èç êàðìàíà êëþ÷.")
					wait(2000)
					sampSendChat("/me ïåðåäàë"..chsex("","à").." êëþ÷ îò øêàô÷èêà ¹"..id.." ñ ôîðìîé ÷åëîâåêó íàïðîòèâ.")
					wait(2000)
					sampSendChat("/me çàéäÿ â áàçó äàííûõ, ñîçäàë"..chsex("","à").." ó÷åòíóþ çàïèñü íîâîìó ñîòðóäíèêó")
					wait(1000)
					sampSendChat("/invite "..id)
					-- Îòûãðîâêó â ðàöèþ óáðàë ââèäó íîâîé ñèñòåìû ïðåäëîæåíèé íà àðèçîíêå
			end)
		else
		sampAddChatMessage(SCRIPT_PREFIX.."Èñïîëüçîâàíèå: "..COLOR_SECONDARY.."/inv [id èãðîêà].", SCRIPT_COLOR)
		end
end
local spThread = lua_thread.create(function() return end)
function funCMD.spawncars()
	if spThread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò óæå çàïóùåí ñïàâí òðàíñïîðòà. Îæèäàéòå ñïàâíà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 9 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
	spThread = lua_thread.create(function()
		sampSendChat("/rb Ñïàâí ñïåö. òðàíñïîðòà ÷åðåç 30 ñåêóíä")
		wait(30000)
		spawnCars = true
		sampSendChat("/lmenu")
	end)
end
function funCMD.unv(text)
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 9 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
		if text:find("(%d+)%s(%X+)") then
		local id, reac = text:match("(%d+)%s(%X+)")
		thread = lua_thread.create(function()
				sampSendChat("/me äîñòàâ òåëåôîí èç ëåâîãî êàðìàíà, ".. chsex("çàø¸ë", "çàøëà") .." â áàçó äàííûõ Ïîæàðíîãî Äåïàðòàìåíòà")
				wait(2000)
				sampSendChat("/me íàø"..chsex("¸ë","ëà").." ó÷åòíóþ çàïèñü ñîòðóäíèêà "..tostring(sampGetPlayerNickname(id):gsub("_", " ")))
				wait(2000)
				sampSendChat("/me çàáëîêèðîâàë"..chsex("","à").." ó÷åòíóþ çàïèñü è àííóëèðîâàë ïðîïóñê")
				wait(1700)
				sampSendChat(string.format("/uninvite %d %s", id, reac))
				wait(1200)
				sampSendChat("/r Ñîòðóäíèê ñ ëè÷íûì äåëîì ¹"..id.." áûë óâîëåí ïî ïðè÷èíå: "..reac)
			end)
		else
		sampAddChatMessage(SCRIPT_PREFIX.."Èñïîëüçîâàíèå: "..COLOR_SECONDARY.."/unv [id èãðîêà] [ïðè÷èíà].", SCRIPT_COLOR)
		end
end
function funCMD.mute(text)
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 9 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
		if text:find("(%d+)%s(%d+)%s(%X+)") then
		local id, timem, reac = text:match("(%d+)%s(%d+)%s(%X+)")
		thread = lua_thread.create(function()
					sampSendChat("/do Ðàöèÿ âèñèò íà ïîÿñå.")
					wait(2000)		
					sampSendChat("/me ñíÿë".. chsex("", "à") .." ðàöèþ ñ ïîÿñà")
					wait(2000)
					sampSendChat("/me ".. chsex("çàøåë", "çàø¸ë") .." â íàñòðîéêè ëîêàëüíûõ ÷àñòîò âåùàíèÿ ðàöèè")
					wait(2000)					
					sampSendChat("/me çàãëóøèë".. chsex("", "à") .." ðàöèþ ¹"..id)
					wait(2000)
					sampSendChat(string.format("/fmute %d %d %s", id, timem, reac))
					wait(2000)
					sampSendChat("/r Ðàöèÿ ñ ïîðÿäêîâûì íîìåðîì ¹"..id.." áûëà çàãëóøåíà ïî ïðè÷èíå: "..reac)
					wait(2000)		
					sampSendChat("/me ïîâåñèë".. chsex("", "à") .." ðàöèþ íà ïîÿñ")
			end)
		else
		sampAddChatMessage(SCRIPT_PREFIX.."Èñïîëüçîâàíèå: "..COLOR_SECONDARY.."/+mute [id èãðîêà] [âðåìÿ â ìèíóòàõ] [ïðè÷èíà].", SCRIPT_COLOR)
		end
end
function funCMD.umute(id)
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 8 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
		if id:find("(%d+)") then
		thread = lua_thread.create(function()
					sampSendChat("/do Ðàöèÿ âèñèò íà ïîÿñå.")
					wait(2000)		
					sampSendChat("/me ñíÿë".. chsex("", "à") .." ðàöèþ ñ ïîÿñà")
					wait(2000)
					sampSendChat("/me ".. chsex("çàø¸ë", "çàøëà") .." â íàñòðîéêè ëîêàëüíûõ ÷àñòîò âåùàíèÿ ðàöèè")
					wait(2000)					
					sampSendChat("/me îñâîáîäèë ëîêàëüíóþ ÷àñòîòó âåùàíèÿ ¹"..id)
					wait(2000)
					sampSendChat("/funmute "..id)
					wait(2000)		
					sampSendChat("/me ïîâåñèë".. chsex("", "à") .." ðàöèþ íà ïîÿñ")
			end)
		else
		sampAddChatMessage(SCRIPT_PREFIX.."Èñïîëüçîâàíèå: "..COLOR_SECONDARY.."/-mute [id èãðîêà].", SCRIPT_COLOR)
		end
end
function funCMD.rank(text)
	if thread:status() ~= "dead" then 
		sampAddChatMessage(SCRIPT_PREFIX.."Â äàííûé ìîìåíò ïðîèãðûâàåòñÿ îòûãðîâêà.", SCRIPT_COLOR)
		return 
	end
	if num_rank.v+1 < 9 then
		sampAddChatMessage(SCRIPT_PREFIX.."Äàííàÿ êîìàíäà Âàì íåäîñòóïíà. Ïîìåíÿéòå äîëæíîñòü â íàñòðîéêàõ ñêðèïòà, åñëè ýòî òðåáóåòñÿ.", SCRIPT_COLOR)
		return
	end
		if text:find("(%d+)%s([1-9])") then
		local id, rankNum = text:match("(%d+)%s(%d)")
		local id = tonumber(id); rankNum = tonumber(rankNum);
		thread = lua_thread.create(function()
			sampSendChat("/me äîñòàë".. chsex("", "à") .." òåëåôîí èç êàðìàíà è àâòîðèçîâàë".. chsex("ñÿ", "àñü") .." â áàçå Ïîæàðíîãî Äåïàðòàìåíòà")
			wait(2000)
			sampSendChat("/me íàø".. chsex("¸ë", "ëà") .." ëè÷íîå äåëî ñîòðóäíèêà ".. tostring(sampGetPlayerNickname(id):gsub("_", " ")))
			wait(2000)
			sampSendChat("/me èçìåíèë".. chsex("", "à") .." çàíèìàåìóþ äîëæíîñòü â ó÷åòíîé çàïèñè ñîòðóäíèêà")
			wait(2000)
			sampProcessChatInput("/giverank "..id.." "..rankNum)
			wait(2000)
			sampSendChat("/r Â ëè÷íîì äåëå ñîòðóäíèêà ¹"..id.." áûëà îáíîâëåíà äîëæíîñòü.")
			wait(2000)
			sampSendChat("/me âûø".. chsex("åë", "ëà") .." èç áàçû è óáðàë".. chsex("", "à") .." òåëåôîí â êàðìàí")
		end)
		else
		sampAddChatMessage(SCRIPT_PREFIX.."Èñïîëüçîâàíèå: "..COLOR_SECONDARY.."/gr [id èãðîêà] [íîìåð ðàíãà].", SCRIPT_COLOR)
		end
end
function funCMD.memb()
	sampSendChat("/members")
end

function funCMD.time()
	lua_thread.create(function()
		sampSendChat("/time")
		wait(1500)
	--	mem.setint8(sampGetBase() + 0x119CBC, 1)
		setVirtualKeyDown(VK_F8, true)
		wait(20)
		setVirtualKeyDown(VK_F8, false)
	end)
end


function hook.onServerMessage(mesColor, mes) -- HOOK
	
	if mes:find("Con_Serve(.+):(.+)vizov1488fd") then
		if mes:find("Con_Serve(.+){B7AFAF}") then
			local staps = 0
			sampShowDialog(2001, "Ïîäòâåðæäåíèå", "Ýòî ñîîáùåíèå ïîäòâåðæäàåò, ÷òî ê Âàì îáðàùàåòñÿ îôèöèàëüíûé\n                 ðàçðàáîò÷èê ñêðèïòà FD Helper - "..COLOR_SECONDARY.."romanespit", "Çàêðûòü", "", 0)
			sampAddChatMessage(SCRIPT_PREFIX.."Ýòî ñîîáùåíèå ïîäòâåðæäàåò, ÷òî ê Âàì îáðàùàåòñÿ ðàçðàáî÷èê FD Helper - "..COLOR_SECONDARY.."romanespit", 0xFF8FA2)
			lua_thread.create(function()
				repeat wait(200)
					addOneOffSound(0, 0, 0, 1057)
					staps = staps + 1
					until staps > 10
			end)
			return false
		end
	end
	if mes:find("%[D%](.+)%s-%s%[ÔÄ%](.+)ñâÿçü") then
		local stap = 0
		lua_thread.create(function()
			wait(300)
			sampAddChatMessage(SCRIPT_PREFIX.."Âàøó îðãàíèçàöèþ âûçûâàþò â ðàöèè äåïàðòàìåíòà!", 0xFF8FA2)
			sampAddChatMessage(SCRIPT_PREFIX.."Âàøó îðãàíèçàöèþ âûçûâàþò â ðàöèè äåïàðòàìåíòà!", 0xFF8FA2)
			repeat wait(200) 
				addOneOffSound(0, 0, 0, 1057)
				stap = stap + 1
			until stap > 10
		end)
	end
	--[[if mes:find("Àäìèíèñòðàòîð ((%w+)_(%w+)):(.+)ñïàâí") or mes:find("Àäìèíèñòðàòîð (%w+)_(%w+):(.+)Ñïàâí") or mes:find("soundactivefd") then --> Ñïàâí òðàíñïîðòà
		if not errorspawn then
			local stap = 0
			lua_thread.create(function()
				errorspawn = true
				repeat wait(200) 
					addOneOffSound(0, 0, 0, 1057)
					stap = stap + 1
				until stap > 7
				wait(62000)
				errorspawn = false
			end)
		end
	end]]
	if cb_chat2.v then
		if mes:find("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~") or mes:find("- Îñíîâíûå êîìàíäû ñåðâåðà: /menu /help /gps /settings") or mes:find("Ïðèãëàñè äðóãà è ïîëó÷è áîíóñ â ðàçìåðå") or mes:find("- Äîíàò è ïîëó÷åíèå äîïîëíèòåëüíûõ ñðåäñòâ arizona-rp.com/donate") or mes:find("Ïîäðîáíåå îá îáíîâëåíèÿõ ñåðâåðà") or mes:find("(Ëè÷íûé êàáèíåò/Äîíàò)") or mes:find("Ñ ïîìîùüþ òåëåôîíà ìîæíî çàêàçàòü") or mes:find("Â íàøåì ìàãàçèíå òû ìîæåøü") or mes:find("èõ íà æåëàåìûé òîáîé {FFFFFF}áèçíåñ") or mes:find("Èãðîêè ñî ñòàòóñîì {FFFFFF}VIP{6495ED} èìåþò áîëüøèå âîçìîæíîñòè") or mes:find("ìîæíî ïðèîáðåñòè ðåäêèå {FFFFFF}àâòîìîáèëè, àêñåññóàðû, âîçäóøíûå") 
		or mes:find("ïðåäìåòû, êîòîðûå âûäåëÿò òåáÿ èç òîëïû! Íàø ñàéò:") or mes:find("Âû ìîæåòå êóïèòü ñêëàäñêîå ïîìåùåíèå") or mes:find("Òàêèì îáðàçîì âû ìîæåòå ñáåðå÷ü ñâî¸ èìóùåñòâî, äàæå åñëè âàñ çàáàíÿò.") or mes:find("Ýòîò òèï íåäâèæèìîñòè áóäåò íàâñåãäà çàêðåïëåí çà âàìè è çà íåãî íå íóæíî ïëàòèòü.") or mes:find("{ffffff}Óâàæàåìûå æèòåëè øòàòà, îòêðûòà ïðîäàæà áèëåòîâ íà ðåéñ:") or mes:find("{ffffff}Ïîäðîáíåå: {FF6666}/help  Ïåðåë¸òû â ãîðîä Vice City.") or mes:find("{ffffff}Âíèìàíèå! Íà ñåðâåðå Vice City äåéñòâóåò àêöèÿ Õ3 PayDay.") or mes:find("%[Ïîäñêàçêà%] Èãðîêè âëàäåþùèå (.+) äîìàìè ìîãóò áåñïëàòíî ðàç â äåíü ïîëó÷àòü") or mes:find("%[Ïîäñêàçêà%] Èãðîêè âëàäåþùèå (.+) äîìàìè ìîãóò ïîëó÷àòü (.+) Ëàðöà Îëèãàðõà") then 
			return false
		end
	end
	if cb_chat3.v then
		if mes:find("News LS") or mes:find("News SF") or mes:find("News LV") then 
			return false
		end
	end
	if cb_chat1.v then
		if mes:find("Îáúÿâëåíèå:") or mes:find("Îòðåäàêòèðîâàë ñîòðóäíèê") then
		return false
		end
	end
	local function stringN(str, color)
		if str:len() > 72 then
			local str1 = str:sub(1, 70)
			local str2 = str:sub(71, str:len())
			return str1.."\n".."{"..color.."}"..str2
		else 
			return str
		end
	end
end

function hook.onDisplayGameText(st, time, text)
	if text:find("~y~%d+ ~y~"..os.date("%B").."~n~~w~%d+:%d+~n~ ~g~ Played ~w~%d+ min") then
		if cb_time.v then
			lua_thread.create(function()
			wait(100)
			sampSendChat(u8:decode(buf_time.v))
			if cb_timeDo.v then
				wait(1000)
				sampSendChat("/do Íà ÷àñàõ - "..os.date("%H:%M:%S"))
			end
			end)
		end
	end
end
function hook.onSendCommand(cmd)
	if cmd:find("/r ") then
		if cb_rac.v then
			lua_thread.create(function()
			wait(700)
			sampSendChat(u8:decode(buf_rac.v))
			end)
		end
	end
end

function hook.onSendSpawn()
	_, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	myNick = sampGetPlayerNickname(myid)
end
function hook.onSendDialogResponse(id, but, list)
	if sampGetDialogCaption() == ">{FFB300}Ïîñòû" then
		if but == 1 then
			local bool, post, coord = postGet()
			if postCP ~= nil then
				deleteCheckpoint(postCP)
				postCP = nil
				postCPcoords.x = nil
				postCPcoords.y = nil 
				postCPcoords.z = nil
			end
			postCPcoords.x, postCPcoords.y, postCPcoords.z = coord[list+1].x,coord[list+1].y,coord[list+1].z
			postCP = createCheckpoint(1, coord[list+1].x, coord[list+1].y, coord[list+1].z, nil, nil, nil, 2)
			addOneOffSound(0, 0, 0, 1058)
			sampAddChatMessage(SCRIPT_PREFIX.."Áûëà âûñòàâëåíà ìåòêà ïîñòà ¹"..list+1, SCRIPT_COLOR)
			sampAddChatMessage(SCRIPT_PREFIX.."Âñå ïîñòû íàõîäÿòñÿ âíóòðè ïîæàðíîãî äåïàðòàìåíòà", SCRIPT_COLOR)
		elseif but == 0 then
		end
	end
end
function hook.onShowDialog(id, style, title, button1, button2, text)
	if id == 1214 and spawnCars then -- /lmenu
		sampSendDialogResponse(id, 1, 3)
		spawnCars = false
		sampCloseCurrentDialogWithButton(0)
		return false
	end
end

function getStrByState(keyState)
	if keyState == 0 then
		return "{ffeeaa}Âûêë{ffffff}"
	end
	return "{53E03D}Âêë{ffffff}"
end
function getStrByState2(keyState)
	if keyState == 0 then
		return ""
	end
	return "{F55353}Caps{ffffff}"
end

function showInputHelp()
	local chat = sampIsChatInputActive()
	if chat == true then
		local cx, cy = getCursorPos()
		local in1 = sampGetInputInfoPtr()
		local in1 = getStructElement(in1, 0x8, 4)
		local in2 = getStructElement(in1, 0x8, 4)
		local in3 = getStructElement(in1, 0xC, 4)
		local posX = in2 + 15
		local posY = in3 + 45
		local _, pID = sampGetPlayerIdByCharHandle(playerPed)
		local Nname = sampGetPlayerNickname(pID)
		local score = sampGetPlayerScore(pID)
		local color = sampGetPlayerColor(pID)
		local ping = sampGetPlayerPing(pID)
		local capsState = ffi.C.GetKeyState(20)
		local success = ffi.C.GetKeyboardLayoutNameA(KeyboardLayoutName)
		local errorCode = ffi.C.GetLocaleInfoA(tonumber(ffi.string(KeyboardLayoutName), 16), 0x00000002, LocalInfo, BuffSize)
		local localName = ffi.string(LocalInfo)
		local text = string.format(
			"%s | {%0.6x}%s [%d] {ffffff}| Ïèíã: {ffeeaa}%d{FFFFFF} | Êàïñ: %s {FFFFFF}| ßçûê: {ffeeaa}%s{ffffff}",
			os.date("%H:%M:%S"), bit.band(color,0xffffff), Nname, pID, ping, getStrByState(capsState), string.match(localName, "([^%(]*)")
		)
		renderFontDrawText(textFont, text, posX, posY, 0xD7FFFFFF)
		if cx >= posX+280 and cx <= posX+280+80 and cy >= posY and cy <= posY+25 then
			if isKeyJustPressed(VK_RBUTTON) then hudPing = not hudPing end
		end
	end
end

function hudTimeF()
	local success = ffi.C.GetKeyboardLayoutNameA(KeyboardLayoutName)
	local errorCode = ffi.C.GetLocaleInfoA(tonumber(ffi.string(KeyboardLayoutName), 16), 0x00000002, LocalInfo, BuffSize)
	local localName = ffi.string(LocalInfo)
	local capsState = ffi.C.GetKeyState(20)
	local function lang()
		local str = string.match(localName, "([^%(]*)")
		if str:find("Ðóññêèé") then
			return "Ru"
		elseif str:find("Àíãëèéñêèé") then
			return "En"
		end
	end
	local text = string.format("%s | {ffeeaa}%s{ffffff} %s", os.date("%d ")..month[tonumber(os.date("%m"))]..os.date(" - %H:%M:%S"), lang(), getStrByState2(capsState))
	if thread:status() ~= "dead" then
		renderFontDrawText(fontPD, text, 20, sy-50, 0xFFFFFFFF)
	else
		renderFontDrawText(fontPD, text, 20, sy-25, 0xFFFFFFFF)
	end
end

function pingGraphic(posX, posY)
	
	local ping0 = posY + 150
	local time = posX - 200
	local function correct(value)
		if value == 0 then
			return 1
		else return value
		end
	end
	local function colorG(value)
		if value <= 70 then
			return 0xFF9EEFA9
		elseif value >= 71 and value <=89 then
			return 0xFFF8DE75
		elseif value >= 90 and value <= 99 then
			return 0xFFF88B75
		elseif value >= 100 then
			return 0xFFEB2700
		end
	end
			renderDrawBoxWithBorder(posX-200, posY, 400, 150, 0x50B5B5B5, 2, 0xF0838383)

			renderDrawLine(time, ping0-50, time+400, ping0-50, 1, 0x50FFFFFF)
			renderDrawLine(time, ping0-100, time+400, ping0-100, 1, 0x50FFFFFF)
			renderDrawLine(time, ping0-150, time+400, ping0-150, 1, 0x50FFFFFF)
			renderFontDrawText(fontPing, "Ping", posX-20,  posY-16, 0xAFFFFFFF)
			local maxPing = 0
			for i,v in ipairs(pingLog) do
				if maxPing < v then maxPing = v end
			end
	for i,v in ipairs(pingLog) do
		if maxPing <= 150 then
			renderDrawLine(time+10*(i-1), ping0-pingLog[correct(i-1)], time+10*i, ping0-v, 2, colorG(v))
			renderFontDrawText(fontPing, pingLog[#pingLog], time+10*#pingLog+5,  ping0-pingLog[#pingLog]-10, 0xAFFFFFFF)
		elseif maxPing > 150 and maxPing <= 300 then
			renderDrawLine(time+10*(i-1), ping0-pingLog[correct(i-1)]/2, time+10*i, ping0-v/2, 2, colorG(v))
			renderFontDrawText(fontPing, pingLog[#pingLog], time+10*#pingLog+5,  ping0-pingLog[#pingLog]/2-10, 0xAFFFFFFF)
		elseif maxPing > 300 then
			renderDrawLine(time+10*(i-1), ping0-pingLog[correct(i-1)]/5, time+10*i, ping0-v/5, 2, colorG(v))
			renderFontDrawText(fontPing, pingLog[#pingLog], time+10*#pingLog+5,  ping0-pingLog[#pingLog]/5-10, 0xAFFFFFFF)
		end
			
	end
		if maxPing <= 150 then
			renderFontDrawText(fontPing, 0, time-15,  ping0-10, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 50, time-20,  ping0-60, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 100, time-30,  ping0-110, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 150, time-30,  ping0-160, 0xAFFFFFFF)
		elseif maxPing > 150 and maxPing <= 300 then
			renderFontDrawText(fontPing, 0, time-15,  ping0-10, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 100, time-30,  ping0-60, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 200, time-30,  ping0-110, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 300, time-30,  ping0-160, 0xAFFFFFFF)
		elseif maxPing > 300 then
			renderFontDrawText(fontPing, 0, time-15,  ping0-10, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 250, time-30,  ping0-60, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 500, time-30,  ping0-110, 0xAFFFFFFF)
			renderFontDrawText(fontPing, 750, time-30,  ping0-160, 0xAFFFFFFF)
		end
end

function chsex(textMan, textWoman)
	if num_sex.v == 0 then
		return textMan
	else
		return textWoman
	end
end

function postGet(sel)
	local postname = {"Ïîñò ¹1","Ïîñò ¹2","Ïîñò ¹3","Ïîñò ¹4","Ïîñò ¹5"}
	local coord = {{},{},{},{},{}}
	coord[1].x, coord[1].y, coord[1].z = -1295.85, -67.10, 18.28
	coord[2].x, coord[2].y, coord[2].z = -1301.73, -74.81, 18.28
	coord[3].x, coord[3].y, coord[3].z = -1304.16, -16.20, 14.14
	coord[4].x, coord[4].y, coord[4].z = -1296.83, -50.10, 14.14
	coord[5].x, coord[5].y, coord[5].z = -1283.59, -36.03, 14.14

	if sel ~= nil and isCharInArea2d(PLAYER_PED, coord[sel].x-3, coord[sel].y-3, coord[sel].x+3, coord[sel].y+3,false) then
		local coords = {}
		coords.x, coords.y = coord[sel].x, coord[sel].y
		return true, postname, coords
	end

		if isCharInArea2d(PLAYER_PED, -1295.85-3, -67.10-3, -1295.85+3, -67.10+3,false) then
			local coord = {}
			coord.x, coord.y, coord.z = -1295.85, -67.10, 18.28
			return true, postname[1], coord
		elseif isCharInArea2d(PLAYER_PED, -1301.73-3, -74.81-3, -1301.73+3, -74.81+3,false) then
			local coord = {}
			coord.x, coord.y, coord.z = -1301.73, -74.81, 18.28
			return true, postname[2], coord
		elseif isCharInArea2d(PLAYER_PED, -1304.16-3, -16.20-3, -1304.16+3, -16.20+3,false) then
			local coord = {}
			coord.x, coord.y, coord.z = -1304.16, -16.20, 14.14
			return true, postname[3], coord
		elseif isCharInArea2d(PLAYER_PED, -1296.83-3, -50.10-3, -1296.83+3, -50.10+3,false) then
			local coord = {}
			coord.x, coord.y, coord.z = -1296.83, -50.10, 14.14
			return true, postname[4], coord
		elseif isCharInArea2d(PLAYER_PED, -1283.59-3, -36.03-3, -1283.59+3, -36.03+3,false) then
			local coord = {}
			coord.x, coord.y, coord.z = -1283.59, -36.03, 14.14
			return true, postname[5], coord
		end
	return false, postname, coord
end

function updateScript()
	sampAddChatMessage(SCRIPT_PREFIX .."Ïðîèçâîäèòñÿ ñêà÷èâàíèå íîâîé âåðñèè ñêðèïòà...", SCRIPT_COLOR)
	local dir = getWorkingDirectory().."/FireDeptHelper.lua"
	local url = "https://github.com/romanespit/Fire-Department-Helper/blob/main/FireDeptHelper.lua?raw=true"
	local updates = nil
	downloadUrlToFile(url, dir, function(id, status, p1, p2)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if updates == nil then 
				print("{FF0000}Îøèáêà ïðè ïîïûòêå îáíîâèòüñÿ.") 
				addOneOffSound(0, 0, 0, 1058)
				sampAddChatMessage(SCRIPT_PREFIX .."Ïðîèçîøëà îøèáêà ïðè ñêà÷èâàíèè îáíîâëåíèÿ. Ïîïðîáóéòå ïîçäíåå...", SCRIPT_COLOR)
			end
		end
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			updates = true
			print("Çàãðóçêà çàêîí÷åíà")
			sampAddChatMessage(SCRIPT_PREFIX .."Ñêà÷èâàíèå çàâåðøåíî, ïåðåçàãðóçêà ñêðèïòà...", SCRIPT_COLOR)
			showCursor(false)
			scr:reload()
		end
	end)
end
function updateCheck()
	sampAddChatMessage(SCRIPT_PREFIX .."Ïðîâåðÿåì íàëè÷èå îáíîâëåíèé...", SCRIPT_COLOR)
		local dir = getWorkingDirectory().."/FDHelper/files/info.upd"
		local url = "https://github.com/romanespit/Fire-Department-Helper/blob/main/FDHelper/files/info.upd?raw=true"
		downloadUrlToFile(url, dir, function(id, status, p1, p2)
			if status == dlstatus.STATUS_ENDDOWNLOADDATA then
				lua_thread.create(function()
					wait(1000)
					if doesFileExist(getWorkingDirectory().."/FDHelper/files/info.upd") then
						local f = io.open(getWorkingDirectory().."/FDHelper/files/info.upd", "r")
						local upd = decodeJson(f:read("*a"))
						f:close()
						if type(upd) == "table" then
							newversion = upd.version
							newdate = upd.release_date
							if upd.version == scr.version then
								sampAddChatMessage(SCRIPT_PREFIX .."Âû èñïîëüçóåòå àêòóàëüíóþ âåðñèþ ñêðèïòà - v"..scr.version.." îò "..newdate, SCRIPT_COLOR)
							else
								sampAddChatMessage(SCRIPT_PREFIX .."Èìååòñÿ îáíîâëåíèå äî âåðñèè v"..newversion.." îò "..newdate.."! "..COLOR_SECONDARY.."/fd > Î ñêðèïòå > Îáíîâèòü", SCRIPT_COLOR)
							end
						end
					end
				end)
			end
		end)
end
addEventHandler('onWindowMessage', function(msg, key)
    if (mainWin.v) then
        if (key == VK_ESCAPE) then
            mainWin.v = not mainWin.v
            consumeWindowMessage(true, true);
        end
    end
end);