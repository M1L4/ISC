DialogMessage = require "libs.dialog.enum.messages"

print("Received:")
print(string.match("You have received the Old Rod!", DialogMessage.RECEIVED))
print(string.match("You received the Boulder Badge!", DialogMessage.RECEIVED))
print(string.match("You received Bulbasaur!", DialogMessage.RECEIVED))
print(string.match("You received a Pokedex!", DialogMessage.RECEIVED))
print(string.match("You have received a Dragon Fang!", DialogMessage.RECEIVED))
print(string.match("You have received HM01 - Cut!", DialogMessage.RECEIVED))


print("\nFound:")
print(string.match("Finally found an idol to look up to?", DialogMessage.FOUND))    --nil
print(string.match("You found 19 Pokedollar(s)", DialogMessage.FOUND))              --19  Pokedollar(s)
print(string.match("You found 5 Potions!", DialogMessage.FOUND))                    --5 Potions
print(string.match("You found 5 Pokeballs!", DialogMessage.FOUND))                  --5 Pokeballs

print("\nHarvesting:")
print(string.match("Oh look, a Sitrus Berry tree.", DialogMessage.BERRY_TREE))
print(string.match("You harvested 3 of them.", DialogMessage.HARVESTED))