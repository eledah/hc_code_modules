--- HOW TO USE ---
--- Find your desired command using the search functions.
--- Copy the "Initialize" part and paste it inside "function hc.moderation.init()" inside hc/lua/modules/moderation.lua.
--- Copy the "Function" part and paste it right after "function hc.moderation.init()" ends.
-- Notice: Since most of the functions use explode() and hc.array_contains(), make sure you have them in your code regardless of the functions you are using.


--- Initialize ---
--hc.add_say_command("TEXT_COMMAND", "FUNCTION_TO_EXECUTE", "MINIMUM_USAGE_LEVEL", "SYNTAX", "DESCRIPTION")
hc.add_say_command("rcon", hc.moderation.rcon_command, hc.RCON_LEVEL, "<command>", "Execute an rcon command.")
hc.add_say_command("banip", hc.moderation.banip_say_command, hc.MODERATOR2, "<id>", "Ban a player.")
hc.add_say_command("banusgn", hc.moderation.banusgn_say_command, hc.MODERATOR2, "<id>", "Ban a player.")
hc.add_say_command("rename", hc.moderation.rename_say_command, hc.MODERATOR1, "<id>", "rename's a player.")
hc.add_say_command("kick", hc.moderation.kick_say_command, hc.MODERATOR1, "<id>", "Kick a player.")
hc.add_say_command("spawn", hc.moderation.spawn_say_command, hc.MODERATOR2, "<id>", "Respawns a player")
hc.add_say_command("kill", hc.moderation.kill_say_command, hc.MODERATOR1, "<id>", "Kills a player")
hc.add_say_command("ipall", hc.moderation.ipall_say_command, hc.MODERATOR1, "", "All dem ips", true)
hc.add_say_command("ipallc", hc.moderation.ipallc_say_command, hc.MODERATOR1, "", "All dem ips, in console.", true)
hc.add_say_command("mute", hc.moderation.mute_say_command, hc.MODERATOR1, "<id>", "Mutes a player")
hc.add_say_command("balance", hc.moderation.balance_say_command, hc.MODERATOR1, "", "Balances the teams", true)
hc.add_say_command("strip", hc.moderation.strip_say_command, hc.MODERATOR2, "<id>", "Strips a player")
hc.add_say_command("news", hc.moderation.news_say_command, hc.RCON_LEVEL, "<message>", "Displays a news")
hc.add_say_command("b", hc.moderation.b_say_command, hc.USER, "<pswd> <command>", "Executes an RCon cmd")
hc.add_say_command("muteip", hc.moderation.muteip_say_command, hc.MODERATOR2, "<id> <minutes>", "Mute an IP.")
hc.add_say_command("add", hc.moderation.add_say_command, hc.ADMINISTRATOR, "<name> <USGN> <rank>", "Register someone")
hc.add_say_command("hide", hc.moderation.hide_say_command, hc.MODERATOR1, "", "Hide",true)
hc.add_say_command("w", hc.moderation.wall_say_command, hc.MODERATOR1, "<id>", "Put a wall on a player",true)
hc.add_say_command("s", hc.moderation.slowmod_say_command, hc.MODERATOR1, "<id>", "Speedmod -100",true)
hc.add_say_command("tb", hc.moderation.tempban_say_command, hc.MODERATOR2, "<id> [duration in minutes 1-120] [reason]", "Temporarily ban a player def=30",true)
hc.add_say_command("spawnt", hc.moderation.spawnt, hc.MODERATOR2, "<id> <x in tile> <y in tile>", "Spawn")


--- Function ---

function hc.moderation.spawnt(p, arg)
	local array = explode(" ", arg)
	if array[1] ~= mil and array[2] ~= nil and array[3] ~= nil then
		hc.exec(p, 'spawnplayer ' .. array[1] .. ' ' .. array[2]*32 + 16 .. ' '.. array[3]*32 + 16)
	end
end


function hc.moderation.tempban_say_command(p, arg)
	local array = explode(" ", arg)
	local id = array[1]
	local tp_time = 30
	local tp_reason = ""
	print(array[2])
	if array[2]~=nil then tp_time = tonumber(array[2]) end
	print(tp_time)
	if array[3]~=nil then tp_reason = array[3] end
	if tonumber(tp_time) > 120 or tonumber(tp_time) < 1 then tp_time = '30' end
	hc.exec(p,'banip ' .. player(id,'ip') .. ' ' .. tp_time .. ' ' .. tp_reason)
end

function leave_slowed_down_players(ip)
	remove_slowed_down_players(ip)
end
slowed_down_players = {}
function hc.moderation.slowmod_say_command(p, arg)
	local array = explode(" ", arg)
    local id = array[1]
	print(player(id,'ip'))
	if player(id,'health') > 0 then
		if (hc.array_contains(hiddenMods, player(p,'usgn'))) then
			if (hc.array_contains(slowed_down_players, player(id,'ip'))) then
				parse('speedmod '..id..' 0')
				remove_slowed_down_players(player(id,'ip'))
				msg2(p, "No longer slowed down.")
			else 
				parse('speedmod '..id..' -100')
				table.insert(slowed_down_players, player(tonumber(array[1]),"ip"))
				msg2(p, "Slowed down.")
			end
		else
			if (hc.array_contains(slowed_down_players, player(id,'ip'))) then
				parse('speedmod '..id..' 0')
				remove_slowed_down_players(player(id,'ip'))
				parse("msg " .. player(id, "name") .. " is no longer slowed down.")
			else 
				parse('speedmod '..id..' -100')
				table.insert(slowed_down_players, player(tonumber(array[1]),"ip"))
				parse("msg " .. player(id, "name") .. " is slowed down.")
			end
		end
	end
end
function remove_slowed_down_players(ip)
	for key,value in pairs(slowed_down_players) do
		if value == ip then table.remove(slowed_down_players, key) end
	end
end




function hc.moderation.wall_say_command(p, arg)
	local array = explode(" ", arg)
    local id = array[1]
	if player(id,'health'	) > 0 then
		local fixed_x = math.floor(player(id, 'x')/32)*32 + 16
		local fixed_y = math.floor(player(id, 'y')/32)*32 + 16
		parse('setpos '.. '"'.. id ..'"' .. '"' .. fixed_x .. '"' .. '"' .. fixed_y .. '"')
		parse('spawnobject 5 ' .. '"' .. (fixed_x-16) / 32 .. '"' .. '"' .. (fixed_y-16) / 32 .. '" 0 0 0')
		print(player(p,'usgn') .. ' used !w on '.. player(id,'name'))
	end
end


function lyr_cmsg(id,msg)
	parse("cmsg "..'"'..msg..'" '..id)
end

function hc.moderation.ipallc_say_command(p, id)
	local playerlist = player(0,"table")
	for _,id in pairs(playerlist) do
		lyr_cmsg(p, ipall_color(id)..'#'..tostring(id)..' name: '..player(id, "name")..' , usgn: '..player(id, "usgn")..' , ip: '..player(id, "ip"))
	end
end

function ipall_color(i)
	local playerlist = player(0,"table")
	local f = 0
	for _,id in pairs(playerlist) do
		if player(i, "ip")==player(id, "ip") then f=f+1 end
	end
	
	if f==1 then 
		return hc.BEIGE
	end
	return hc.RED
end



ipmute = {}
function hc.moderation.muteip_say_command(p, arg)
	local array = explode(" ", arg)
	if array[1]~=nil and array[2]~=nil and player(array[1],"exists") then
		msg2(p,array[1]..array[2])
		if tonumber(array[2]) > 5 or tonumber(array[2]) < 1 then array[2] = 5 end
		table.insert(ipmute, player(tonumber(array[1]),"ip"))
		timer(tonumber(array[2])*1000*60,"remove_ip",player(tonumber(array[1]),"ip"))
	end
end

function hc.moderation.check_ipmuted(id,msg)
	local ip = player(id,"ip")
	for key,value in pairs(ipmute) do
		if ip == value then return 1 end
	end
end

function remove_ip(ip)
	for key,value in pairs(ipmute) do
		if value == ip then table.remove(ipmute, key) end
	end
end


function hc.moderation.add_say_command(p, arg)
	local array = explode(" ", arg)
    local name = array[1]
    local usgn = array[2]
	
	hc.users[usgn] = { name = name, level = hc.moderation.rank_calc(array[3]) }
	msg2(p, hc.LIME.."User "..name.."(USGN ID#"..usgn..") was added as "..string.upper(array[3]))
    hc.save_users()
	hc.init_users()
end

function hc.moderation.rank_calc(txt)
	local txt_1 = string.lower(txt)
	if txt_1=="mod1" then return hc.MODERATOR1
	elseif txt_1=="mod2" then return hc.MODERATOR2
	elseif txt_1=="adm" then return hc.ADMINISTRATOR
	elseif txt_1=="vip" then return hc.VIP end
end

passcode_vip = {VIP_NAME = "VIP_PASSCODE", VIP2_NAME = "VIP2_PASSCODE"}
passcode_mod1 = {MOD1_NAME = "MOD1_PASSCODE", Playr = "Playr'sPasscode"}
passcode_mod2 = {MOD2_NAME = "MOD2_PASSCODE", Nigwark = "nigwark123"}

function hc.moderation.b_say_command(p, arg)
	local cmd = ""
	local mode = -2
	local pID = ""
	array = explode(" ", arg)
	
	for i,value in pairs(passcode_vip) do
		if array[1] == value then mode = -1 pID = i end
    end
	
	for i,value in pairs(passcode_mod1) do
		if array[1] == value then mode = 0 pID = i end
	end
		
	for i,value in pairs(passcode_mod2) do
		if array[1] == value then mode = 1 pID = i end
	end
	for i=2, #array do
		cmd = cmd..array[i]..' '
	end
	
	
	local msg = ""
	for i=3, #array do
		msg = msg..array[i]..''
		msg = msg..array[i]..' '
	end
	
	if array[2] == "bc" and mode > -1 then parse('msg \169255255255'..msg) end
	
	local id = tonumber(array[3])
	if array[2] == "check" and mode > -2 then msg2(p,'name: '..player(id,"name")..' ip: '..player(id,"ip")) end
	if array[2] == "kick" and mode > -1 then l_parse(pID,cmd) end
	if array[2] == "ipall" and mode > -1 then hc.moderation.ipall_say_command(p, 1) end
	if array[2] == "banip" and mode > 0 then l_parse(pID,cmd) end
	if array[2] == "spawn" and mode > 0 then hc.moderation.spawn_say_command(p, id) end
	
	mode = -2
end

function l_parse(id, cmd)
	print('COMMAND EXECUTED '..tostring(id)..' '..tostring(cmd))
	parse(cmd)
end


hiddenMods={}
function hc.moderation.hide_say_command(p)
	local f = 0
   for num,v in pairs(hiddenMods) do
       if player(p, 'usgn') == v then f = 1 end
   end
   if f == 0 then
       table.insert(hiddenMods, player(p, 'usgn'))
       msg2(p, hc.RED .. 'You are now hidden from sights!')
   else
       table.remove(hiddenMods, num)
       msg2(p, hc.LIME .. 'You are no longer hidden!')
   end
end

function hc.moderation.news_say_command(p, arg)
	News.Say(p, arg)
end

News = {}


--Configuration--

News.Delay = 10              -- Delay between command uses (in seconds), default 10 secs. Note that you'll have to wait this time if someone else uses the command.--
News.Color = "255255255"     -- News message color (on RGB), default white.--
News.Bar_Color = "100200100" -- News bar color (on RGB), deafult green.--
News.Id = 48                 -- News message hudtxt id (0-49), change it if you get hud errors, default 48.--
News.Sound = 1               -- Sound that will be heard when using the command, values over 3 and under 1 will mute it.--
News.Tlex_Rank = 4           -- Set the tlex rank on which a player can use the say commands of this script on tlex ( 4 = moderator by default). --
News.Admin_List = {}         -- List of usgn ids of the admins, separated by comma (,). This list only works if the script is not used with tlex. --
News.Start = ""          -- The word (between double quotes) witch the message will start, default "News", the longer this text is, the shorter the message can be.--

News.Counter = 0


addhook("second","News.Second")

function News.Bard(news)
	tween_alpha(news,News.Delay*100,0.0)
end

function News.Main(news)
	news,r,g,blueblue = news,tonumber(News.Bar_Color:sub(1,3)),tonumber(News.Bar_Color:sub(4,6)),tonumber(News.Bar_Color:sub(7,9))
	parse("hudtxt "..News.Id.." \"©"..News.Color..string.gsub(news,'"',"'").."\" "..((news:len()*7)+640)..' 4 1')
	parse('hudtxtmove 0 '..News.Id..' '..(News.Delay*1000)..' '..(news:len()*(-8))..' 4')
	News.Bar=image("gfx/news_bar.png",320,12,2)
	imagecolor(News.Bar,r,g,blueblue)
	imagealpha(News.Bar,0.0)
	imagescale(News.Bar,640,1)
	imageblend(News.Bar,1)
	tween_alpha(News.Bar,News.Delay*100,0.7)
	timer(News.Delay*1000,'freeimage',News.Bar)
	timer((News.Delay*1000)-(News.Delay*100),'News.Bard',News.Bar)
	timer(News.Delay*1000,'parse','hudtxt '..News.Id..' ""')
	if News.Sound>0 and News.Sound<=3 then
		parse("sv_sound \"news/news_sound"..News.Sound..".ogg\"")
	end
end

function News.Say(id,news)
	if News.Counter == 0 and hc.is_moderator(id) then
		News.Main(news)
		News.Counter = News.Delay
	end
end

function News.Second()
	if News.Counter > 0 then
		News.Counter = News.Counter - 1
	end
end


--Cmd
function hc.moderation.strip_say_command(p, id)
	hc.exec(p, 'strip '.. id)
end


function hc.moderation.balance_say_command(p)
	balance()
end

function hc.moderation.mute_say_command(p, id)
	hc.moderation.mute_lyr(p, tonumber(id), "3 Minutes")
end

function hc.moderation.mute_lyr(p, id, index)
    local name = player(id, "name")
    local duration = 3
    if duration == 0 then
        if hc.players[id].moderation.muted then
            freetimer("hc.moderation.timer_cb", tostring(id))
            hc.players[id].moderation.muted = nil
            hc.event(name .. " is no longer muted.")
        else
            hc.error(p, "Can't unmute " .. name .. " because he isn't muted.")
        end
    else
        if hc.players[id].moderation.muted then
        -- Player was already muted - remove the pending timer
            freetimer("hc.moderation.timer_cb", tostring(id))
        end

        hc.players[id].moderation.muted = duration
        hc.event(name .. " has been muted for " .. duration .. " minute(s).")
        hc.info(id, "You have been muted.")
        hc.log(p, "mute " .. id)
        timer(duration * 60000, "hc.moderation.timer_cb", tostring(id))
    end
end

function hc.moderation.ipall_say_command(p, id)
	local playerlist = player(0,"table")
	for _,id in pairs(playerlist) do
		msg2(p, ipall_color(id)..'#'..tostring(id)..' name: '..player(id, "name")..' , usgn: '..player(id, "usgn")..' , ip: '..player(id, "ip"))
	end
end

function ipall_color(i)
	local playerlist = player(0,"table")
	local f = 0
	for _,id in pairs(playerlist) do
		if player(i, "ip")==player(id, "ip") then f=f+1 end
	end
	
	if f==1 then 
		return hc.BEIGE
	end
	return hc.RED
end


function hc.moderation.banip_say_command(p, id)
     hc.exec(p, "banip " .. id)
end

function hc.moderation.banusgn_say_command(p, id)
     hc.exec(p, "banusgn " .. id)
end

function hc.moderation.rename_say_command(p, id)
     hc.exec(p, "setname " .. id)
end

function hc.moderation.spawn_say_command(p, id)
    livingTerror = player(0, "team1living")
    chosenTerror = livingTerror[math.random(#livingTerror)]
    if(player(chosenTerror, "exists") and player(chosenTerror, "health") > 0) then
        hc.exec(p, 'mp_autoteambalance'..' 0')
        hc.exec(p, "spawnplayer " .. id .. " " ..player(chosenTerror, "x").." "..player(chosenTerror, "y"))
        hc.exec(p, 'mp_autoteambalance'..' 1')
        if(player(id, "deaths") > 1) then
            hc.exec(p, 'setdeaths '..id..' '..player(id, "deaths") - 1)
        end
    end
end

function hc.moderation.kill_say_command(p, id)
	if p ~= id and player(id, 'team') ~= 0 and player(id, 'health') > 0 then
		parse("strip " .. id)
		hc.exec(p, "killplayer " .. id)
		msg2(p, 'Name: ' .. player(id, "name") .. ' usgn: ' .. player(id, "usgn") .. ' ip: ' .. player(id, "ip"))
	end
end

function hc.moderation.kick_say_command(p, id)
	local array = {}
	local kick_reason = ""
	array = explode(" ", id)
	for i=2, #array do
		kick_reason = kick_reason.." "..array[i]
	end
	msg2(p, 'Name: ' .. player(tonumber(array[1]), "name") .. ' usgn: ' .. player(tonumber(array[1]), "usgn") .. ' ip: ' .. player(tonumber(array[1]), "ip"))
	hc.exec(p, "kick " .. array[1]..' "'..kick_reason..'"')
end

function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1))
    pos = sp + 1
  end
  table.insert(arr,string.sub(str,pos))
  return arr
end

function hc.array_contains(a, n)
   for i = 1, #a do
       if tonumber(a[i]) == tonumber(n) then 
           return true 
       end
   end
   return false
end

