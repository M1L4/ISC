activeQuest = {}
activeQuest.status = 1

--activeQuest = nil

function getNextQuest()
  local t = {}
  t.status = 1
  --  return nil
  return t
end

function getActiveQuest()
  if activeQuest then
    if activeQuest.status == 1 then
      return activeQuest
    end
    log(activeQuest.name .. " is over")
  end

  --are other quests available
  activeQuest = getNextQuest()
  if activeQuest then
    print('Starting new quest: ')
  else
    print("No more quest to do. Script terminated.")
  end
  return activeQuest
end

print(getActiveQuest())
