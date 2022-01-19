--[[
    lenn's AnarchyBot sucks........
    leme's is best!!!!!

    Made for Rose's server and because AnarchyBot is a bit of a cluster fuck
]]

util.AddNetworkString("awesomebot_printcommands")

leAwesomeBot = leAwesomeBot or nil

leBotCache = {
    activeweapon = nil,
    activeweaponforced = false,
    attacking = false,
    attackTarg = nil,
    changeCount = 0,
    changeDelay = -1,
    crouching = false,
    deathHandled = false,
    fired = false,
    fuckroseDelay = -1,
    killDelays = {},
    lagDelay = -1,
    lastUrban = "",
    movetoDelays = {},
    sexDelays = {},
    storyDelay = -1
}

leBotConfig = {
    allowM9KWeapons = true, -- Controls !weapon command allowing M9K
    allowNoAcess = true, -- Controls access to !noaccess command
    allowForceWeapon = true, -- Controls access to !forceweapon
    botName = "CancerPatient",
    changeDelay = 5, -- Controls how often the bot will change its angles
    collectionURL = "steamcommunity.com/sharedfiles/filedetails/?id=2678818450", -- Collection URL for !addons
    fuckroseDelay = 180, -- Delay in seconds before users can !fuckrose again
    killDelay = 10, -- Delay in seconds before users can !kill again
    lagDelay = 10, -- Delay in seconds before users can !stoplag again
    movetoDelay = 20, -- Delay in seconds before users can !moveto again
    sexDelay = 10, -- Delay in seconds before users can !sex again
    storyDelay = 15, -- Delay in seconds before users can !story again
    explodebanAmount = 50, -- How many times to explode before banning

    farewells = {
        "Adios",
        "Bye-bye",
        "Bye %s",
        "Bye!",
        "Farewell",
        "Godspeed, you magnificent bastard",
        "Goodbye, Mate",
        "Goodbye.",
        "Sayonara",
        "See you later!",
        "Sweet dreams!"
    },

    greetings = {
        "Are you having a good day %s?",
        "Good morning/afternoon/evening",
        "Greetings",
        "Hello!",
        "Hey there",
        "Hi!",
        "Howdy",
        "Nice to see you, %s",
        "Welcome back, %s",
        "What's up, %s?"
    },

    gives = {
        "I have just given you %s. It is right behind you.",
        "Look behind you! %s is right there!",
        "Success! %s been given to you now.",
        "The item that you requested is in your hands.",
        "You got it!",
        "You now have %s"
    },

    answers = {
        "yes",
        "no",
        "maybe",
        "yes!",
        "no!"
    },

    chinese = {
        "Libby是好人 Libby是生命",
        "You really think I was gonna say a chinese sentence again?",
        "中国#1",
        "你为什么要�E说中斁",
        "你好",
        "你真�E", "我们可以有一个日期后对朋友",
        "如果你把这个翻译迁E���E�在聊天中说gmodbot",
        "我是一个中斁E��器人",
        "我是中国人"
    },

    japanese = {
        "mkm ホーム",
        "ありがとうございました",
        "こんいちわ",
        "ごめんなさい",
        "すみません",
        "ニガー",
        "リビーのサンドボックスの遊び場は最高です",
        "レンレンレンレンレンレンレンレンレンレン",
        "人生は私たちが決して逃げることのない迷路です",
        "男はちょうど自分を撃つ!待って、私は冗談です"
    },

    die = {
        "You are dead",
        "You are no longer alive",
        "You died. the end",
        "You got slammed",
        "You got yourself exploded",
        "You just got bombed!"
    },

    content = {
        "3d Printing, Be Able To Print Your Own Iphone Without Buying One At All!",
        "50 Facts About Cancerpatient",
        "A Day In The Life Of Someone",
        "A Music Video! Become The Best Rapper In Your World",
        "A Tour Of Your Room",
        "A Video About Cultures??",
        "A Video About Languages",
        "Ads... The Ads",
        "Art.. Duh..",
        "Become A Hero",
        "Behind The Scenes",
        "Benchmark, How Strong Is Your Pc? How Good Can It Run?",
        "Biography Videos",
        "Bloopers!",
        "Book Review!",
        "Building A Bridge Project",
        "Building A Building Project",
        "Bust Some Very Unknown Myths",
        "Cancerpatient.exe Has Stopped Responding",
        "Challenging Videos For Your Friends",
        "Comedy..",
        "Content, This Is Content, Right? Content. Content = Content",
        "Covid-19",
        "Create Your Program. Make Sure It Isn't A Virus Though",
        "Discuss Animal Habitats",
        "Diy Videos",
        "Draw My Life!",
        "Durability Test",
        "Explain Your Own Concept",
        "Explainer Videos",
        "Explore A Game In-depth",
        "Exploring Abandoned Places",
        "Fan Videos, Heh",
        "Game Review! Review Gmod!",
        "Hentai Cat Girls.. I Mean What.",
        "Hentaihaven.com",
        "How To Create A Google Account",
        "How To Download A App",
        "How To Photocopy Money",
        "How To Take Care Of An Animal",
        "How To Use A App",
        "How To Use A Product",
        "Infographics Show",
        "Installation Setup Guide For Your Program",
        "Introduce Other People",
        "Introduce Your Organization",
        "Introduce Yourself",
        "Kill Your Pc With Viruses, Just Make Sure You Do It On A Virtual Machine Safely Though",
        "Learning How To Build A Pc",
        "Live Stream",
        "Magic Tricks! Woah!",
        "Make A Machinima",
        "Make A Mod!",
        "Make A Movie! If You Well, Want To Make One, I Mean...",
        "Make An Animation! If You, Are Well Interested In Animations And Good At Art",
        "Make Gameplay Live Commentaries",
        "Make Love With Cancerpatient (no Lol)",
        "Making Music",
        "Mannequin Challenge",
        "Math! Learn Math!",
        "Meet The Team",
        "Mooovie Reviews",
        "Moviesins",
        "Nemiiiiii Cat Girl Kawaaiiii Pictures",
        "Opinions, Reponses, Reactions",
        "Parody Video",
        "Play Gmod",
        "Play Minecraft",
        "Playing Video Games..",
        "Pornhub.com",
        "Prank Videos, Prank Someone!",
        "Presentations",
        "Product Reviews Heh",
        "Product Tutorials!",
        "Q & A",
        "Rats, We Are The Rats",
        "Reading! Learn Reading!",
        "Science Rules...",
        "Shooting / Airsoft Videos",
        "Shopping And Buying",
        "Show Off Ya Graphics Settings, My Pc Can Run This Game On Ultra Settings!",
        "Show Off Yourself",
        "Singing And Lip Syncing",
        "Skirts!",
        "Skits!",
        "Smashing An Iphone. Throwing An Iphone Off The Empire State Building. Drowning A Iphone",
        "Speedrunning Genre, Speedrun Lenn_game",
        "Start A Vlog",
        "Storm Area 51. Content?",
        "Talk About Emulators",
        "Talk About The Best Players In Da Game",
        "Teach People How To Cook Stuff",
        "Testing Out Anti-viruses, Can Anti-viruses Really Stop Viruses?",
        "The History Of Different Countries",
        "The History Of The World",
        "The News! Live Videos!",
        "The Specs Of Your Laptop. Or Computer",
        "Time-lapse, Woah. So Cool!",
        "Touring Videos",
        "Trying Out A New Operating System, Learn How To Use It",
        "Unboxing Videos! Unbox New And Very Cool Stuff!",
        "Very Cute And Funny Animal Videos",
        "Very Cute And Funny Baby Videos",
        "Video Contest, Which Video Is Better?",
        "Virtual Reality, Experience Virtual Reality Today",
        "Walkthrough This Place Video",
        "What Could Possibly Be In Your Bag?",
        "What Could Possibly Be In Your Phone?",
        "Workout Video, Physical Education",
        "Yootuube Pooop",
        "You Fight, Fight And Fight"
    },

    kit = {
        "1 steam game for you.",
        "1 ticket to go to anywhere, in the world",
        "10 steam games for you.",
        "$100, buy something",
        "$1000, buy something nice",
        "$10000, buy something cool",
        "2 steam games for you.",
        "5 steam games for you.",
        "A button that allows you to nuke the server. be cautious with it",
        "A new car for you",
        "A new house for you",
        "A new set of legos for you.",
        "A note that says: you're admin!",
        "A note that says: you're dumb",
        "admin weapon",
        "coal",
        "COAL. HAHA. YOU RECEIVED COAL.",
        "diamonds,",
        "donator rank",
        "emeralds",
        "free admin",
        "Gaming PC",
        "gold",
        "iron",
        "lapis",
        "leather",
        "lenn, you have lenn kit? those are so rare!",
        "netherite",
        "nothing. what did you expect?",
        "POOP! LOL IT CONTAINS POOP WHAT A GOOD KIT",
        "redstone",
        "stone axe",
        "stone pickaxe",
        "stone shovel",
        "stone sword",
        "stone",
        "THE LUCKY COIN. WHICH MAKES YOU LUCKY",
        "The power for you to fly",
        "wooden axe",
        "wooden pickaxe",
        "wooden shovel",
        "wooden sword",
        "Your face"
    },

    slap = {
        "like ya cut g",
        "tap",
        "%s has been bitch-slapped",
        "%s has been slapped"
    },

    languages = {
        "arabic",
        "bengali",
        "bosnian",
        "czech",
        "filipino",
        "french",
        "german",
        "hawaiian",
        "hindi",
        "indonesia",
        "irish",
        "italian",
        "korean",
        "lahnda",
        "malay",
        "malayalam",
        "persian",
        "polish",
        "portuguese",
        "romanian",
        "russian",
        "scottish",
        "serbian",
        "somoan",
        "spanish",
        "swedish",
        "tamil",
        "turkish",
        "urdu",
        "vietnamese"
    },

    insults = {
        "asshat",
        "book-head",
        "dumb fuck",
        "dumbass",
        "dummy",
        "nerd",
        "polyglot"
    },

    weapons = {
        gmod_camera = true,
        m9k_acr2 = false,
        m9k_barret_m82 = false,
        m9k_coolak47 = false,
        m9k_davy_crockett = false,
        m9k_dragunov = false,
        m9k_legendaryan94 = false,
        m9k_m202 = false,
        m9k_matador = false,
        m9k_milkormgl = false,
        m9k_minigun = false,
        m9k_orbital_strike = false,
        m9k_prop_shooter = false,
        m9k_psg1 = false,
        m9k_svt40 = false,
        m9k_svu = false,
        none = true,
        weapon_357 = true,
        weapon_ar2 = true,
        weapon_bugbait = true,
        weapon_crossbow = true,
        weapon_crowbar = true,
        weapon_fists = true,
        weapon_frag = true,
        weapon_nyangun = true,
        weapon_physcannon = true,
        weapon_pistol = true,
        weapon_rpg = true,
        weapon_shotgun = true,
        weapon_slam = true,
        weapon_smg1 = true,
        weapon_stunstick = true
    }
}

leBotTrollCommands = {
    pvp = function()
        leAwesomeleAwesomeBot:Say("Congratulations on not being in pvp mode! It's \"!pvp\"")
    end,

    build = function()
        leAwesomeleAwesomeBot:Say("Congratulations on not being in build mode! It's \"!build\"")
    end,

    hvh = function()
        leAwesomeleAwesomeBot:Say("Congratulations on not being in hvh mode! It's \"!hvh\"")
    end
}

leBotCommands = {
    help = function(args, ply)
        leAwesomeBot:Say("My help command is \"!cmdhelp\"")
    end,

    cmdhelp = function(args, ply)
        net.Start("awesomebot_printcommands")
            net.WriteString([=[Awesome Bot Commands:
        !addons - Gives you the server's collection URL
        !answer - Answers your question (Alias: !8ball)
        !attack - Toggles the bot attacking players
        !bye - Bye bye!
        !calladmin - Calls an admin
        !chinese - 說隨機的中國東西
        !cmdhelp - Shows this message
        !come - Brings the bot to you
        !content - Gives you awesome content ideas
        !countdown (x) - Counts down from 3 or provided number (Max: 10)
        !dance - Makes you dance
        !ddos - Ddosses a player
        !dice - Rolls a die (Alias: !roll)
        !die - Rest in peace
        !dox - Doxxes a player
        !dupe (s) - Dupes something
        !explode (s) - Explodes a player via SteamID
        !explodeban (s) - Explodes and bans a user with style!
        !fakeinfo - Gets you some fake information
        !flex - Makes you flex
        !flip - Flips a coin
        !fly - Lets you fly for 3 seconds
        !forceweapon (s) - Forces the bot to switch to this weapon
        !fuckrose - Fucks Rose
        !giveme (s) - Gives you something (Alias: !give)
        !givesuperadmin - Gives you super admin (Don't tell anyone about this command!!!!!!!!)
        !hello - Hi! (Alias: !hi)
        !japanese - Shut up, weeb
        !joke - Gets a random joke
        !kill - Kills a player
        !kit - Gives you a random kit
        !laugh - Makes you laugh
        !moveto (s) - Teleports you to specified player
        !mutemenu - Opens the mute menu
        !no - no
        !noaccess - Sets a user to noaccess
        !number (x) - Gets a random number from 1 to 10 or provided number (Alias: !random)
        !penis (s) - Measures how big your or someone else's penis is
        !ping - Says your ping
        !players - Gives the player count (Alias: !playercount)
        !randomreport - Reports a random player
        !rateit (x) - Gives a random rating out of 10 or provided number (Min:10, Max: 100)
        !report - Reports a player
        !respawnbot - Force respawns the bot
        !say - Says your message
        !sex - Sex
        !shutup - Mutes a player
        !slap - Slaps a user
        !stoplag - Freezes all props
        !story - Tells you a story
        !test - Test command
        !time - Shows the date and time (Alias: !date)
        !uptime - Says the server uptime
        !urban (s) - Looks up something from Urban Dictionary
        !weapon (s) - Switches bots weapon
        !whogay - Who is gay?
        !word (x) - Gives you a random word or however many words provided (Max: 10)
        !yes - yes]=])
        net.Send(ply)

        leAwesomeBot:Say("Check your console!")
    end,

    report = function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to report this person")

            return
        end
        
        if args[2] == leBotConfig.botName or argstr == leBotConfig.botName then
            leAwesomeBot:Say("Report has been closed. Reason: Banned for false-reporting.")

            return
        end

        leAwesomeBot:Say(argstr .. " has been reported. Staff should (not) arrive in a minute!")
    end,

    yes = function()
        local y = leCoinFlip() and "Yes" or "yes"

        if leCoinFlip() then
            y = string.upper(y)
        end

        leAwesomeBot:Say(y .. (leCoinFlip() and "!" or ""))
    end,

    no = function()
        local n = leCoinFlip() and "No" or "no"

        if leCoinFlip() then
            n = string.upper(n)
        end

        leAwesomeBot:Say(n .. (leCoinFlip() and "!" or ""))
    end,

    dox = function(args)
        if argstr == "" then
            leAwesomeBot:Say("Unable to dox this person")

            return
        end

        leAwesomeBot:Say("Getting fake information about the user...")

        timer.Simple(math.random(2, 6), function()
            leDox()
        end)
    end,

    uptime = function()
        leAwesomeBot:Say("The server has been up for about " .. string.NiceTime(SysTime()))
    end,

    bye = function(args, ply)
        leAwesomeBot:Say(table.Random(leBotConfig.farewells):format(ply:GetName()))
    end,

    hello = function(args, ply)
        leAwesomeBot:Say(table.Random(leBotConfig.greetings):format(ply:GetName()))
    end,

    word = function(args)
        local count = math.Clamp(tonumber(args[2]) or 1, 1, 10)

        http.Fetch("https://random-word-api.herokuapp.com/word?number=" .. count, function(body)
            local data = util.JSONToTable(body)
            local datastr = table.concat(data, ", ")

            local sections = leSplitString(datastr)

            for _, v in ipairs(sections) do
                leAwesomeBot:Say(v)
            end
        end, function(error)
            leAwesomeBot:Say("Failed to get word" .. (count ~= 1 and "s" or ""))
        end)
    end,

    countdown = function(args)
        local x = math.Clamp(tonumber(args[2]) or 3, 1, 10)

        for i = x, 1, -1 do
            timer.Simple(x - i, function()
                leAwesomeBot:Say(i .. "...")
            end)
        end

        timer.Simple(x + 1, function()
            leAwesomeBot:Say("Go!!!")
        end)
    end,

    ddos = function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to ddos this person")

            return
        end

        leAwesomeBot:Say("Sending 65535 bytes (x128) of data to " .. argstr .. "...")

        timer.Simple(math.random(3, 6), function()
            local last = string.sub(argstr, string.len(argstr))

            leAwesomeBot:Say("Success! " .. argstr .. "'" .. (last ~= "s" and "s" or "") .. " internet is down. Ping results from last 3 seconds: " .. math.random(200, 400) .. "ms, " .. math.random(300, 650) .. "ms, " .. math.random(600, 800) .. "ms")
        end)
    end,

    givesuperadmin = function(args, ply)
        local pid = ply:SteamID()

        RunConsoleCommand("ulx", "psay", "$" .. pid, "Verifying you're not a superadmin...")

        if ply:GetUserGroup() == "superadmin" then
            RunConsoleCommand("ulx", "psay", "$" .. pid, "You're already superadmin!")
        else
            timer.Simple(math.random(0.3, 1), function()
                RunConsoleCommand("ulx", "psay", "$" .. pid, "Success! You have been given superadmin by " .. leBotConfig.botName)

                local logtbl = string.Split(GetConVar("ulx_logechocolordefault"):GetString() or "", " ") or {}
                local logcolor = "Color(" .. (logtbl[1] or 151) .. ", " .. (logtbl[2] or 211) .. ", " .. (logtbl[3] or 255) .. ")"

                for _, v in ipairs(player.GetAll()) do
                    if v == ply then
                        continue
                    end

                    v:SendLua([=[
                        chat.AddText(Color(0, 0, 0), "(Console)", ]=] .. logcolor .. [=[, " added ", Color(80, 0, 120), "Someone", ]=] .. logcolor .. [=[, " to group ", Color(0, 255, 0), "superadmin")
                    ]=])
                end

                ply:SendLua([=[
                    chat.AddText(Color(0, 0, 0), "(Console)", ]=] .. logcolor .. [=[, " added ", Color(80, 0, 120), "You", ]=] .. logcolor .. [=[, " to group ", Color(0, 255, 0), "superadmin")
                ]=])
            end)
        end
    end,

    moveto = function(args, ply, argstr)
        if leBotCache.movetoDelays[ply:SteamID64()] then
            leAwesomeBot:Say("You can't use this command yet!")

            return
        end

        if not args[2] then
            leAwesomeBot:Say("Unable to moveto that person")

            return
        end

        leBotCache.movetoDelays[ply:SteamID64()] = SysTime()

        RunConsoleCommand("ulx", "send", "$" .. ply:SteamID(), argstr)
        leAwesomeBot:Say(ply:GetName() .. " teleported to " .. argstr)
    end,

    giveme = function(args, ply, argstr)
        argstr = argstr ~= "" and argstr or "gay sex"

        leAwesomeBot:Say(table.Random(leBotConfig.gives):format(argstr))
    end,

    dice = function()
        leAwesomeBot:Say("You rolled a " .. math.random(1, 6))
    end,

    number = function(args)
        args[2] = math.Clamp(tonumber(args[2]) or 10, 1, math.huge)

        leAwesomeBot:Say("Random number from 1 to " .. args[2] .. ", the number is: " .. math.random(1, args[2]))
    end,

    flip = function()
        leAwesomeBot:Say("Flipped a coin and got " .. (leCoinFlip() and "heads" or "tails"))
    end,

    players = function()
        leAwesomeBot:Say("Current player count: " .. player.GetCount())
    end,

    fly = function(args, ply)
        leAwesomeBot:Say("Jump to fly! (Only works for 3 seconds)")

        ply:SetGravity(-0.5)

        timer.Simple(3, function()
            if IsValid(ply) then
                ply:SetGravity(1)
            end
        end)
    end,

    answer = function()
        leAwesomeBot:Say(table.Random(leBotConfig.answers))
    end,

    chinese = function()
        leAwesomeBot:Say(table.Random(leBotConfig.chinese))
    end,

    japanese = function()
        leAwesomeBot:Say(table.Random(leBotConfig.japanese))
    end,

    chingchong = function()
        if leCoinFlip() then
            leAwesomeBot:Say(table.Random(leBotConfig.chinese))
        else
            leAwesomeBot:Say(table.Random(leBotConfig.japanese))
        end
    end,

    noaccess = function(args, ply)
        if leBotConfig.allowNoAcess then
            if not ply:IsAdmin() or not ply:IsSuperAdmin() then
                leAwesomeBot:Say("You're not allowed to do this!")

                return
            end

            args[2] = args[2] or ""

            local tply = player.GetBySteamID(args[2])

            if IsValid(tply) then
                if tply:IsAdmin() or tply:IsSuperAdmin() then
                    leAwesomeBot:Say(tply:GetName() .. " is an admin you " .. table.Random(leBotConfig.insults))
                else
                    RunConsoleCommand("ulx", "adduserid", args[2], "noaccess")

                    leAwesomeBot:Say("Fuck you " .. tply:GetName() .. "!!!!!!")
                end
            else
                leAwesomeBot:Say("I can't find this person")
            end
        else
            leAwesomeBot:Say("This command has been disabled")
        end
    end,

    sex = function(args, ply)
        if leBotCache.sexDelays[ply:SteamID64()] then
            leAwesomeBot:Say("You just had sex! Wait a little bit!")

            return
        end

        leAwesomeBot:Say("Sexual content has been banned from Garry's Mod!")

        local len = math.random(5, 10)
        local delay = (0.3 * len) + 1
        local uname = "leme_awesomebot_sexkill_" .. ply:SteamID() .. math.random(1234, 4321)

        leBotCache.sexDelays[ply:SteamID64()] = SysTime()

        timer.Create(uname, 0.3, len, function()
            if IsValid(ply) then
                ply:Kill()
            end
        end)

        timer.Simple(delay, function()
            if IsValid(ply) then
                leExplode(ply, 1, true)
            end
        end)
    end,

    die = function(args, ply)
        local deathpos = ply:GetPos()
        local gravestone = ents.Create("prop_physics")

        if IsValid(gravestone) then
            gravestone:SetModel("models/props_c17/gravestone_cross001a.mdl")
            gravestone:SetPos(deathpos)
            gravestone:Spawn()
        end

        leExplode(ply, math.random(3, 5), true)

        leAwesomeBot:Say(table.Random(leBotConfig.die))

        timer.Simple(24, function()
            SafeRemoveEntity(gravestone)
        end)
    end,

    kill = function(args, ply, argstr)
        if leBotCache.killDelays[ply:SteamID64()] then
            leAwesomeBot:Say("You just killed someone! Wait a bit psycho!")

            return
        end

        if argstr == "" then
            leAwesomeBot:Say("Unable to kill that person")

            return
        end

        leExplode(ply, 1, true)
        leAwesomeBot:Say(argstr .. " has been killed")

        leBotCache.killDelays[ply:SteamID64()] = SysTime()
    end,

    content = function()
        leAwesomeBot:Say(table.Random(leBotConfig.content))
    end,

    shutup = function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to mute that person")

            return
        end

        leAwesomeBot:Say(argstr .. " has been muted and is now unable to talk")
    end,

    randomreport = function()
        leAwesomeBot:Say(table.Random(player.GetAll()):GetName() .. " has been reported. Staff should (not) arrive in a minute!")
    end,

    kit = function()
        leAwesomeBot:Say("You have received a kit from " .. leBotConfig.botName .. ", it contains: " .. table.Random(leBotConfig.kit))
    end,

    addons = function()
        leAwesomeBot:Say("YOU WANT ADDONS??? >> " .. leBotConfig.collectionURL .. " <<")
    end,

    calladmin = function()
        leAwesomeBot:Say("You have just called an admin. They will arrive soon!")
    end,

    slap = function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to slap that person")

            return
        end

        leAwesomeBot:Say(table.Random(leBotConfig.slap):format(argstr))
    end,

    english = function() -- omg hidden command so sneaky
        leAwesomeBot:Say(leBotConfig.botName .. " isn't a language bot you " .. table.Random(leBotConfig.insults))
    end,

    ping = function(args, ply)
        leAwesomeBot:Say("Your ping is " .. ply:Ping())
    end,

    kd = function(args, ply)
        local kills = ply:Frags()
        local deaths = ply:Deaths()

        leAwesomeBot:Say("You have " .. kills .. " kill" .. (kills ~= 1 and "s" or "") .. " and " .. deaths .. " death" .. (deaths ~= 1 and "s" or "") .. ", your K/D is " .. kills / deaths)
    end,

    time = function()
        leAwesomeBot:Say("The date and time is " .. os.date("%m/%d/%Y - %H:%M:%S", os.time()))
    end,

    fuckrose = function()
        local rose = player.GetBySteamID("STEAM_0:1:82072473")

        if IsValid(rose) then
            if leBotCache.fuckroseDelay < 0 then
                leAwesomeBot:Say("die you moth of fuck")
    
                leExplode(rose, 1, true)
    
                leBotCache.fuckroseDelay = SysTime()
            else
                leAwesomeBot:Say("Rose has been fucked recently, give him some time to recover")
            end
        else
            leAwesomeBot:Say("Rose not found :(")
        end
    end,

    mutemenu = function(args, ply)
        leAwesomeBot:Say(ply:GetName() .. " has opened the mute menu! Beware!")
    end,

    test = function(args, ply)
        if IsValid(leAwesomeBot) then
            RunConsoleCommand("ulx", "send", leAwesomeBot:GetName(), "$" .. ply:SteamID())
    
            leAwesomeBot:Say("I have received your beautiful message")

            timer.Create("leme_awesomebot_spazz" .. math.random(1234, 4321), 0, math.random(500, 750), function()
                leAwesomeBot:SetEyeAngles(Angle(math.random(-89, 89), math.random(-180, 180), 0))
            end)
        end
    end,

    say = function(args, ply, argstr)
        leAwesomeBot:Say(argstr)
    end,

    dupe = function(args, ply, argstr)
        argstr = argstr ~= "" and argstr or "thin air"

        leAwesomeBot:Say("Duped " .. argstr .. ". You now have " .. math.random(1, 64) .. " of them!")
    end,

    stoplag = function(args, ply)
        if leBotCache.lagDelay < 0 then
            local props = ents.FindByClass("prop_physics")
    
            for _, v in ipairs(props) do
                local physobj = v:GetPhysicsObject()
    
                if IsValid(physobj) then
                    physobj:Sleep()
                    physobj:EnableMotion(false)
                end
            end
    
            leAwesomeBot:Say(ply:GetName() .. " has stopped lag!")

            leBotCache.lagDelay = SysTime()
        else
            leAwesomeBot:Say("Wait! Not yet!")
        end
    end,

    whogay = function()
        local random = table.Random(player.GetAll())

        leAwesomeBot:Say("I" .. (random:SteamID() == "STEAM_0:1:547859568" and " know " or " think ") .. random:GetName() .. " is gay")
    end,

    dance = function(args, ply)
        ply:SendLua([=[LocalPlayer():ConCommand("act dance")]=])
    end,

    laugh = function(args, ply)
        ply:SendLua([=[LocalPlayer():ConCommand("act laugh")]=])
    end,

    flex = function(args, ply)
        ply:SendLua([=[LocalPlayer():ConCommand("act muscle")]=])
    end,

    urban = function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Invalid search term!")

            return
        end

        http.Fetch("https://api.urbandictionary.com/v0/define?term=" .. string.gsub(argstr, " ", "-"), function(body)
            local data = util.JSONToTable(body) or {list = {}}

            for i = #data.list, 1, -1 do
                local cur = data.list[i]

                if not cur.word or not cur.definition then
                    table.remove(data.list, i)
                    continue
                end

                if not leCoinFlip() then
                    continue
                end

                local say = cur.word .. ": " .. cur.definition

                if string.len(say) < 127 then
                    
                end
            end

            local targ = table.Random(data.list)
            local cur = string.gsub(string.gsub(string.gsub(targ.word .. ": " .. targ.definition, "%]", ""), "%[", ""), "\n", "")

            if #data.list > 1 then
                while cur == leBotCache.lastUrban do
                    targ = table.Random(data.list)
                    cur = string.gsub(string.gsub(string.gsub(targ.word .. ": " .. targ.definition, "%]", ""), "%[", ""), "\n", "")
                end
            end

            local sections = leSplitString(cur)

            for _, v in ipairs(sections) do
                leAwesomeBot:Say(v)
            end

            leBotCache.lastUrban = cur
        end, function(error)
            leAwesomeBot:Say("Failed to fetch data :(")
        end)
    end,

    story = function()
        if leBotCache.storyDelay > 0 then
            leAwesomeBot:Say("I just told you a story! Have some patience!")

            return
        end

        http.Fetch("http://metaphorpsum.com/paragraphs/2", function(body)
            local sections = leSplitString(body)

            for _, v in ipairs(sections) do
                leAwesomeBot:Say(string.gsub(string.Trim(v), "\n", ""))
            end
        end, function(error)
            leAwesomeBot:Say("Failed to fetch data :(")
        end)

        leBotCache.storyDelay = SysTime()
    end,

    fakeinfo = function()
        leDox(true)
    end,

    joke = function()
        http.Fetch("https://v2.jokeapi.dev/joke/Any", function(body)
            local data = util.JSONToTable(body) or {}

            if not data.setup or not data.delivery then
                leAwesomeBot:Say("Failed to fetch data :(")

                return
            end

            leAwesomeBot:Say(data.setup)

            timer.Simple(0.75, function()
                leAwesomeBot:Say(data.delivery)
            end)
        end, function(error)
            leAwesomeBot:Say("Failed to fetch data :(")
        end)
    end,

    attack = function()
        leBotCache.attacking = not leBotCache.attacking
    end,

    weapon = function(args)
        if not args[2] then
            leAwesomeBot:Say("Unable to select this weapon")

            return
        end

        args[2] = string.lower(args[2])

        if leBotConfig["allowM9KWeapons"] then
            if (string.sub(args[2], 1, 3) ~= "m9k" and leBotConfig.weapons[args[2]] == nil) or leBotConfig.weapons[args[2]] == false then
                leAwesomeBot:Say("Unable to select this weapon")
    
                return
            end
        else
            if not leBotConfig.weapons[args[2]] then
                leAwesomeBot:Say("Unable to select this weapon")

                return
            end
        end

        if IsValid(leAwesomeBot) then
            leBotCache.activeweapon = args[2]
            leBotCache.activeweaponforced = false

            leAwesomeBot:StripWeapons()
            leAwesomeBot:Give(leBotCache.activeweapon)
            leAwesomeBot:SelectWeapon(leBotCache.activeweapon)
        end
    end,

    forceweapon = function(args, ply)
        if not leBotConfig.allowForceWeapon then
            leAwesomeBot:Say("This command has been disabled!")

            return
        end

        if not args[2] then
            leAwesomeBot:Say("Unable to select this weapon")

            return
        end

        if not ply:IsAdmin() and not ply:IsSuperAdmin() then
            leAwesomeBot:Say("You don't have permission to do this!")

            return
        end

        args[2] = string.lower(args[2])

        if IsValid(leAwesomeBot) then
            leBotCache.activeweapon = args[2]
            leBotCache.activeweaponforced = true

            leAwesomeBot:StripWeapons()
            leAwesomeBot:Give(leBotCache.activeweapon)
            leAwesomeBot:SelectWeapon(leBotCache.activeweapon)
        end
    end,

    come = function(args, ply)
        if IsValid(leAwesomeBot) then
            if leAwesomeBot:Alive() then
                RunConsoleCommand("ulx", "send", leAwesomeBot:GetName(), "$" .. ply:SteamID())

                leAwesomeBot:Say("I am here")
            else
                leAwesomeBot:Say("I'm dead!")
            end
        end
    end,

    penis = function(args, ply, argstr)
        local length = math.random(1, 16)

        if args[2] then
            local last = string.sub(argstr, string.len(argstr))

            if leCoinFlip(3) then
                leAwesomeBot:Say(argstr .. "'" .. (last ~= "s" and "s" or "") .. " penis is B" .. string.rep("=", length) .. "D " .. length .. " inch" .. (length ~= 1 and "es" or "") .. " long!")
            else
                leAwesomeBot:Say(argstr ..  "'" .. (last ~= "s" and "s" or "") .. " penis is too fucking " .. (leCoinFlip() and "big" or "small") .. " to be measured!!")
            end
        else
            if leCoinFlip(3) then
                leAwesomeBot:Say("Your penis is B" .. string.rep("=", length) .. "D " .. length .. " inch" .. (length ~= 1 and "es" or "") .. " long!")
            else
                leAwesomeBot:Say("Your penis is too fucking " .. (leCoinFlip() and "big" or "small") .. " to be measured!!")
            end
        end
    end,

    explode = function(args, ply, argstr)
        if not ply:IsAdmin() and not ply:IsSuperAdmin() then
            leAwesomeBot:Say("You don't have permission to do this!")

            return
        end

        if args[2] then
            if args[2] == "*" then
                for _, v in ipairs(player.GetAll()) do
                    if not v:IsAdmin() and not v:IsSuperAdmin() then
                        leExplode(v, 1, true)
                    end
                end

                leAwesomeBot:Say("Boom! Boom! BOOM!")
            else
                local tply = player.GetBySteamID(args[2])

                if not IsValid(tply) then
                    for _, v in ipairs(player.GetAll()) do
                        if string.find(v:GetName(), argstr) then
                            tply = v
                            break
                        end
                    end
                end

                if IsValid(tply) then
                    if tply:IsAdmin() or tply:IsSuperAdmin() then
                        leAwesomeBot:Say("That's an admin you " .. table.Random(leBotConfig.insults))
                    else
                        leExplode(tply, 1, true)
                        leAwesomeBot:Say("Boom!")
                    end
                else
                    leAwesomeBot:Say("Unable to explode this person")
                end
            end
        else
            leExplode(ply, 1, true)
            leAwesomeBot:Say("Boom!")
        end
    end,

    explodeban = function(args, ply, argstr)
        if not ply:IsAdmin() and not ply:IsSuperAdmin() then
            leAwesomeBot:Say("You don't have permission to do this!")

            return
        end

        if not args[2] then
            leAwesomeBot:Say("Unable to explodeban this person")

            return
        end

        local tply = player.GetBySteamID(args[2])

        if not IsValid(tply) then
            for _, v in ipairs(player.GetAll()) do
                if string.find(v:GetName(), argstr) then
                    tply = v
                    break
                end
            end
        end

        if IsValid(tply) then
            if tply:IsBot() then
                leAwesomeBot:Say("That's a bot you " .. table.Random(leBotConfig.insults))

                return
            end

            if tply:IsAdmin() or tply:IsSuperAdmin() then
                leAwesomeBot:Say("That's an admin you " .. table.Random(leBotConfig.insults))
            else
                if tply.explodeBanning then
                    leAwesomeBot:Say("Already explodebanning this person!")
                else
                    leAwesomeBot:Say("Goodbye, " .. tply:GetName() .. "!!!")

                    tply.explodeBanning = true

                    if not tply:Alive() then
                        tply:Spawn()
                    end

                    if not tply:HasGodMode() then
                        tply:GodEnable()
                    end

                    tply:SetGravity(-1)
                    tply:ExitVehicle()
                    tply:SetMoveType(MOVETYPE_WALK)
                    
                    cleanup.CC_Cleanup(tply, "", {})

                    local tid = tply:SteamID()

                    for i = 1, leBotConfig.explodebanAmount do
                        timer.Simple(i / 10, function()
                            if IsValid(tply) then
                                tply:SetPos(tply:GetPos() + Vector(0, 0, 72))
                                leExplode(tply, 1, false)

                                if i == leBotConfig.explodebanAmount then
                                    if ULib and ULib.addBan then
                                        ULib.addBan(tid, 0, "Kaboom!", IsValid(ply) and ply or nil)
                                    else
                                        tply:Kick("Kaboom!")
                                        RunConsoleCommand("banid", 0, tid)
                                    end
                                end
                            end
                        end)
                    end
                end
            end
        else
            leAwesomeBot:Say("Unable to explodeban this person")
        end
    end,

    respawnbot = function()
        if IsValid(leAwesomeBot) then
            if not leAwesomeBot:Alive() then
                leAwesomeBot:Spawn()
                leAwesomeBot:Say("I am alive!")
            else
                leAwesomeBot:Say("Im not dead!")
            end
        end
    end,

    rateit = function(args)
        local outof = math.Clamp(tonumber(args[2]) or 10, 10, 100)

        leAwesomeBot:Say("I rate this a " .. math.random(1, outof) .. "/" .. outof)
    end
}

-- Command Aliases

leBotCommands.cum = leBotCommands.sex
leBotCommands.date = leBotCommands.time
leBotCommands.furryporn = leBotCommands.sex
leBotCommands.give = leBotCommands.giveme
leBotCommands.hi = leBotCommands.hello
leBotCommands.playercount = leBotCommands.players
leBotCommands.random = leBotCommands.number
leBotCommands.roll = leBotCommands.dice
leBotCommands["8ball"] = leBotCommands.answer

leBotCommands.vuild = leBotTrollCommands.build
leBotTrollCommands.vuild = leBotTrollCommands.build

for _, v in ipairs(leBotConfig.languages) do
    leBotCommands[v] = leBotCommands.english
end

-- Useful stuff

function leExplode(ply, times, kill)
    if not IsValid(ply) then
        return
    end

    times = math.Clamp(tonumber(times or 1), 1, 127) -- Prevent funny buisness
    kill = kill or false

    local pos = ply:GetPos()

    if kill then
        ply:Kill()
        ply:SetHealth(1)
        ply:Ignite(math.huge)
    end

    local world = game.GetWorld()

    for i = 1, times do
        util.BlastDamage(world, world, pos, 200, 200)
    end

    local fx = EffectData()
    fx:SetOrigin(pos)

    util.Effect("Explosion", fx, true, true)

    fx = nil
end

function leSplitString(str)
    local sections = {}
    local count = 0
    local buf = ""

    string.gsub(str, "(%s?[%S]+)", function(word)
        if count + #word > 126 then
            if word[1] == " " then
                word = string.sub(word, 2)
            end

            sections[#sections + 1] = buf
            buf = word
            count = 0
        else
            buf = buf .. word
            count = count + #word
        end
    end)

    sections[#sections + 1] = buf

    return sections
end

function leDox(isfake)
    isfake = isfake or false

    http.Fetch("https://randomuser.me/api/", function(body)
        local data = util.JSONToTable(body)

        if data and data.results[1] then
            local dox = data.results[1]

            local name = dox.name and dox.name.first .. " " .. dox.name.last or "Unknown"
            local gender = dox.gender and string.upper(dox.gender[1]) .. string.sub(dox.gender, 2) or "Unknown"
            local age = dox.dob and dox.dob.age or "Unknown"
            local ip = string.format("%d.%d.%d.%d", math.random(10, 255), math.random(10, 255), math.random(10, 255), math.random(10, 255)) or "Unknown"
            local cash = "$" .. math.random(10, 100) .. "." .. math.random(10, 99) or "Unknown"
            local height = math.random(4, 6) .. " ft " .. math.random(1, 11) .. " in" or "Unknown"

            local sections = leSplitString((isfake and "" or "Fake Info: Real ") .. "Name: " .. name .. ", Gender: " .. gender .. ", Age: " .. age .. ", IP: " .. ip .. ", Cash: " .. cash .. ", Height: " .. height)

            for _, v in ipairs(sections) do
                leAwesomeBot:Say(v)
            end
        else
            leAwesomeBot:Say("Failed to fetch information")
        end
    end, function(error)
        leAwesomeBot:Say("Failed to fetch information")
    end)
end

function leCoinFlip(chance)
    chance = chance or 5

    return math.random(0, 10) > chance
end

local function IsValidTarget(ent)
    if not IsValid(ent) or not IsValid(leAwesomeBot) then
        return false
    end

    return ent ~= leAwesomeBot and ent:Alive() and not ent:GetNoDraw() and not ent:IsDormant() and ent:GetObserverMode() == OBS_MODE_NONE and ent:Team() ~= TEAM_SPECTATOR and ent:GetColor().a > 0 and leAwesomeBot:GetNWBool("HVHER", false) == ent:GetNWBool("HVHER", false) and not leAwesomeBot:GetNWBool("has_god", false) and not ent:GetNWBool("has_god", false) and not leAwesomeBot:GetNWBool("BuildMode", false) and not ent:GetNWBool("BuildMode", false) and ent:GetNWInt("SH_SZ.Safe", 0) == 0
end

local function GetAimPos(ent)
    if not IsValid(ent) or not IsValid(leAwesomeBot) then
        return nil
    end

    local obbpos = ent:LocalToWorld(ent:OBBCenter())

    local tr = util.TraceLine({
        start = leAwesomeBot:EyePos(),
        endpos = obbpos,
        filter = leAwesomeBot,
        mask = MASK_SHOT
    })

    if tr.Entity == ent then
        return obbpos
    end

    return nil
end

local function GetPlayers()
    local players = {}

    for _, v in ipairs(player.GetAll()) do
        if not IsValidTarget(v) then
            continue
        end

        players[#players + 1] = v
    end

    if IsValid(leAwesomeBot) then
        local bpos = leAwesomeBot:GetPos()
        
        table.sort(players, function(a, b) 
            return a:GetPos():DistToSqr(bpos) > b:GetPos():DistToSqr(bpos)
        end)
    end

    return players
end

local function GetClosest()
    if not IsValid(leAwesomeBot) then
        return
    end

    local boteyes = leAwesomeBot:EyePos()

    for _, v in ipairs(GetPlayers()) do
        if GetAimPos(v) then
            return v
        end
    end
end

-- Hooks

hook.Add("PlayerNoClip", "leme_awesomebot_playernoclip", function(ply)
    if not IsValid(ply) or not ply:Alive() then
        return
    end

    if ply.explodeBanning then
        return false
    end
end)

hook.Add("CanPlayerEnterVehicle", "leme_awesomebot_canentervehicle", function(ply)
    if not IsValid(ply) then
        return
    end

    if ply.explodeBanning then
        return false
    end
end)

hook.Add("PlayerSpawnProp", "leme_awesomebot_playerspawnprop", function(ply)
    if not IsValid(ply) then
        return
    end

    if ply.explodeBanning then
        return false
    end
end)

hook.Add("PlayerDisconnected", "leme_awesomebot_playerdisconnected", function(ply)
    if ply.explodeBanning then
        if ULib and ULib.addBan then
            ULib.addBan(ply:SteamID(), 0, "Kaboom!")
        else
            ply:Kick("Kaboom!")
            RunConsoleCommand("banid", 0, ply:SteamID())
        end
    end

    local plycount = player.GetCount() - 1

    if ply == leAwesomeBot and plycount > 0 then
        if not game.SinglePlayer() and player.GetCount() < game.MaxPlayers() then
            timer.Simple(0, function()
                leAwesomeBot = player.CreateNextBot(leBotConfig.botName)
                leAwesomeBot:Say("Fuck you")
            end)
        end
    else
        local id64 = ply:SteamID64()

        if leBotCache.movetoDelays[id64] then
            leBotCache.movetoDelays[id64] = nil
        end

        if leBotCache.sexDelays[id64] then
            leBotCache.sexDelays[id64] = nil
        end

        if plycount == 1 then
            if IsValid(leAwesomeBot) then
                leAwesomeBot:Kick("Punting " .. leBotConfig.botName .. " - Server is hibernating")
            end
        end
    end
end)

hook.Add("PlayerInitialSpawn", "leme_awesomebot_init", function(ply)
    if IsValid(leAwesomeBot) or ply:IsBot() then
        return
    end

    print("Starting " .. leBotConfig.botName .. "...") -- yay!!

    timer.Simple(0, function()
        if not game.SinglePlayer() and player.GetCount() < game.MaxPlayers() then
            leAwesomeBot = player.CreateNextBot(leBotConfig.botName)
        end
    end)
end)

hook.Add("PlayerSay", "leme_awesomebot_playersay", function(ply, msg, tc)
    if tc then
        return ""
    end

    if not IsValid(ply) or ply == leAwesomeBot then
        return
    end

    msg = string.TrimRight(msg)
    local first = msg[1]

    if first == "!" or first == "/" then
        local args = string.Split(msg, " ")
        local argstr = ""

        if #args > 1 then
            local argn = {}
    
            for i = 2, #args do
                argn[#argn + 1] = args[i]
            end

            argstr = table.concat(argn, " ")
        end

        local cmd = string.lower(string.sub(args[1], 2))

        if first == "/" or first == "." or first == "1" then
            if leBotTrollCommands[cmd] then
                timer.Simple(0, function()
                    if IsValid(leAwesomeBot) then
                        leBotTrollCommands[cmd](args, ply, argstr)
                    end
                end)
            end

            return
        end

        if leBotCommands[cmd] then
            timer.Simple(0, function()
                if IsValid(leAwesomeBot) then
                    leBotCommands[cmd](args, ply, argstr)
                end
            end)
        end
    end
end)

hook.Add("PlayerDeath", "leme_awesomebot_playerdeath", function(ply)
    if ply == leAwesomeBot then
        leBotCache.deathHandled = true

        timer.Simple(4, function()
            if IsValid(leAwesomeBot) then
                leAwesomeBot:Spawn()
            end

            leBotCache.deathHandled = false
        end)
    end
end)

hook.Add("PlayerSilentDeath", "leme_awesomebot_playersilentdeath", function(ply)
    if ply == leAwesomeBot then
        leBotCache.deathHandled = true

        timer.Simple(4, function()
            if IsValid(leAwesomeBot) then
                leAwesomeBot:Spawn()
            end

            leBotCache.deathHandled = false
        end)
    end
end)

hook.Add("PlayerSpawn", "leme_awesomebot_playerspawn", function(ply, trans)
    ply:Extinguish()

    if ply == leAwesomeBot then
        if leBotCache.attacking then
            if leBotCache.activeweapon then
                timer.Simple(0, function()
                    if IsValid(leAwesomeBot) then
                        leAwesomeBot:StripWeapons()
                        leAwesomeBot:Give(leBotCache.activeweapon)
                        leAwesomeBot:SelectWeapon(leBotCache.activeweapon)
                    end
                end)
            end
        end
    end
end)

hook.Add("SetupMove", "leme_awesomebot_setupmove", function(ply, mv, cmd)
    if not IsValid(ply) or not mv or not cmd then
        return
    end

    if ply.explodeBanning then
        mv:SetButtons(0)
        mv:SetMaxSpeed(0)
        mv:SetSideSpeed(0)
        mv:SetForwardSpeed(0)

        cmd:ClearButtons()
        cmd:ClearMovement()
    end

    if ply ~= bot then
        return
    end

    mv:SetButtons(0)

    if not leBotCache.attacking and leBotCache.crouching then
        mv:AddKey(IN_DUCK)
    end
end)

hook.Add("StartCommand", "leme_awesomebot_startcommand", function(ply, cmd)
    if not IsValid(ply) or not cmd or ply ~= leAwesomeBot then
        return
    end

    cmd:ClearMovement()
    cmd:ClearButtons()

    if leBotCache.attacking then
        if not IsValidTarget(leBotCache.attatckTarg) then
            leBotCache.attatckTarg = GetClosest()
        end

        local aimpos = GetAimPos(leBotCache.attatckTarg)

        if aimpos then
            ply:SetEyeAngles((aimpos - ply:EyePos()):Angle())
            cmd:SetForwardMove(10^4)

            local wep = ply:GetActiveWeapon()
    
            if IsValid(wep) then
                if not leBotCache.activeweaponforced then
                    if leBotConfig.weapons[wep:GetClass()] == false then
                        ply:StripWeapons()
    
                        if leBotCache.activeweapon then
                            ply:Give(leBotCache.activeweapon)
                            ply:SelectWeapon(leBotCache.activeweapon)
                        end
                    end
                end

                if wep:Clip1() < 1 then
                    wep:SetClip1(wep:GetMaxClip1())
                end

                if not leBotCache.fired then
                    cmd:SetButtons(IN_ATTACK)
                end

                leBotCache.fired = not leBotCache.fired
            end
        else
            leBotCache.attatckTarg = GetClosest()
        end
    else
        if leBotCache.changeDelay < 0 then
            ply:SetEyeAngles(Angle(math.random(-89, 89), math.random(-180, 180), 0))

            leBotCache.changeCount = leBotCache.changeCount + 1
            leBotCache.changeDelay = SysTime()
        end

        if SysTime() - leBotCache.changeDelay >= leBotConfig.changeDelay then
            leBotCache.changeDelay = -1
        end

        if leBotCache.changeCount >= 5 then
            leBotCache.crouching = not leBotCache.crouching
            leBotCache.changeCount = 0
        end
    end
end)

-- Timers

timer.Create("leme_awesomebot_respawn", 4, 0, function()
    if IsValid(leAwesomeBot) then
        if not leAwesomeBot:Alive() and not leBotCache.deathHandled then
            leAwesomeBot:Spawn()
        end
    else
        for _, v in ipairs(player.GetBots()) do
            if v:GetName() == leBotConfig.botName then
                leAwesomeBot = v
            end
        end
    end
end)

timer.Create("leme_awesomebot_update", 1, 0, function()
    local curtime = SysTime()

    for k, v in pairs(leBotCache.movetoDelays) do
        if curtime - v >= leBotConfig.movetoDelay then
            leBotCache.movetoDelays[k] = nil
        end
    end

    for k, v in pairs(leBotCache.sexDelays) do
        if curtime - v >= leBotConfig.sexDelay then
            leBotCache.sexDelays[k] = nil
        end
    end

    for k, v in pairs(leBotCache.killDelays) do
        if curtime - v >= leBotConfig.killDelay then
            leBotCache.killDelays[k] = nil
        end
    end

    if leBotCache.fuckroseDelay > 0 then
        if curtime - leBotCache.fuckroseDelay >= leBotConfig.fuckroseDelay then
            leBotCache.fuckroseDelay = -1
        end
    end

    if leBotCache.lagDelay > 0 then
        if curtime - leBotCache.lagDelay >= leBotConfig.lagDelay then
            leBotCache.lagDelay = -1
        end
    end

    if leBotCache.storyDelay > 0 then
        if curtime - leBotCache.storyDelay >= leBotConfig.storyDelay then
            leBotCache.storyDelay = -1
        end
    end
end)
