function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function string.explode(str, div)
    assert(type(str) == "string" and type(div) == "string", "invalid arguments")
    local o = {}
    while true do
        local pos1,pos2 = str:find(div)
        if not pos1 then
            o[#o+1] = str
            break
        end
        o[#o+1],str = str:sub(1,pos1-1),str:sub(pos2+1)
    end
    return o
end

--determines if two lines intersect, assuming lines only go up and down or across, and line direction is given
function isIntersecting(x1,y1,x2,y2,dir1, x3,y3,x4,y4,dir2)
    if (dir1 == "S" and dir2 == "S") or (dir1 == "S" and dir2 == "N") or (dir1 == "N" and dir2 == "S") or (dir1 == "N" and dir2 == "N") then
		if (x1 == x3) then
			return isBetween(y1,y3,y4) or isBetween(y2,y3,y4)
		else 
			return false
		end
	elseif (dir1 == "W" and dir2 == "E") or (dir1 == "E" and dir2 == "W") or (dir1 == "W" and dir2 == "W") or (dir1 == "E" and dir2 == "E") then
		if (y1 == y3) then
			return isBetween(x1,x3,x4) or isBetween(x2,x3,x4)
		else 
			return false
		end
	elseif (dir1 == "N" and dir2 == "W") or (dir1 == "N" and dir2 == "E") or (dir1 == "S" and dir2 == "W") or (dir1 == "S" and dir2 == "E") then
		return isBetween(x1,x3,x4) and isBetween(y3,y1,y2)
	elseif (dir1 == "E" and dir2 == "N") or (dir1 == "E" and dir2 == "S") or (dir1 == "W" and dir2 == "N") or (dir1 == "W" and dir2 == "S") then
		return isBetween(y1,y3,y4) and isBetween(x3,x1,x2)
	end
end

-- returns true if numA is between x1 and x2 (inclusive)
function isBetween(numA, x1,x2)
	if ((numA >= x1) and (numA <= x2)) then
		print(x1 .." <= "..numA.." <= ".. x2)
		return true
	end
	
	if ((numA <= x1) and (numA >= x2)) then
		print(x1 .." >= "..numA.." >= ".. x2)
		return true
	end
	
	return false
	--return ((numA >= x1) and (numA <= x2)) or ((numA <= x1) and (numA >= x2))
end
