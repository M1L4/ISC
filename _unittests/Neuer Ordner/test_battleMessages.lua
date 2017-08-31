BattleMessage = require "libs.battle.enum.messages"

print("\nExp:")
print(string.match("Aron gained 160 Exp.", BattleMessage.EXP))

print("\nWildEncounter:")
print(string.match("A Wild Natu Attacks!", BattleMessage.WILD_ENCOUNTER))
print(string.match("A Wild Nidoran M Attacks!", BattleMessage.WILD_ENCOUNTER))
print(string.match("A Wild Nidoran F Attacks!", BattleMessage.WILD_ENCOUNTER))
print(string.match("A Wild SHINY Natu Attacks!", BattleMessage.WILD_ENCOUNTER))
print(string.match("A Wild SHINY Nidoran M Attacks!", BattleMessage.WILD_ENCOUNTER))
print(string.match("A Wild SHINY Nidoran F Attacks!", BattleMessage.WILD_ENCOUNTER))

print("\nShinyEncounter:")
print(string.match("A Wild Natu Attacks!", BattleMessage.SHINY_ENCOUNTER))
print(string.match("A Wild Nidoran M Attacks!", BattleMessage.SHINY_ENCOUNTER))
print(string.match("A Wild Nidoran F Attacks!", BattleMessage.SHINY_ENCOUNTER))
print(string.match("A Wild SHINY Natu Attacks!", BattleMessage.SHINY_ENCOUNTER))
print(string.match("A Wild SHINY Nidoran M Attacks!", BattleMessage.SHINY_ENCOUNTER))
print(string.match("A Wild SHINY Nidoran F Attacks!", BattleMessage.SHINY_ENCOUNTER))