--[[
    lenn's AnarchyBot sucks........
    leme's is best!!!!!

    Made for Rose's server and because AnarchyBot is a bit of a cluster fuck
]]

util.AddNetworkString("leme_awesomebot_printcommands")
util.AddNetworkString("leme_awesomebot_prettycolors")
util.AddNetworkString("leme_awesomebot_request")
util.AddNetworkString("leme_awesomebot_update")

local _reg = debug.getregistry()
local meta_pl = _reg.Player

leAwesomeBot = leAwesomeBot or nil

leBotCache = {
    activeweapon = nil,
    activeweaponforced = false,
    attacking = false,
    attackTarg = nil,
    changeCount = 0,
    changeDelay = 0,
    commandDelays = {},
    crouching = false,
    deathHandled = false,
    fired = false,
    lastUrban = "",
    nCount = 0,
    nrCount = 0,
}

leBotConfig = {
    allowM9KWeapons = true, -- Controls !weapon command allowing M9K
    botName = "CancerPatient",
    changeDelay = 5, -- Controls how often the bot will change its angles
    collectionURL = "steamcommunity.com/sharedfiles/filedetails/?id=2678818450", -- Collection URL for !addons
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
        
    },

    insults = {
        "asshat",
        "book-head",
        "dumb fuck",
        "dumbass",
        "dummy",
        "glagglebottom",
        "goobab",
        "nerd",
        "polyglot"
    },

    weapons = {
        gmod_camera = true,
        m9k_acr2 = false,
        m9k_aw50 = false,
        m9k_barret_m82 = false,
        m9k_contender = false,
        m9k_coolak47 = false,
        m9k_davy_crockett = false,
        m9k_dragunov = false,
        m9k_harpoonkazoo = false,
        m9k_intervention = false,
        m9k_legendaryan94 = false,
        m9k_m202 = false,
        m9k_m24 = false,
        m9k_m98b = false,
        m9k_matador = false,
        m9k_milkormgl = false,
        m9k_minigun = false,
        m9k_nerve_gas = false,
        m9k_orbital_strike = false,
        m9k_prop_shooter = false,
        m9k_psg1 = false,
        m9k_remington7615p = false,
        m9k_sl8 = false,
        m9k_svt40 = false,
        m9k_svu = false,
        none = true,
        weapon_357 = true,
        weapon_ar2 = true,
        weapon_bugbait = true,
        weapon_crossbow = true,
        weapon_crowbar = true,
        weapon_fists = true,
        weapon_flechettegun = false,
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
        leAwesomeBot:Say("Congratulations on not being in pvp mode! It's \"!pvp\"")
    end,

    build = function()
        leAwesomeBot:Say("Congratulations on not being in build mode! It's \"!build\"")
    end,

    hvh = function()
        leAwesomeBot:Say("Congratulations on not being in hvh mode! It's \"!hvh\"")
    end
}

leBotCommands = {
    help = {true, 0, "", function(args, ply)
        leAwesomeBot:Say("My help command is \"!cmdhelp\"")
    end},

    cmdhelp = {true, 0, "Shows this message", function(args, ply)
        leSendCommands(ply) -- Too lazy to do it properly

        leAwesomeBot:Say("Check your console!")
    end},

    report = {true, 0, "Reports a player", function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to report this person")

            return
        end
        
        if args[2] == leBotConfig.botName or argstr == leBotConfig.botName then
            leAwesomeBot:Say("Report has been closed. Reason: Banned for false-reporting.")

            return
        end

        leAwesomeBot:Say(argstr .. " has been reported. Staff should (not) arrive in a minute!")
    end},

    yes = {true, 0, "Yes", function()
        local y = leCoinFlip() and "Yes" or "yes"

        if leCoinFlip() then
            y = string.upper(y)
        end

        leAwesomeBot:Say(y .. (leCoinFlip() and "!" or ""))
    end},

    no = {true, 0, "No", function()
        local n = leCoinFlip() and "No" or "no"

        if leCoinFlip() then
            n = string.upper(n)
        end

        leAwesomeBot:Say(n .. (leCoinFlip() and "!" or ""))
    end},

    dox = {true, 0, "Doxxes a player", function(args)
        if argstr == "" then
            leAwesomeBot:Say("Unable to dox this person")

            return
        end

        leAwesomeBot:Say("Getting fake information about the user...")

        timer.Simple(math.random(2, 6), function()
            leDox()
        end)
    end},

    uptime = {true, 0, "Says the server uptime", function()
        leAwesomeBot:Say("The server has been up for about " .. string.NiceTime(SysTime()))
    end},

    bye = {true, 0, "Bye bye!", function(args, ply)
        leAwesomeBot:Say(table.Random(leBotConfig.farewells):format(ply:GetName()))
    end},

    hello = {true, 0, "Hi!", function(args, ply)
        leAwesomeBot:Say(table.Random(leBotConfig.greetings):format(ply:GetName()))
    end, {"hi"}},

    word = {true, 0, "Gives you x random word(s) (Max: 10, Default: 1)", function(args)
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
    end},

    countdown = {true, 0, "Counts down from x (Max: 10, Default: 1)", function(args)
        local x = math.Clamp(tonumber(args[2]) or 3, 1, 10)

        for i = x, 1, -1 do
            timer.Simple(x - i, function()
                leAwesomeBot:Say(i .. "...")
            end)
        end

        timer.Simple(x + 1, function()
            leAwesomeBot:Say("Go!!!")
        end)
    end},

    ddos = {true, 0, "Ddosses a player", function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to ddos this person")

            return
        end

        leAwesomeBot:Say("Sending 65535 bytes (x128) of data to " .. argstr .. "...")

        timer.Simple(math.random(3, 6), function()
            local last = string.sub(argstr, string.len(argstr))

            leAwesomeBot:Say("Success! " .. argstr .. "'" .. (last ~= "s" and "s" or "") .. " internet is down. Ping results from last 3 seconds: " .. math.random(200, 400) .. "ms, " .. math.random(300, 650) .. "ms, " .. math.random(600, 800) .. "ms")
        end)
    end},

    givesuperadmin = {true, 0, "Gives you super admin (Don't tell anyone about this command!!!!!!!!)", function(args, ply)
        local logvar = GetConVar("ulx_logechocolordefault")
        local logtbl = string.Split(logvar and logvar:GetString() or "151 211 255", " ")
        local logcolor = Color(logtbl[1], logtbl[2], logtbl[3])

        lePrettyColors(ply, Color(0, 0, 0), "(Console)", logcolor, " to ", Color(80, 0, 120), "You", logcolor, ": Verifying you're not a superadmin...")

        if ply:GetUserGroup() == "superadmin" then
            lePrettyColors(ply, Color(0, 0, 0), "(Console)", logcolor, " to ", Color(80, 0, 120), "You", logcolor, ": You're already superadmin!")
        else
            timer.Simple(math.random(0.3, 1), function()
                for _, v in ipairs(player.GetAll()) do
                    if v == ply then
                        continue
                    end

                    lePrettyColors(v, Color(0, 0, 0), "(Console)", logcolor, " added ", Color(80, 0, 120), "Someone", logcolor, " to group ", Color(0, 255, 0), "superadmin")
                end

                lePrettyColors(ply, Color(0, 0, 0), "(Console)", logcolor, " to ", Color(80, 0, 120), "You", logcolor, ": Success! You have been given superadmin by " .. leBotConfig.botName)
                lePrettyColors(ply, Color(0, 0, 0), "(Console)", logcolor, " added ", Color(80, 0, 120), "You", logcolor, " to group ", Color(0, 255, 0), "superadmin")
            end)
        end
    end},

    moveto = {true, 20, "Teleports you to a player", function(args, ply, argstr)
        if not args[2] then
            leAwesomeBot:Say("Unable to moveto that person")

            return
        end

        local targ = leFindBySteamID(args[2]) or leFindByName(argstr)
        local sent = leSend(ply, targ)

        if sent then
            leAwesomeBot:Say(ply:GetName() .. " teleported to " .. targ:GetName())
            leBotCache.commandDelays[ply:SteamID64()].moveto = SysTime()
        else
            leAwesomeBot:Say("Unable to moveto that person")
        end
    end},

    giveme = {true, 0, "Gives you something", function(args, ply, argstr)
        argstr = argstr ~= "" and argstr or "gay sex"

        leAwesomeBot:Say(table.Random(leBotConfig.gives):format(argstr))
    end, {"give"}},

    dice = {true, 0, "Rolls a die", function()
        leAwesomeBot:Say("You rolled a " .. math.random(1, 6))
    end, {"roll"}},

    number = {true, 0, "Gives you a random number from 1 to x (Default: 10)", function(args)
        args[2] = math.Clamp(tonumber(args[2]) or 10, 1, math.huge)

        leAwesomeBot:Say("Random number from 1 to " .. args[2] .. ", the number is: " .. math.random(1, args[2]))
    end, {"random"}},

    flip = {true, 0, "Flips a coin", function()
        leAwesomeBot:Say("Flipped a coin and got " .. (leCoinFlip() and "heads" or "tails"))
    end},

    players = {true, 0, "Says the current player count", function()
        leAwesomeBot:Say("Current player count: " .. player.GetCount())
    end, {"playercount"}},

    fly = {true, 0, "Allows you to fly for 3 seconds", function(args, ply)
        leAwesomeBot:Say("Jump to fly! (Only works for 3 seconds)")

        ply:SetGravity(-0.5)

        timer.Simple(3, function()
            if IsValid(ply) then
                ply:SetGravity(1)
            end
        end)
    end},

    answer = {true, 0, "Asnwers a question", function()
        leAwesomeBot:Say(table.Random(leBotConfig.answers))
    end, {"8ball"}},

    chinese = {true, 0, "說隨機的中國東西", function()
        leAwesomeBot:Say(table.Random(leBotConfig.chinese))
    end},

    japanese = {true, 0, "Weeb", function()
        leAwesomeBot:Say(table.Random(leBotConfig.japanese))
    end},

    chingchong = {true, 0, "What kind of Asian are you?", function()
        if leCoinFlip() then
            leAwesomeBot:Say(table.Random(leBotConfig.chinese))
        else
            leAwesomeBot:Say(table.Random(leBotConfig.japanese))
        end
    end},

    noaccess = {true, 0, "Sets a user to noaccess", function(args, ply, argstr)
        if not ply:IsAdmin() or not ply:IsSuperAdmin() then
            leAwesomeBot:Say("You're not allowed to do this!")

            return
        end

        if not args[2] then
            leAwesomeBot:Say("Unable to noaccess this person")

            return
        end

        local tply = leFindBySteamID(args[2]) or leFindByName(argstr)

        if IsValid(tply) then
            if tply:IsAdmin() or tply:IsSuperAdmin() then
                leAwesomeBot:Say(tply:GetName() .. " is an admin you " .. table.Random(leBotConfig.insults))
            else
                if ulx then
                    RunConsoleCommand("ulx", "adduserid", tply:SteamID(), "noaccess")
                end

                if sam then
                    RunConsoleCommand("sam", "adduser", tply:SteamID(), "noaccess")
                end

                leAwesomeBot:Say("Fuck you " .. tply:GetName() .. "!!!!!!")
            end
        else
            leAwesomeBot:Say("Unable to noaccess this person")
        end
    end},

    sex = {true, 10, "Sex", function(args, ply)
        leAwesomeBot:Say("Sexual content has been banned from Garry's Mod!")

        local len = math.random(5, 10)
        local delay = (0.3 * len) + 1
        local uname = "leme_awesomebot_sexkill_" .. ply:SteamID() .. math.random(1234, 4321)

        leBotCache.commandDelays[ply:SteamID64()].sex = SysTime()

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
    end, {"cum", "furryporn"}},

    die = {true, 0, "Rest in peace", function(args, ply)
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
    end},

    kill = {true, 10, "Kills a player", function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to kill that person")

            return
        end

        leExplode(ply, 1, true)
        leAwesomeBot:Say(argstr .. " has been killed")

        leBotCache.commandDelays[ply:SteamID64()].kill = SysTime()
    end},

    content = {true, 0, "Gives you awesome content ideas!", function()
        leAwesomeBot:Say(table.Random(leBotConfig.content))
    end},

    shutup = {true, 0, "Mutes a player", function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to mute that person")

            return
        end

        leAwesomeBot:Say(argstr .. " has been muted and is now unable to talk")
    end},

    randomreport = {true, 0, "Reports a random person", function()
        leAwesomeBot:Say(table.Random(player.GetAll()):GetName() .. " has been reported. Staff should (not) arrive in a minute!")
    end},

    kit = {true, 0, "Gives you a random kit", function()
        leAwesomeBot:Say("You have received a kit from " .. leBotConfig.botName .. ", it contains: " .. table.Random(leBotConfig.kit))
    end},

    addons = {true, 0, "Gives you a link to the server's collection", function()
        leAwesomeBot:Say("YOU WANT ADDONS??? >> " .. leBotConfig.collectionURL .. " <<")
    end},

    calladmin = {true, 0, "Calls an admin", function()
        leAwesomeBot:Say("You have just called an admin. They will arrive soon!")
    end},

    slap = {true, 0, "Slaps a player", function(args, ply, argstr)
        if argstr == "" then
            leAwesomeBot:Say("Unable to slap that person")

            return
        end

        leAwesomeBot:Say(table.Random(leBotConfig.slap):format(argstr))
    end},

    english = {true, 0, "", function() -- omg hidden command so sneaky
        leAwesomeBot:Say(leBotConfig.botName .. " isn't a language bot you " .. table.Random(leBotConfig.insults))
    end, {"arabic", "bengali", "bosnian", "czech", "filipino", "french", "german", "hawaiian", "hindi", "indonesia", "irish", "italian", "korean", "lahnda", "malay", "malayalam", "persian", "polish", "portuguese", "romanian", "russian", "scottish", "serbian", "somoan", "spanish","swedish", "tamil", "turkish", "urdu", "vietnamese"}},

    ping = {true, 0, "Says your ping", function(args, ply)
        leAwesomeBot:Say("Your ping is " .. ply:Ping())
    end},

    kd = {true, 0, "Says your K/D", function(args, ply)
        local kills = ply:Frags()
        local deaths = ply:Deaths()

        leAwesomeBot:Say("You have " .. kills .. " kill" .. (kills ~= 1 and "s" or "") .. " and " .. deaths .. " death" .. (deaths ~= 1 and "s" or "") .. ", your K/D is " .. kills / deaths)
    end},

    time = {true, 0, "Says the current date and time", function()
        leAwesomeBot:Say("The date and time is " .. os.date("%m/%d/%Y - %H:%M:%S", os.time()))
    end, {"date"}},

    fuckrose = {true, 180, "Fucks rose", function()
        local rose = leFindBySteamID("STEAM_0:1:82072473")

        if IsValid(rose) then
            leAwesomeBot:Say("die you moth of fuck")
    
            leExplode(rose, 1, true)
    
            leBotCache.commandDelays.fuckrose = SysTime()
        else
            leAwesomeBot:Say("Rose not found :(")
        end
    end},

    mutemenu = {true, 0, "Opens the mute menu", function(args, ply)
        leAwesomeBot:Say(ply:GetName() .. " has opened the mute menu! Beware!")
    end},

    test = {true, 0, "Test command", function(args, ply)
        if IsValid(leAwesomeBot) then
            local sent = leSend(leAwesomeBot, ply)

            if sent then
                leAwesomeBot:Say("I have received your beautiful message")

                timer.Create("leme_awesomebot_spazz" .. math.random(1234, 4321), 0, math.random(500, 750), function()
                    leAwesomeBot:SetEyeAngles(Angle(math.random(-89, 89), math.random(-180, 180), 0))
                end)
            else
                leAwesomeBot:Say("Message not received!")
            end
        end
    end},

    say = {true, 0, "Makes the bot say something", function(args, ply, argstr)
        leAwesomeBot:Say(argstr)
    end},

    dupe = {true, 0, "Duplicates something", function(args, ply, argstr)
        argstr = argstr ~= "" and argstr or "thin air"

        leAwesomeBot:Say("Duped " .. argstr .. ". You now have " .. math.random(1, 64) .. " of them!")
    end},

    stoplag = {true, 10, "Freezes all props", function(args, ply)
        local props = ents.FindByClass("prop_physics")
    
        for _, v in ipairs(props) do
            local physobj = v:GetPhysicsObject()
    
            if IsValid(physobj) then
                physobj:Sleep()
                physobj:EnableMotion(false)
            end
        end
    
        leAwesomeBot:Say(ply:GetName() .. " has stopped lag!")

        leBotCache.commandDelays.stoplag = SysTime()
    end},

    whogay = {true, 0, "Who is gay?", function()
        local random = table.Random(player.GetAll())

        leAwesomeBot:Say("I" .. (random:SteamID() == "STEAM_0:1:547859568" and " know " or " think ") .. random:GetName() .. " is gay")
    end},

    dance = {true, 0, "Makes you dance", function(args, ply)
        ply:SendLua([=[LocalPlayer():ConCommand("act dance")]=])
    end},

    laugh = {true, 0, "Makes you laugh", function(args, ply)
        ply:SendLua([=[LocalPlayer():ConCommand("act laugh")]=])
    end},

    flex = {true, 0, "Makes you flex", function(args, ply)
        ply:SendLua([=[LocalPlayer():ConCommand("act muscle")]=])
    end},

    urban = {true, 10, "Defines a word using Urban Dictionary", function(args, ply, argstr)
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

            if not targ then
                leAwesomeBot:Say("Failed to parse data :(")
                return
            end

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
            leBotCache.commandDelays[ply:SteamID64()].urban = SysTime()
        end, function(error)
            leAwesomeBot:Say("Failed to fetch data :(")
        end)
    end},

    story = {true, 15, "Tells you a story", function()
        http.Fetch("http://metaphorpsum.com/paragraphs/2", function(body)
            local sections = leSplitString(body)

            for _, v in ipairs(sections) do
                leAwesomeBot:Say(string.gsub(string.Trim(v), "\n", ""))
            end
        end, function(error)
            leAwesomeBot:Say("Failed to fetch data :(")
        end)

        leBotCache.commandDelays.story = SysTime()
    end},

    fakeinfo = {true, 0, "Generates fake information", function()
        leDox(true)
    end},

    joke = {true, 0, "Tells you a joke", function()
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
    end},

    attack = {true, 0, "Toggles the bot attacking", function()
        leBotCache.attacking = not leBotCache.attacking
    end},

    weapon = {true, 0, "Changes the bot's weapon (You need the weapon CLASS!!!)", function(args)
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
    end},

    forceweapon = {true, 0, "Forces the bot's weapon to something", function(args, ply)
        if not ply:IsAdmin() and not ply:IsSuperAdmin() then
            leAwesomeBot:Say("You don't have permission to do this!")

            return
        end

        if not args[2] then
            leAwesomeBot:Say("Unable to select this weapon")

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
    end},

    come = {true, 0, "Brings the bot to you", function(args, ply)
        if IsValid(leAwesomeBot) then
            if leAwesomeBot:Alive() then
                local sent = leSend(leAwesomeBot, ply)

                if sent then
                    leAwesomeBot:Say("I am here")
                else
                    leAwesomeBot:Say("I can't come right now")
                end
            else
                leAwesomeBot:Say("I'm dead!")
            end
        end
    end},

    penis = {true, 0, "Find out how big someone's penis is!", function(args, ply, argstr)
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
    end},

    explode = {true, 0, "Explodes a player", function(args, ply, argstr)
        local tply = leFindBySteamID(args[2]) or leFindByName(argstr)

        if IsValid(tply) and tply:GetUserGroup() == "noaccess" then
            leExplode(tply, 1, true)
            leAwesomeBot:Say("Boom!")
        end

        if not ply:IsAdmin() and not ply:IsSuperAdmin() then
            leAwesomeBot:Say("You don't have permission to do this!")
            
            return
        end

        if args[2] then
            if args[2] == "*" then
                for _, v in ipairs(player.GetAll()) do
                    if (v:IsAdmin() or v:IsSuperAdmin()) and not ply:IsSuperAdmin() then
                        continue
                    end

                    leExplode(v, 1, true)
                end

                leAwesomeBot:Say("Boom! Boom! BOOM!")
            else
                if IsValid(tply) then
                    if (tply:IsAdmin() or tply:IsSuperAdmin()) and not ply:IsSuperAdmin() then
                        leAwesomeBot:Say("You can't explode that person you " .. table.Random(leBotConfig.insults))
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
    end},

    explodeban = {true, 0, "Explodes and bans a player", function(args, ply, argstr)
        if not ply:IsAdmin() and not ply:IsSuperAdmin() then
            leAwesomeBot:Say("You don't have permission to do this!")

            return
        end

        if not args[2] then
            leAwesomeBot:Say("Unable to explodeban this person")

            return
        end

        local tply = leFindBySteamID(args[2]) or leFindByName(argstr)

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
    end},

    respawnbot = {true, 0, "Forces the bot to respawn", function()
        if IsValid(leAwesomeBot) then
            if not leAwesomeBot:Alive() then
                leAwesomeBot:Spawn()
                leAwesomeBot:Say("I am alive!")
            else
                leAwesomeBot:Say("Im not dead!")
            end
        end
    end},

    rateit = {true, 0, "Rates something out of x (Max: 100, Default: 10)", function(args)
        local outof = math.Clamp(tonumber(args[2]) or 10, 10, 100)

        leAwesomeBot:Say("I rate this a " .. math.random(1, outof) .. "/" .. outof)
    end},

    botmenu = {true, 0, "Opens the bot menu", function(args, ply)
        if not ply:IsSuperAdmin() then
            leAwesomeBot:Say("You don't have permission to do this!")
        end
    end},

    nword = {true, 0, "Shows how many times the N-Word was used", function()
        leAwesomeBot:Say("Total Count: " .. (leBotCache.nCount + leBotCache.nrCount) .. ", Hard R: " .. leBotCache.nrCount)
    end, {"nwordcount"}}
}

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

function leFindBySteamID(param)
    local ply = player.GetBySteamID(param) or player.GetBySteamID64(param)

    if IsValid(ply) then
        return ply
    end
end

function leFindByName(name)
    name = string.lower(name or "")

    for _, v in ipairs(player.GetAll()) do
        if string.find(string.lower(v:GetName()), name) then
            return v
        end
    end
end

function leSend(ply, plythesecond) -- Bascially ULX playerSend clone
    if not IsValid(ply) or not IsValid(plythesecond) or not plythesecond:IsInWorld() then
        return false
    end

    local spos = plythesecond:GetPos()
    local fwd = plythesecond:EyeAngles()

    local dir = {
        fwd.yaw,
        math.NormalizeAngle(fwd.yaw - 90),
        math.NormalizeAngle(fwd.yaw + 90),
        math.NormalizeAngle(fwd.yaw + 180)
    }

    local thing = 1

    local trData = {
        start = plythesecond:LocalToWorld(ply:OBBCenter()),
        endpos = spos + (Angle(0, dir[thing], 0):Forward() * 50),
        filter = {ply, plythesecond}
    }

    local tr = util.TraceLine(trData)

    while tr.Hit do
        thing = thing + 1

        if thing > #dir then -- Epic fail
            return false
        end

        trData.endpos = spos + (Angle(0, dir[thing], 0):Forward() * 50)

        tr = util.TraceLine(trData)
    end

    ply.ulx_prevpos = ply:GetPos() -- Stupid
    ply.ulx_prevang = ply:EyeAngles()

    ply:SetEyeAngles((spos - tr.HitPos):Angle())
    ply:SetPos(tr.HitPos)
    ply:SetAbsVelocity(vector_origin)

    return true
end

function lePrettyColors(ply, ...)
    local data = util.Compress(util.TableToJSON({...}))

    net.Start("leme_awesomebot_prettycolors")
        net.WriteUInt(#data, 16)
        net.WriteData(data, #data)
    net.Send(ply)
end

function leSendCommands(ply)
    if not IsValid(ply) then
        return
    end

    local helpstr = leBotConfig.botName .. " Commands:\n"
    local helptbl = {}

    for k, _ in pairs(leBotCommands) do
        helptbl[#helptbl + 1] = k
    end

    table.sort(helptbl)

    for _, v in pairs(helptbl) do
        local t = leBotCommands[v]

        if type(t) == "table" and t[1] == true and t[3] ~= "" then
            helpstr = helpstr .. "\t!" .. v .. " - " .. t[3]

            if t[5] then
                helpstr = helpstr .. " (Alias" .. (#t[5] ~= 1 and "es" or "") .. ": !" .. table.concat(t[5], ", !") .. ")\n"
            else
                helpstr = helpstr .. "\n"
            end
        end
    end

    local data = util.Compress(helpstr)

    net.Start("leme_awesomebot_printcommands")
        net.WriteUInt(#data, 16)
        net.WriteData(data, #data)
    net.Send(ply)
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
    if not IsValid(ply) then
        return
    end

    if not ply:Alive() or ply.explodeBanning then
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

        if leBotCache.commandDelays[id64] then
            leBotCache.commandDelays[id64] = nil
        end

        if plycount == 1 then
            if IsValid(leAwesomeBot) then
                leAwesomeBot:Kick("Punting " .. leBotConfig.botName .. " - Server is hibernating")
            end
        end
    end
end)

hook.Add("PlayerInitialSpawn", "leme_awesomebot_init", function(ply)
    local id64 = ply:SteamID64()

    if not leBotCache.commandDelays[id64] then
        leBotCache.commandDelays[id64] = {}
    end

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
        return "" -- Fuck team chat
    end

    if not IsValid(ply) or ply == leAwesomeBot then
        return
    end

    local lmsg = string.lower(msg)

    leBotCache.nCount = leBotCache.nCount + select(2, string.gsub(lmsg, "nigga", ""))
    leBotCache.nrCount = leBotCache.nrCount + select(2, string.gsub(lmsg, "nigger", ""))

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
                    if IsValid(leAwesomeBot) and IsValid(ply) then
                        leBotTrollCommands[cmd](args, ply, argstr)
                    end
                end)
            end

            return
        end

        local lcmd = leBotCommands[cmd]

        if not lcmd then
            for k, v in pairs(leBotCommands) do
                if v[5] and table.HasValue(v[5], cmd) then
                    lcmd = leBotCommands[k]
                    cmd = k
                    
                    break
                end
            end
        end

        if lcmd then
            timer.Simple(0, function()
                if IsValid(leAwesomeBot) and IsValid(ply) then
                    if lcmd[1] then
                        local id64 = ply:SteamID64()

                        if not leBotCache.commandDelays[id64] then
                            leBotCache.commandDelays[id64] = {}
                        end

                        if leBotCache.commandDelays[cmd] or leBotCache.commandDelays[id64][cmd] then
                            if leBotCache.commandDelays[cmd] and leBotCache.commandDelays[cmd] > 0 then
                                leAwesomeBot:Say("You can't run this command yet!")

                                return
                            end

                            if leBotCache.commandDelays[id64][cmd] and leBotCache.commandDelays[id64][cmd] > 0 then
                                leAwesomeBot:Say("You can't run this command yet!")

                                return
                            end

                            lcmd[4](args, ply, argstr)
                        else
                            lcmd[4](args, ply, argstr)
                        end
                    else
                        leAwesomeBot:Say("This command is disabled!")
                    end
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

timer.Create("leme_awesomebot_respawnandfix", 4, 0, function()
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

    for k, v in pairs(leBotCache.commandDelays) do
        if type(v) == "table" then
            for c, t in pairs(v) do
                if curtime - t >= leBotCommands[c][2] then
                    leBotCache.commandDelays[k][c] = -1
                end
            end
        else
            if curtime - v >= leBotCommands[k][2] then
                leBotCache.commandDelays[k] = -1
            end
        end
    end

    if IsValid(leAwesomeBot) then
        local unjailed = false

        if sam and leAwesomeBot:sam_get_nwvar("jailed") then
            RunConsoleCommand("sam", "unjail", leAwesomeBot:GetName())
            unjailed = true
        end

        if ulx and leAwesomeBot.jail then
            RunConsoleCommand("ulx", "unjail", leAwesomeBot:GetName())
            unjailed = true
        end

        if unjailed then
            timer.Simple(0.1, function()
                if IsValid(leAwesomeBot) then
                    leAwesomeBot:Say("I am free")
                end
            end)
        end

        local unfrozen = false

        if sam and leAwesomeBot:sam_get_nwvar("frozen") then
            RunConsoleCommand("sam", "unfreeze", leAwesomeBot:GetName())
            leAwesomeBot:Freeze(false)

            unfrozen = true
        end

        if ulx and leAwesomeBot:IsFrozen() then
            RunConsoleCommand("ulx", "unfreeze", leAwesomeBot:GetName())
            leAwesomeBot:Freeze(false)

            unfrozen = true
        end

        if unfrozen then
            timer.Simple(0.1, function()
                if IsValid(leAwesomeBot) then
                    leAwesomeBot:Say("Freeze, bitch!")
                end
            end)
        end
    end
end)

-- Net Shit

net.Receive("leme_awesomebot_request", function(len, ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then
        return
    end

    local commandtable = {}

    for k, v in pairs(leBotCommands) do
        if v[3] ~= "" then
            commandtable[k] = {v[1], v[2], v[5] or {}}
        end
    end

    local stuff = {leBotConfig, leBotCommands}
    local data = util.Compress(util.TableToJSON(stuff))

    net.Start("leme_awesomebot_request")
        net.WriteUInt(#data, 16)
        net.WriteData(data, #data)
    net.Send(ply)
end)

net.Receive("leme_awesomebot_update", function(len, ply)
    if not IsValid(ply) or not ply:IsSuperAdmin() then
        return
    end

    local len = net.ReadUInt(16)
    local data = net.ReadData(len)

    if data then
        --local new = util.JSONToTable(util.Decompress(data)) or {}

        --for k, v in pairs(new) do
        --    if leBotConfig[k] then
        --        leBotConfig[k] = v
        --    end
        --end
    end
end)
