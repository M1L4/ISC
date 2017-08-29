function comma_value(n) -- credit http://richard.warburton.it
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function kFormatter(num)
    if num >= 1000 then return string.format("%.1f", num/1000).."k" end
    return num
end
