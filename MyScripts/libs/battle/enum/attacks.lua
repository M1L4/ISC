-- -----------------------------------------------------------------
---@summary: An enum for all pokemon attacks/moves. Access via Attack.MOVE_NAME,
---assuming you binded module to Attack variable.
---@return: pro's pokemon move identifier
---@type: string
---@attention: some verifications still have to be made
---attack name list generated by comparison between:
---1) ProShine's integrated move list and
---2) bulbapedia's move list database:
---https://bulbapedia.bulbagarden.net/wiki/List_of_moves
---
-- -----------------------------------------------------------------
Attack = {
    -- -----------------------------------------------------------------
    -- conflicting attacks | prioritizing Proshine
    -- missing spaces etc... | Silv3r's misspelling or PRO's inconsequent move declaration?
    -- TODO: verify correctness
    -- -----------------------------------------------------------------

    BUBBLE_BEAM = "Bubblebeam",
    DRAGON_BREATH = "Dragonbreath",
    GANGSTA_RAP = "Gangsta Rap",
    MEGAVOLT = "Megavolt",          --MegaVolt - In the Pokémon Adventures manga only
    SAND_ATTACK = "Sand-Attack",
    SELF_DESTRUCT = "Selfdestruct",
    SOFT_BOILED = "Softboiled",
    SONIC_BOOM = "SonicBoom",
    SOUL_CRUSH = "Soul Crush",
    THUNDER_SHOCK = "ThunderShock",
    VICE_GRIP = "ViceGrip",





    -- -----------------------------------------------------------------
    -- new attacks | from ProShine, serve any purpose?
    -- TODO: check, if pro implemented
    -- -----------------------------------------------------------------

    BLANK = "BLANK",
    BROKEN = "BROKEN",
    IGNORE = "IGNORE",
    IGNORE_2 = "IGNORE 2",
    IGNORE_3 = "IGNORE 3",
    IGNORE_4 = "IGNORE 4",
    IGNORE_5 = "IGNORE 5",
    SCRATCH_BROKEN = "Scratch (broken)",





    -- -----------------------------------------------------------------
    -- new attacks | from bulbapedia's move list - not implemented in pro?
    -- TODO: check, if pro implemented
    -- -----------------------------------------------------------------

    TEN_MILLION_VOLT_THUNDERBOLT = "10,000,000 Volt Thunderbolt",
    ACCELEROCK = "Accelerock",
    ACID_DOWNPOUR = "Acid Downpour",
    ALLY_SWITCH = "Ally Switch",
    ALL_OUT_PUMMELING = "All-Out Pummeling",
    ANCHOR_SHOT = "Anchor Shot",
    AROMATIC_MIST = "Aromatic Mist",
    AURORA_VEIL = "Aurora Veil",
    BANEFUL_BUNKER = "Baneful Bunker",
    BEAK_BLAST = "Beak Blast",
    BLACK_HOLE_ECLIPSE = "Black Hole Eclipse",
    BLOOM_DOOM = "Bloom Doom",
    BLUE_FLARE = "Blue Flare",
    BOLT_STRIKE = "Bolt Strike",
    BOOMBURST = "Boomburst",
    BREAKNECK_BLITZ = "Breakneck Blitz",
    BRUTAL_SWING = "Brutal Swing",
    BUBBLE_BEAM = "Bubble Beam",
    BURN_UP = "Burn Up",
    CATASTROPIKA = "Catastropika",
    CELEBRATE = "Celebrate",
    CLANGING_SCALES = "Clanging Scales",
    CLEAR_SMOG = "Clear Smog",
    CONFIDE = "Confide",
    CONTINENTAL_CRUSH = "Continental Crush",
    CORE_ENFORCER = "Core Enforcer",
    CORKSCREW_CRASH = "Corkscrew Crash",
    COTTON_GUARD = "Cotton Guard",
    CRAFTY_SHIELD = "Crafty Shield",
    DARKEST_LARIAT = "Darkest Lariat",
    DAZZLING_GLEAM = "Dazzling Gleam",
    DEVASTATING_DRAKE = "Devastating Drake",
    DIAMOND_STORM = "Diamond Storm",
    DRAGON_ASCENT = "Dragon Ascent",
    DRAGON_BREATH = "Dragon Breath",
    DRAGON_HAMMER = "Dragon Hammer",
    DRAINING_KISS = "Draining Kiss",
    DUAL_CHOP = "Dual Chop",
    ELECTRIC_TERRAIN = "Electric Terrain",
    ELECTRIFY = "Electrify",
    ELECTROWEB = "Electroweb",
    ENTRAINMENT = "Entrainment",
    EXTREME_EVOBOOST = "Extreme Evoboost",
    FAIRY_LOCK = "Fairy Lock",
    FAIRY_WIND = "Fairy Wind",
    FIERY_DANCE = "Fiery Dance",
    FIRE_LASH = "Fire Lash",
    FIRE_PLEDGE = "Fire Pledge",
    FIRST_IMPRESSION = "First Impression",
    FLEUR_CANNON = "Fleur Cannon",
    FLORAL_HEALING = "Floral Healing",
    FLOWER_SHIELD = "Flower Shield",
    FLYING_PRESS = "Flying Press",
    FORESTS_CURSE = "Forest's Curse",
    FOUL_PLAY = "Foul Play",
    FREEZE_DRY = "Freeze-Dry",
    FREEZE_SHOCK = "Freeze Shock",
    FROST_BREATH = "Frost Breath",
    FUSION_BOLT = "Fusion Bolt",
    FUSION_FLARE = "Fusion Flare",
    GEAR_GRIND = "Gear Grind",
    GEAR_UP = "Gear Up",
    GENESIS_SUPERNOVA = "Genesis Supernova",
    GEOMANCY = "Geomancy",
    GIGAVOLT_HAVOC = "Gigavolt Havoc",
    GLACIATE = "Glaciate",
    GRASSY_TERRAIN = "Grassy Terrain",
    GRASS_PLEDGE = "Grass Pledge",
    GUARDIAN_OF_ALOLA = "Guardian of Alola",
    GUARD_SPLIT = "Guard Split",
    HAPPY_HOUR = "Happy Hour",
    HEAD_CHARGE = "Head Charge",
    HEAL_PULSE = "Heal Pulse",
    HEART_STAMP = "Heart Stamp",
    HEAT_CRASH = "Heat Crash",
    HIGH_HORSEPOWER = "High Horsepower",
    HOLD_BACK = "Hold Back",
    HOLD_HANDS = "Hold Hands",
    HONE_CLAWS = "Hone Claws",
    HYDRO_VORTEX = "Hydro Vortex",
    HYPERSPACE_FURY = "Hyperspace Fury",
    HYPERSPACE_HOLE = "Hyperspace Hole",
    ICE_BURN = "Ice Burn",
    ICE_HAMMER = "Ice Hammer",
    ICICLE_CRASH = "Icicle Crash",
    INCINERATE = "Incinerate",
    INFERNO_OVERDRIVE = "Inferno Overdrive",
    INFESTATION = "Infestation",
    INSTRUCT = "Instruct",
    ION_DELUGE = "Ion Deluge",
    KINGS_SHIELD = "King's Shield",
    LANDS_WRATH = "Land's Wrath",
    LASER_FOCUS = "Laser Focus",
    LEAFAGE = "Leafage",
    LEAF_TORNADO = "Leaf Tornado",
    LIGHT_OF_RUIN = "Light of Ruin",
    LIQUIDATION = "Liquidation",
    LOW_SWEEP = "Low Sweep",
    LUNGE = "Lunge",
    MAGNETIC_FLUX = "Magnetic Flux",
    MALICIOUS_MOONSAULT = "Malicious Moonsault",
    MAT_BLOCK = "Mat Block",
    MISTY_TERRAIN = "Misty Terrain",
    MOONGEIST_BEAM = "Moongeist Beam",
    MULTI_ATTACK = "Multi-Attack",
    MYSTICAL_FIRE = "Mystical Fire",
    NATURES_MADNESS = "Nature's Madness",
    NEVER_ENDING_NIGHTMARE = "Never-Ending Nightmare",
    NIGHT_DAZE = "Night Daze",
    NOBLE_ROAR = "Noble Roar",
    OBLIVION_WING = "Oblivion Wing",
    OCEANIC_OPERETTA = "Oceanic Operetta",
    ORIGIN_PULSE = "Origin Pulse",
    PARABOLIC_CHARGE = "Parabolic Charge",
    PARTING_SHOT = "Parting Shot",
    PHANTOM_FORCE = "Phantom Force",
    POLLEN_PUFF = "Pollen Puff",
    POWDER = "Powder",
    POWER_SPLIT = "Power Split",
    POWER_TRIP = "Power Trip",
    POWER_UP_PUNCH = "Power-Up Punch",
    PRECIPICE_BLADES = "Precipice Blades",
    PRISMATIC_LASER = "Prismatic Laser",
    PSYCHIC_FANGS = "Psychic Fangs",
    PSYCHIC_TERRAIN = "Psychic Terrain",
    PSYSTRIKE = "Psystrike",
    PULVERIZING_PANCAKE = "Pulverizing Pancake",
    PURIFY = "Purify",
    QUASH = "Quash",
    REFLECT_TYPE = "Reflect Type",
    RELIC_SONG = "Relic Song",
    REVELATION_DANCE = "Revelation Dance",
    ROTOTILLER = "Rototiller",
    SACRED_SWORD = "Sacred Sword",
    SAND_ATTACK = "Sand Attack",
    SAVAGE_SPIN_OUT = "Savage Spin-Out",
    SEARING_SHOT = "Searing Shot",
    SECRET_SWORD = "Secret Sword",
    SELF_DESTRUCT = "Selfdestruct",
    SHADOW_BONE = "Shadow Bone",
    SHATTERED_PSYCHE = "Shattered Psyche",
    SHELL_TRAP = "Shell Trap",
    SHIFT_GEAR = "Shift Gear",
    SHORE_UP = "Shore Up",
    SIMPLE_BEAM = "Simple Beam",
    SINISTER_ARROW_RAID = "Sinister Arrow Raid",
    SKY_DROP = "Sky Drop",
    SMART_STRIKE = "Smart Strike",
    SNARL = "Snarl",
    SOFT_BOILED = "Soft-Boiled",
    SOLAR_BLADE = "Solar Blade",
    SONIC_BOOM = "Sonic Boom",
    SOUL_STEALING_7_STAR_STRIKE = "Soul-Stealing 7-Star Strike",
    SPARKLING_ARIA = "Sparkling Aria",
    SPECTRAL_THIEF = "Spectral Thief",
    SPEED_SWAP = "Speed Swap",
    SPIKY_SHIELD = "Spiky Shield",
    SPIRIT_SHACKLE = "Spirit Shackle",
    SPOTLIGHT = "Spotlight",
    STEAM_ERUPTION = "Steam Eruption",
    STOKED_SPARKSURFER = "Stoked Sparksurfer",
    STOMPING_TANTRUM = "Stomping Tantrum",
    STORM_THROW = "Storm Throw",
    STRENGTH_SAP = "Strength Sap",
    STRUGGLE_BUG = "Struggle Bug",
    SUBZERO_SLAMMER = "Subzero Slammer",
    SUNSTEEL_STRIKE = "Sunsteel Strike",
    SUPERSONIC_SKYSTRIKE = "Supersonic Skystrike",
    TAIL_SLAP = "Tail Slap",
    TEARFUL_LOOK = "Tearful Look",
    TECHNO_BLAST = "Techno Blast",
    TECTONIC_RAGE = "Tectonic Rage",
    TELEKINESIS = "Telekinesis",
    THOUSAND_ARROWS = "Thousand Arrows",
    THOUSAND_WAVES = "Thousand Waves",
    THROAT_CHOP = "Throat Chop",
    THUNDER_SHOCK = "Thunder Shock",
    TOPSY_TURVY = "Topsy-Turvy",
    TOXIC_THREAD = "Toxic Thread",
    TRICK_OR_TREAT = "Trick-or-Treat",
    TROP_KICK = "Trop Kick",
    TWINKLE_TACKLE = "Twinkle Tackle",
    VENOM_DRENCH = "Venom Drench",
    VICE_GRIP = "Vice Grip",
    V_CREATE = "V-create",
    WATER_PLEDGE = "Water Pledge",
    WATER_SHURIKEN = "Water Shuriken",
    ZING_ZAP = "Zing Zap",





    -- -----------------------------------------------------------------
    -- matching attacks
    -- -----------------------------------------------------------------

    ABSORB = "Absorb",
    ACID = "Acid",
    ACID_ARMOR = "Acid Armor",
    ACID_SPRAY = "Acid Spray",
    ACROBATICS = "Acrobatics",
    ACUPRESSURE = "Acupressure",
    AERIAL_ACE = "Aerial Ace",
    AEROBLAST = "Aeroblast",
    AFTER_YOU = "After You",
    AGILITY = "Agility",
    AIR_CUTTER = "Air Cutter",
    AIR_SLASH = "Air Slash",
    AMNESIA = "Amnesia",
    ANCIENT_POWER = "Ancient Power",
    AQUA_JET = "Aqua Jet",
    AQUA_RING = "Aqua Ring",
    AQUA_TAIL = "Aqua Tail",
    ARM_THRUST = "Arm Thrust",
    AROMATHERAPY = "Aromatherapy",
    ASSIST = "Assist",
    ASSURANCE = "Assurance",
    ASTONISH = "Astonish",
    ATTACK_ORDER = "Attack Order",
    ATTRACT = "Attract",
    AURA_SPHERE = "Aura Sphere",
    AURORA_BEAM = "Aurora Beam",
    AUTOTOMIZE = "Autotomize",
    AVALANCHE = "Avalanche",
    BABY_DOLL_EYES = "Baby-Doll Eyes",
    BARRAGE = "Barrage",
    BARRIER = "Barrier",
    BATON_PASS = "Baton Pass",
    BEAT_UP = "Beat Up",
    BELCH = "Belch",
    BELLY_DRUM = "Belly Drum",
    BESTOW = "Bestow",
    BIDE = "Bide",
    BIND = "Bind",
    BITE = "Bite",
    BLAST_BURN = "Blast Burn",
    BLAZE_KICK = "Blaze Kick",
    BLIZZARD = "Blizzard",
    BLOCK = "Block",
    BODY_SLAM = "Body Slam",
    BONE_CLUB = "Bone Club",
    BONE_RUSH = "Bone Rush",
    BONEMERANG = "Bonemerang",
    BOUNCE = "Bounce",
    BRAVE_BIRD = "Brave Bird",
    BRICK_BREAK = "Brick Break",
    BRINE = "Brine",
    BUBBLE = "Bubble",
    BUG_BITE = "Bug Bite",
    BUG_BUZZ = "Bug Buzz",
    BULK_UP = "Bulk Up",
    BULLDOZE = "Bulldoze",
    BULLET_PUNCH = "Bullet Punch",
    BULLET_SEED = "Bullet Seed",
    CALM_MIND = "Calm Mind",
    CAMOUFLAGE = "Camouflage",
    CAPTIVATE = "Captivate",
    CHARGE = "Charge",
    CHARGE_BEAM = "Charge Beam",
    CHARM = "Charm",
    CHATTER = "Chatter",
    CHIP_AWAY = "Chip Away",
    CIRCLE_THROW = "Circle Throw",
    CLAMP = "Clamp",
    CLOSE_COMBAT = "Close Combat",
    COIL = "Coil",
    COMET_PUNCH = "Comet Punch",
    CONFUSE_RAY = "Confuse Ray",
    CONFUSION = "Confusion",
    CONSTRICT = "Constrict",
    CONVERSION = "Conversion",
    CONVERSION_2 = "Conversion 2",
    COPYCAT = "Copycat",
    COSMIC_POWER = "Cosmic Power",
    COTTON_SPORE = "Cotton Spore",
    COUNTER = "Counter",
    COVET = "Covet",
    CRABHAMMER = "Crabhammer",
    CROSS_CHOP = "Cross Chop",
    CROSS_POISON = "Cross Poison",
    CRUNCH = "Crunch",
    CRUSH_CLAW = "Crush Claw",
    CRUSH_GRIP = "Crush Grip",
    CURSE = "Curse",
    CUT = "Cut",
    DARK_PULSE = "Dark Pulse",
    DARK_VOID = "Dark Void",
    DEFEND_ORDER = "Defend Order",
    DEFENSE_CURL = "Defense Curl",
    DEFOG = "Defog",
    DESTINY_BOND = "Destiny Bond",
    DETECT = "Detect",
    DIG = "Dig",
    DISABLE = "Disable",
    DISARMING_VOICE = "Disarming Voice",
    DISCHARGE = "Discharge",
    DIVE = "Dive",
    DIZZY_PUNCH = "Dizzy Punch",
    DOOM_DESIRE = "Doom Desire",
    DOUBLE_EDGE = "Double-Edge",
    DOUBLE_HIT = "Double Hit",
    DOUBLE_KICK = "Double Kick",
    DOUBLE_SLAP = "Double Slap",
    DOUBLE_TEAM = "Double Team",
    DRACO_METEOR = "Draco Meteor",
    DRAGON_CLAW = "Dragon Claw",
    DRAGON_DANCE = "Dragon Dance",
    DRAGON_PULSE = "Dragon Pulse",
    DRAGON_RAGE = "Dragon Rage",
    DRAGON_RUSH = "Dragon Rush",
    DRAGON_TAIL = "Dragon Tail",
    DRAIN_PUNCH = "Drain Punch",
    DREAM_EATER = "Dream Eater",
    DRILL_PECK = "Drill Peck",
    DRILL_RUN = "Drill Run",
    DYNAMIC_PUNCH = "Dynamic Punch",
    EARTH_POWER = "Earth Power",
    EARTHQUAKE = "Earthquake",
    ECHOED_VOICE = "Echoed Voice",
    EERIE_IMPULSE = "Eerie Impulse",
    EGG_BOMB = "Egg Bomb",
    ELECTRO_BALL = "Electro Ball",
    EMBARGO = "Embargo",
    EMBER = "Ember",
    ENCORE = "Encore",
    ENDEAVOR = "Endeavor",
    ENDURE = "Endure",
    ENERGY_BALL = "Energy Ball",
    ERUPTION = "Eruption",
    EXPLOSION = "Explosion",
    EXTRASENSORY = "Extrasensory",
    EXTREME_SPEED = "Extreme Speed",
    FACADE = "Facade",
    FAKE_OUT = "Fake Out",
    FAKE_TEARS = "Fake Tears",
    FALSE_SWIPE = "False Swipe",
    FEATHER_DANCE = "Feather Dance",
    FEINT = "Feint",
    FEINT_ATTACK = "Feint Attack",
    FELL_STINGER = "Fell Stinger",
    FINAL_GAMBIT = "Final Gambit",
    FIRE_BLAST = "Fire Blast",
    FIRE_FANG = "Fire Fang",
    FIRE_PUNCH = "Fire Punch",
    FIRE_SPIN = "Fire Spin",
    FISSURE = "Fissure",
    FLAIL = "Flail",
    FLAME_BURST = "Flame Burst",
    FLAME_CHARGE = "Flame Charge",
    FLAME_WHEEL = "Flame Wheel",
    FLAMETHROWER = "Flamethrower",
    FLARE_BLITZ = "Flare Blitz",
    FLASH = "Flash",
    FLASH_CANNON = "Flash Cannon",
    FLATTER = "Flatter",
    FLING = "Fling",
    FLY = "Fly",
    FOCUS_BLAST = "Focus Blast",
    FOCUS_ENERGY = "Focus Energy",
    FOCUS_PUNCH = "Focus Punch",
    FOLLOW_ME = "Follow Me",
    FORCE_PALM = "Force Palm",
    FORESIGHT = "Foresight",
    FRENZY_PLANT = "Frenzy Plant",
    FRUSTRATION = "Frustration",
    FURY_ATTACK = "Fury Attack",
    FURY_CUTTER = "Fury Cutter",
    FURY_SWIPES = "Fury Swipes",
    FUTURE_SIGHT = "Future Sight",
    GASTRO_ACID = "Gastro Acid",
    GIGA_DRAIN = "Giga Drain",
    GIGA_IMPACT = "Giga Impact",
    GLARE = "Glare",
    GRASS_KNOT = "Grass Knot",
    GRASS_WHISTLE = "Grass Whistle",
    GRAVITY = "Gravity",
    GROWL = "Growl",
    GROWTH = "Growth",
    GRUDGE = "Grudge",
    GUARD_SWAP = "Guard Swap",
    GUILLOTINE = "Guillotine",
    GUNK_SHOT = "Gunk Shot",
    GUST = "Gust",
    GYRO_BALL = "Gyro Ball",
    HAIL = "Hail",
    HAMMER_ARM = "Hammer Arm",
    HARDEN = "Harden",
    HAZE = "Haze",
    HEAD_SMASH = "Head Smash",
    HEADBUTT = "Headbutt",
    HEAL_BELL = "Heal Bell",
    HEAL_BLOCK = "Heal Block",
    HEAL_ORDER = "Heal Order",
    HEALING_WISH = "Healing Wish",
    HEART_SWAP = "Heart Swap",
    HEAT_WAVE = "Heat Wave",
    HEAVY_SLAM = "Heavy Slam",
    HELPING_HAND = "Helping Hand",
    HEX = "Hex",
    HIDDEN_POWER = "Hidden Power",
    HIGH_JUMP_KICK = "High Jump Kick",
    HORN_ATTACK = "Horn Attack",
    HORN_DRILL = "Horn Drill",
    HORN_LEECH = "Horn Leech",
    HOWL = "Howl",
    HURRICANE = "Hurricane",
    HYDRO_CANNON = "Hydro Cannon",
    HYDRO_PUMP = "Hydro Pump",
    HYPER_BEAM = "Hyper Beam",
    HYPER_FANG = "Hyper Fang",
    HYPER_VOICE = "Hyper Voice",
    HYPNOSIS = "Hypnosis",
    ICE_BALL = "Ice Ball",
    ICE_BEAM = "Ice Beam",
    ICE_FANG = "Ice Fang",
    ICE_PUNCH = "Ice Punch",
    ICE_SHARD = "Ice Shard",
    ICICLE_SPEAR = "Icicle Spear",
    ICY_WIND = "Icy Wind",
    IMPRISON = "Imprison",
    INFERNO = "Inferno",
    INGRAIN = "Ingrain",
    IRON_DEFENSE = "Iron Defense",
    IRON_HEAD = "Iron Head",
    IRON_TAIL = "Iron Tail",
    JUDGMENT = "Judgment",
    JUMP_KICK = "Jump Kick",
    KARATE_CHOP = "Karate Chop",
    KINESIS = "Kinesis",
    KNOCK_OFF = "Knock Off",
    LAST_RESORT = "Last Resort",
    LAVA_PLUME = "Lava Plume",
    LEAF_BLADE = "Leaf Blade",
    LEAF_STORM = "Leaf Storm",
    LEECH_LIFE = "Leech Life",
    LEECH_SEED = "Leech Seed",
    LEER = "Leer",
    LICK = "Lick",
    LIGHT_SCREEN = "Light Screen",
    LOCK_ON = "Lock-On",
    LOVELY_KISS = "Lovely Kiss",
    LOW_KICK = "Low Kick",
    LUCKY_CHANT = "Lucky Chant",
    LUNAR_DANCE = "Lunar Dance",
    LUSTER_PURGE = "Luster Purge",
    MACH_PUNCH = "Mach Punch",
    MAGIC_COAT = "Magic Coat",
    MAGIC_ROOM = "Magic Room",
    MAGICAL_LEAF = "Magical Leaf",
    MAGMA_STORM = "Magma Storm",
    MAGNET_BOMB = "Magnet Bomb",
    MAGNET_RISE = "Magnet Rise",
    MAGNITUDE = "Magnitude",
    ME_FIRST = "Me First",
    MEAN_LOOK = "Mean Look",
    MEDITATE = "Meditate",
    MEGA_DRAIN = "Mega Drain",
    MEGA_KICK = "Mega Kick",
    MEGA_PUNCH = "Mega Punch",
    MEGAHORN = "Megahorn",
    MEMENTO = "Memento",
    METAL_BURST = "Metal Burst",
    METAL_CLAW = "Metal Claw",
    METAL_SOUND = "Metal Sound",
    METEOR_MASH = "Meteor Mash",
    METRONOME = "Metronome",
    MILK_DRINK = "Milk Drink",
    MIMIC = "Mimic",
    MIND_READER = "Mind Reader",
    MINIMIZE = "Minimize",
    MIRACLE_EYE = "Miracle Eye",
    MIRROR_COAT = "Mirror Coat",
    MIRROR_MOVE = "Mirror Move",
    MIRROR_SHOT = "Mirror Shot",
    MIST = "Mist",
    MIST_BALL = "Mist Ball",
    MOONBLAST = "Moonblast",
    MOONLIGHT = "Moonlight",
    MORNING_SUN = "Morning Sun",
    MUD_BOMB = "Mud Bomb",
    MUD_SHOT = "Mud Shot",
    MUD_SLAP = "Mud-Slap",
    MUD_SPORT = "Mud Sport",
    MUDDY_WATER = "Muddy Water",
    NASTY_PLOT = "Nasty Plot",
    NATURAL_GIFT = "Natural Gift",
    NATURE_POWER = "Nature Power",
    NEEDLE_ARM = "Needle Arm",
    NIGHT_SHADE = "Night Shade",
    NIGHT_SLASH = "Night Slash",
    NIGHTMARE = "Nightmare",
    NUZZLE = "Nuzzle",
    OCTAZOOKA = "Octazooka",
    ODOR_SLEUTH = "Odor Sleuth",
    OMINOUS_WIND = "Ominous Wind",
    OUTRAGE = "Outrage",
    OVERHEAT = "Overheat",
    PAIN_SPLIT = "Pain Split",
    PAY_DAY = "Pay Day",
    PAYBACK = "Payback",
    PECK = "Peck",
    PERISH_SONG = "Perish Song",
    PETAL_BLIZZARD = "Petal Blizzard",
    PETAL_DANCE = "Petal Dance",
    PIN_MISSILE = "Pin Missile",
    PLAY_NICE = "Play Nice",
    PLAY_ROUGH = "Play Rough",
    PLUCK = "Pluck",
    POISON_FANG = "Poison Fang",
    POISON_GAS = "Poison Gas",
    POISON_JAB = "Poison Jab",
    POISON_POWDER = "Poison Powder",
    POISON_STING = "Poison Sting",
    POISON_TAIL = "Poison Tail",
    POUND = "Pound",
    POWDER_SNOW = "Powder Snow",
    POWER_GEM = "Power Gem",
    POWER_SWAP = "Power Swap",
    POWER_TRICK = "Power Trick",
    POWER_WHIP = "Power Whip",
    PRESENT = "Present",
    PROTECT = "Protect",
    PSYBEAM = "Psybeam",
    PSYCH_UP = "Psych Up",
    PSYCHIC = "Psychic",
    PSYCHO_BOOST = "Psycho Boost",
    PSYCHO_CUT = "Psycho Cut",
    PSYCHO_SHIFT = "Psycho Shift",
    PSYSHOCK = "Psyshock",
    PSYWAVE = "Psywave",
    PUNISHMENT = "Punishment",
    PURSUIT = "Pursuit",
    QUICK_ATTACK = "Quick Attack",
    QUICK_GUARD = "Quick Guard",
    QUIVER_DANCE = "Quiver Dance",
    RAGE = "Rage",
    RAGE_POWDER = "Rage Powder",
    RAIN_DANCE = "Rain Dance",
    RAPID_SPIN = "Rapid Spin",
    RAZOR_LEAF = "Razor Leaf",
    RAZOR_SHELL = "Razor Shell",
    RAZOR_WIND = "Razor Wind",
    RECOVER = "Recover",
    RECYCLE = "Recycle",
    REFLECT = "Reflect",
    REFRESH = "Refresh",
    REST = "Rest",
    RETALIATE = "Retaliate",
    RETURN = "Return",
    REVENGE = "Revenge",
    REVERSAL = "Reversal",
    ROAR = "Roar",
    ROAR_OF_TIME = "Roar Of Time",
    ROCK_BLAST = "Rock Blast",
    ROCK_CLIMB = "Rock Climb",
    ROCK_POLISH = "Rock Polish",
    ROCK_SLIDE = "Rock Slide",
    ROCK_SMASH = "Rock Smash",
    ROCK_THROW = "Rock Throw",
    ROCK_TOMB = "Rock Tomb",
    ROCK_WRECKER = "Rock Wrecker",
    ROLE_PLAY = "Role Play",
    ROLLING_KICK = "Rolling Kick",
    ROLLOUT = "Rollout",
    ROOST = "Roost",
    ROUND = "Round",
    SACRED_FIRE = "Sacred Fire",
    SAFEGUARD = "Safeguard",
    SAND_TOMB = "Sand Tomb",
    SANDSTORM = "Sandstorm",
    SCALD = "Scald",
    SCARY_FACE = "Scary Face",
    SCRATCH = "Scratch",
    SCREECH = "Screech",
    SECRET_POWER = "Secret Power",
    SEED_BOMB = "Seed Bomb",
    SEED_FLARE = "Seed Flare",
    SEISMIC_TOSS = "Seismic Toss",
    SHADOW_BALL = "Shadow Ball",
    SHADOW_CLAW = "Shadow Claw",
    SHADOW_FORCE = "Shadow Force",
    SHADOW_PUNCH = "Shadow Punch",
    SHADOW_SNEAK = "Shadow Sneak",
    SHARPEN = "Sharpen",
    SHEER_COLD = "Sheer Cold",
    SHELL_SMASH = "Shell Smash",
    SHOCK_WAVE = "Shock Wave",
    SIGNAL_BEAM = "Signal Beam",
    SILVER_WIND = "Silver Wind",
    SING = "Sing",
    SKETCH = "Sketch",
    SKILL_SWAP = "Skill Swap",
    SKULL_BASH = "Skull Bash",
    SKY_ATTACK = "Sky Attack",
    SKY_UPPERCUT = "Sky Uppercut",
    SLACK_OFF = "Slack Off",
    SLAM = "Slam",
    SLASH = "Slash",
    SLEEP_POWDER = "Sleep Powder",
    SLEEP_TALK = "Sleep Talk",
    SLUDGE = "Sludge",
    SLUDGE_BOMB = "Sludge Bomb",
    SLUDGE_WAVE = "Sludge Wave",
    SMACK_DOWN = "Smack Down",
    SMELLING_SALTS = "Smelling Salts",
    SMOG = "Smog",
    SMOKESCREEN = "SmokeScreen",
    SNATCH = "Snatch",
    SNORE = "Snore",
    SOAK = "Soak",
    SOLAR_BEAM = "Solar Beam",
    SPACIAL_REND = "Spacial Rend",
    SPARK = "Spark",
    SPIDER_WEB = "Spider Web",
    SPIKE_CANNON = "Spike Cannon",
    SPIKES = "Spikes",
    SPIT_UP = "Spit Up",
    SPITE = "Spite",
    SPLASH = "Splash",
    SPORE = "Spore",
    STEALTH_ROCK = "Stealth Rock",
    STEAMROLLER = "Steamroller",
    STEEL_WING = "Steel Wing",
    STICKY_WEB = "Sticky Web",
    STOCKPILE = "Stockpile",
    STOMP = "Stomp",
    STONE_EDGE = "Stone Edge",
    STORED_POWER = "Stored Power",
    STRENGTH = "Strength",
    STRING_SHOT = "String Shot",
    STRUGGLE = "Struggle",
    STUN_SPORE = "Stun Spore",
    SUBMISSION = "Submission",
    SUBSTITUTE = "Substitute",
    SUCKER_PUNCH = "Sucker Punch",
    SUNNY_DAY = "Sunny Day",
    SUPER_FANG = "Super Fang",
    SUPERPOWER = "Superpower",
    SUPERSONIC = "Supersonic",
    SURF = "Surf",
    SWAGGER = "Swagger",
    SWALLOW = "Swallow",
    SWEET_KISS = "Sweet Kiss",
    SWEET_SCENT = "Sweet Scent",
    SWIFT = "Swift",
    SWITCHEROO = "Switcheroo",
    SWORDS_DANCE = "Swords Dance",
    SYNCHRONOISE = "Synchronoise",
    SYNTHESIS = "Synthesis",
    TACKLE = "Tackle",
    TAIL_GLOW = "Tail Glow",
    TAIL_WHIP = "Tail Whip",
    TAILWIND = "Tailwind",
    TAKE_DOWN = "Take Down",
    TAUNT = "Taunt",
    TEETER_DANCE = "Teeter Dance",
    TELEPORT = "Teleport",
    THIEF = "Thief",
    THRASH = "Thrash",
    THUNDER = "Thunder",
    THUNDER_FANG = "Thunder Fang",
    THUNDER_PUNCH = "Thunder Punch",
    THUNDER_WAVE = "Thunder Wave",
    THUNDERBOLT = "Thunderbolt",
    TICKLE = "Tickle",
    TORMENT = "Torment",
    TOXIC = "Toxic",
    TOXIC_SPIKES = "Toxic Spikes",
    TRANSFORM = "Transform",
    TRI_ATTACK = "Tri Attack",
    TRICK = "Trick",
    TRICK_ROOM = "Trick Room",
    TRIPLE_KICK = "Triple Kick",
    TRUMP_CARD = "Trump Card",
    TWINEEDLE = "Twineedle",
    TWISTER = "Twister",
    U_TURN = "U-Turn",
    UPROAR = "Uproar",
    VACUUM_WAVE = "Vacuum Wave",
    VENOSHOCK = "Venoshock",
    VINE_WHIP = "Vine Whip",
    VITAL_THROW = "Vital Throw",
    VOLT_SWITCH = "Volt Switch",
    VOLT_TACKLE = "Volt Tackle",
    WAKE_UP_SLAP = "Wake-Up Slap",
    WATER_GUN = "Water Gun",
    WATER_PULSE = "Water Pulse",
    WATER_SPORT = "Water Sport",
    WATER_SPOUT = "Water Spout",
    WATERFALL = "Waterfall",
    WEATHER_BALL = "Weather Ball",
    WHIRLPOOL = "Whirlpool",
    WHIRLWIND = "Whirlwind",
    WIDE_GUARD = "Wide Guard",
    WILD_CHARGE = "Wild Charge",
    WILL_O_WISP = "Will-o-Wisp",
    WING_ATTACK = "Wing Attack",
    WISH = "Wish",
    WITHDRAW = "Withdraw",
    WONDER_ROOM = "Wonder Room",
    WOOD_HAMMER = "Wood Hammer",
    WORK_UP = "Work Up",
    WORRY_SEED = "Worry Seed",
    WRAP = "Wrap",
    WRING_OUT = "Wring Out",
    X_SCISSOR = "X-Scissor",
    YAWN = "Yawn",
    ZAP_CANNON = "Zap Cannon",
    ZEN_HEADBUTT = "Zen Headbutt",
}


return Attack
