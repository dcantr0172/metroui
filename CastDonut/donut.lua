-- The LibDonut code is an adaptation of Iriel's StatRings Template code, adapted with permission
-- All functionality is his, I just adapated it for changes in the wow lua and fitted it with a libstub wrapper

local major = "LibDonut-1.0"
local minor = tonumber(("$Rev: 4 $"):match("(%d+)")) or 1
if not LibStub then error("LibDonut-3.0 requires LibStub.") end
local lib, old = LibStub:NewLibrary(major, minor)
if not lib then return end

-- ninjaed from LibBars-1.0
lib.dummyFrame = lib.dummyFrame or CreateFrame("Frame")
lib.donutFrameMT = lib.donutFrameMT or {__index = lib.dummyFrame}
lib.donutPrototype = lib.donutProtoType or setmetatable({}, lib.donutFrameMT)
lib.donutPrototype_mt = lib.donutPrototype_mt or {__index = lib.donutPrototype}
lib.availableDonuts = lib.availableDonuts or {}

local donutPrototype = lib.donutPrototype
local donutPrototype_meta = lib.donutPrototype_mt

local initTexCoordMapFuncs = {}
-- Texture coordinate mapping functions
initTexCoordMapFuncs[1] = function(ulx,uly, llx,lly, urx,ury, lrx,lry) 
	return ulx,uly, llx,lly, urx,ury, lrx,lry;
end
initTexCoordMapFuncs[2] = function(ulx,uly, llx,lly, urx,ury, lrx,lry) 
	return llx,lly, lrx,lry, ulx, uly, urx,ury;
end
initTexCoordMapFuncs[3] = function(ulx,uly, llx,lly, urx,ury, lrx,lry) 
	return lrx,lry, urx,ury, llx,lly, ulx,uly;
end
initTexCoordMapFuncs[4] = function(ulx,uly, llx,lly, urx,ury, lrx,lry) 
			return urx,ury, ulx,uly, lrx,lry, llx,lly;
end
donutPrototype.ringTexCoordMapFuncs = initTexCoordMapFuncs
donutPrototype.sliceTexCoordMapFuncs = initTexCoordMapFuncs

local initSetSubsetFuncs = {}
-- Q1: TOP RIGHT
initSetSubsetFuncs[1] = function(tex, parname, radius, xlo, xhi, ylo, yhi, TM)
	if (TM) then
		tex:SetTexCoord(TM(xlo,1-yhi, xlo,1-ylo, xhi,1-yhi, xhi,1-ylo));
	end
	tex:SetPoint("TOPLEFT", parname, "CENTER", xlo*radius, yhi*radius);
	tex:SetPoint("BOTTOMRIGHT", parname, "CENTER", xhi*radius, ylo*radius);
end

-- Q2: BOTTOM RIGHT
initSetSubsetFuncs[2] = function(tex, parname, radius, xlo, xhi, ylo, yhi, TM)
	if (TM) then
		tex:SetTexCoord(TM(xlo,1-yhi, xlo,1-ylo, xhi,1-yhi, xhi,1-ylo));
	end
	tex:SetPoint("TOPRIGHT", parname, "CENTER", yhi*radius, -xlo*radius);
	tex:SetPoint("BOTTOMLEFT", parname, "CENTER", ylo*radius, -xhi*radius);
end

-- Q3: BOTTOM LEFT
initSetSubsetFuncs[3] = function(tex, parname, radius, xlo, xhi, ylo, yhi, TM)
	if (TM) then
		tex:SetTexCoord(TM(xlo,1-yhi, xlo,1-ylo, xhi,1-yhi, xhi,1-ylo));
	end
	tex:SetPoint("BOTTOMRIGHT", parname, "CENTER", -xlo*radius, -yhi*radius);
	tex:SetPoint("TOPLEFT", parname, "CENTER", -xhi*radius, -ylo*radius);
end

-- Q4: TOP LEFT
initSetSubsetFuncs[4] = function(tex, parname, radius, xlo, xhi, ylo, yhi, TM)
	if (TM) then
		tex:SetTexCoord(TM(xlo,1-yhi, xlo,1-ylo, xhi,1-yhi, xhi,1-ylo));
	end
	tex:SetPoint("BOTTOMLEFT", parname, "CENTER", -yhi*radius, xlo*radius);
	tex:SetPoint("TOPRIGHT", parname, "CENTER", -ylo*radius, xhi*radius);
end

donutPrototype.setSubsetFuncs = initSetSubsetFuncs

-- The 'Work' function, which handles subset rendering for a single
-- quadrant (normalized to Q1) that starts at the 0 degree position
--
-- Params:
--  A    - The angle within the quadrant (degrees, 0 <= A < 90)
--  T    - The main texture for the quadrant
--  SS   - The texture subset mapping function for the quadrant
--  TM   - The ring texture coord mapping function for the quadrant
--  S    - Slice texture (optional)
--  C    - Chip texture (optional)
function donutPrototype:DoQuadrant(A, T, SS, TM, S, C)
	-- Grab local references to important textures
	S = S or self.slice
	C = C or self.chip

	-- If no part of this quadrant is visible, just hide all the textures
	-- and be done.
	if A == 0 then
		T:Hide()
		C:Hide()
		S:Hide()
		return
	end

	-- More local references, grab the ring dimensions
	local RF = self.ringFactor
	local OR = self.radius

	-- Drawing scheme uses three locations
	--   N (Nx,Ny) - The 'Noon' position (Nx=0, Ny=1)
	--   O (Ox,Oy) - Intersection of angle line with Outer edge
	--   I (Ix,Iy) - Intersection of angle line with Inner edge

	-- Calculated locations:
	--   Arad  - Angle in radians
	--   Ox,Oy - O coordinates
	--   Ix,Iy - I coordinates
	local Arad = math.rad(A)
	local Ox = math.sin(Arad)
	local Oy = math.cos(Arad)
	local Ix = Ox * RF
	local Iy = Oy * RF

	-- Treat first and last halves differently to maximize size of main
	-- texture subset.
	if (A <= 45) then
		-- Main subset is from N to I
		SS(T, self, OR, 0, Ix, Iy, 1,  TM)
		-- Chip is subset from (Ix,Oy) to (Ox,Ny) (Right edge of main)
		SS(C, self, OR, Ix, Ox, Oy, 1, TM)
	else
		-- Main subset is from N to O
		SS(T, self, OR, 0, Ox, Oy, 1,  TM)
		-- Chip is subset from (Nx,Iy) to (Ix,Oy) (Bottom edge of main)
		SS(C, self, OR, 0, Ix, Iy, Oy, TM)
	end
	-- Strech slice between I and O
	SS(S, self, OR, Ix, Ox, Iy, Oy)
	-- All three textures are visible
	T:Show()
	C:Show()
	S:Show()
end

-- The 'Work' function, which handles subset rendering for a single
-- quadrant (normalized to Q1) in reverse
--
-- Params:
--  A    - The angle within the quadrant (degrees, 0 <= A < 90)
--  T    - The main texture for the quadrant
--  SS   - The texture subset mapping function for the quadrant
--  TM   - The ring texture coord mapping function for the quadrant
--  S    - Slice texture <Reversed> (optional)
--  C    - Chip texture (optional)
function donutPrototype:DoQuadrantReversed(A, T, SS, TM, S, C)
	-- Grab local references to important textures
	S = S or self.slice
	C = C or self.chip

	-- If no part of this quadrant is visible, just hide all the textures
	-- and be done.
	if A == 0 then
		T:Hide()
		C:Hide()
		S:Hide()
		return
	end

	-- More local references, grab the ring dimensions
	local RF = self.ringFactor
	local OR = self.radius

	-- Drawing scheme uses three locations
	--   E (Ex,Ey) - The 'End' position (Nx=1, Ny=0)
	--   O (Ox,Oy) - Intersection of angle line with Outer edge
	--   I (Ix,Iy) - Intersection of angle line with Inner edge

	-- Calculated locations:
	--   Arad  - Angle in radians
	--   Ox,Oy - O coordinates
	--   Ix,Iy - I coordinates
	local Arad = math.rad(A)
	local Ox = math.cos(Arad)
	local Oy = math.sin(Arad)
	local Ix = Ox * RF
	local Iy = Oy * RF

	-- Treat first and last halves differently to maximize size of main
	-- texture subset.
	if A <= 45 then
		-- Main subset is from N to I
		SS(T, self, OR, Ix, 1,  0, Iy, TM)
		-- Chip is subset from (Ix,Oy) to (Ox,Ny) (Right edge of main)
		SS(C, self, OR, Ox, 1, Iy, Oy, TM)
	else
		-- Main subset is from N to O
		SS(T, self, OR, Ox, 1,  0, Oy, TM)
		-- Chip is subset from (Nx,Iy) to (Ix,Oy) (Bottom edge of main)
		SS(C, self, OR, Ix, Ox, 0, Iy, TM)
	end
	-- Strech slice between I and O
	SS(S, self, OR, Ix, Ox, Iy, Oy)
	-- All three textures are visible
	T:Show()
	C:Show()
	S:Show()
end

-- The 'Work' function, which handles subset rendering for a single
-- quadrant (normalized to Q1), subsetted between two angle
--
-- Params:
--  BA   - The BEGIN angle within the quadrant (degrees, 0 <= BA <= EA)
--  EA   - The END  angle within the quadrant (degrees, BA <= EA <= 90)
--  T    - The main texture for the quadrant
--  SS   - The texture subset mapping function for the quadrant
--  TM   - The ring texture coord mapping function for the quadrant
--  BS   - Begin Slice texture (optional)
--  BC   - Begin Chip texture (optional)
--  ES   - End Slice texture (optional)
--  EC   - End Chip texture (optional)
--  LL   - Line piece (optional)
--  LTM  - Line piece texture map (optional)
function donutPrototype:DoQuadrantPartial(BA, EA, T, SS, TM, BS, BC, ES, EC, LL, LTM)
	-- Grab local references to important textures
	BS = BS or self.slice2
	BC = BC or self.chip2
	ES = ES or self.slice
	EC = EC or self.chip
	LL = LL or self.quadExtra
	LTM = LTM or TM;

	-- If no part of this quadrant is visible, just hide all the textures
	-- and be done.
	if BA == EA then
		T:Hide()
		BC:Hide()
		BS:Hide()
		EC:Hide()
		ES:Hide()
		LL:Hide()
		return
	end

	-- Simplifications for common cases
	if BA == 0 then
		LL:Hide()
		BC:Hide()
		BS:Hide()
		return self:DoQuadrant(EA, T, SS, TM, ES, EC)
	elseif EA == 90 then
		LL:Hide()
		EC:Hide()
		ES:Hide()
		return self:DoQuadrantReversed(90-BA, T, SS, TM, BS, BC)
	end

	-- More local references, grab the ring dimensions, and the frame name.
	local RF = self.ringFactor
	local OR = self.radius

	-- Drawing scheme uses four locations
	--   BO (BOx,EOy) - Intersection of begin angle line with Outer edge
	--   BI (BIx,EIy) - Intersection of begin angle line with Inner edge
	--   EO (EOx,EOy) - Intersection of end angle line with Outer edge
	--   EI (EIx,EIy) - Intersection of end angle line with Inner edge

	-- Calculated locations:
	local BArad = math.rad(BA)
	local BOx = math.sin(BArad)
	local BOy = math.cos(BArad)
	local BIx = BOx * RF
	local BIy = BOy * RF
	local EArad = math.rad(EA)
	local EOx = math.sin(EArad)
	local EOy = math.cos(EArad)
	local EIx = EOx * RF
	local EIy = EOy * RF

	-- Test for 'small segment' special case
	if EA >= 45 then
		-- Calculate where X=BOx crosses the E line
		-- E line is EOx * y = EOy * x  ==>  y = (EOy * x) / EOx
		local BOEy = (EOy * BOx) / EOx
		if (BOEy > BIy) then
		-- Small segment!
			local EIBy = (BOy * EIx) / BOx

			local l = (BOy - EIy) / 2

			LL:SetTexture(ES:GetTexture());
			LL:SetTexCoord(LTM(1 - (l / (EIBy-EIy)),0, 
							1,0,
							0,1,
							(l / (BOy-BOEy)),1))
			SS(LL, self, OR, EIx, BOx, EIy, BOy)
			SS(T,  self, OR, BIx, EIx, EIy, BIy, TM)
			SS(BC, self, OR, BOx, EOx, EOy, BOy, TM)
			SS(BS, self, OR, BIx, EIx, BIy, EIBy)
			SS(ES, self, OR, BOx, EOx, BOEy, EOy)
	
			LL:Show()
			T:Show()
			BC:Show()
			BS:Show()
			ES:Show()

			EC:Hide()
			return
		end
	else
		-- Calculate where y=EOy crosses the B line
		-- B line is BOx * y = BOy * x  ==>  x = (BOx * y) / BOy
		local EOBx = (BOx * EOy) / BOy
		if EOBx > EIx then
			-- Small segment!
			local BIEx = (EOx * BIy) / EOy
			local l = (EOx-BIx) / 2

			LL:SetTexture(ES:GetTexture())
			LL:SetTexCoord(LTM(1 - (l / (EOx-EOBx)),0, 
							0,1,
							1,0,
							(l / (BIEx-BIx)),1))

			SS(LL, self, OR, BIx, EOx, BIy, EOy)
			SS(T,  self, OR, BIx, EIx, EIy, BIy, TM)
			SS(BC, self, OR, BOx, EOx, EOy, BOy, TM)
			SS(BS, self, OR, EOBx, BOx, EOy, BOy)
			SS(ES, self, OR, EIx, BIEx, EIy, BIy)

			LL:Show()
			T:Show()
			BC:Show()
			BS:Show()
			ES:Show()

			EC:Hide()
			return
		end
	end

	LL:Hide()
	
	-- There are a few alternatives here
	if EA <= 45 then
		-- All at the start, non-overlapping
		-- Main subset is from BO to EI
		SS(T, self, OR, BOx, EIx, EIy, BOy, TM)
		SS(BC, self, OR, BIx, BOx, EIy, BIy, TM)
		SS(EC, self, OR, EIx, EOx, EOy, BOy, TM)
	elseif (BA >= 45) then
		-- All at the end, non-overlapping
		-- Main subset is from BI to EO
		SS(T, self, OR, BIx, EOx, EOy, BIy, TM)
		SS(BC, self, OR, BOx, EOx, BIy, BOy, TM)
		SS(EC, self, OR, BIx, EIx, EIy, EOy, TM)
	else
		-- Split across, non-overlapping
		-- Main subset is from BO to EO
		SS(T, self, OR, BOx, EOx, EOy, BOy, TM)
		SS(BC, self, OR, BIx, BOx, EOy, BIy, TM)
		SS(EC, self, OR, BOx, EIx, EIy, EOy, TM)
	end

	-- Treat first and last halves differently to maximize size of main
	-- texture subset.
	if (BA <= 45) then
		-- Main subset is from N to I
		--   SS(T, name, OR, Ix, 1,  0, Iy);
		-- Chip is subset from (Ix,Oy) to (Ox,Ny) (Right edge of main)
		-- SS(C, name, OR, Ox, 1, Iy, Oy);
	else
		-- Main subset is from N to O
		--SS(T, name, OR, Ox, 1,  0, Oy);
		-- Chip is subset from (Nx,Iy) to (Ix,Oy) (Bottom edge of main)
		--SS(C, name, OR, Ix, Ox, 0, Iy);
	end
	-- Strech begin slice between BI and BO
	SS(BS, self, OR, BIx, BOx, BIy, BOy);
	-- Strech end slice between EI and EO
	SS(ES, self, OR, EIx, EOx, EIy, EOy);
	-- All three textures are visible
	T:Show()
	BC:Show()
	BS:Show()
	EC:Show()
	ES:Show()
end

-- Method function to set the angle to display
--
-- Param:
--  angle - The angle in degrees (0 <= angle <= 360)
--  startAngle - The angle to start at in degrees (0 <= angle <= 360)
function donutPrototype:SetAngle(angle, startAngle)
	if startAngle == nil then
		startAngle = self.startAngle or 0
	end
	if startAngle < 0 then
		startAngle = 360-mod(-startAngle, 360)
		if startAngle == 360 then
			startAngle = 0
		end
	elseif startAngle > 360 then
		startAngle = mod(startAngle, 360)
	end

	-- Bounds checking on the angle so that it's between 0 and 360 (inclusive)
	if angle < 0 then
		angle = 0
	end
	if angle > 360 then
		angle = 360
	end

	-- Avoid duplicate work
	if self.angle == angle and self.startAngle == startAngle then
		return
	end

	-- Since we have control of both ends, reversal can be dealth with here
	-- which simplifies the later code
	local startA
	if self.reversed then
		startA = mod(720 - (startAngle + angle), 360)
	else
		startA = startAngle
	end

	-- Normalize starting quadrant back into quadrant 1
	local quadOfs = (self.quadOffset or 0) + math.floor(startA / 90)
	startA = mod(startA, 90)

	if (quadOfs ~= self.lastQuadOffset) then
		-- Must re-do quadrant loop if we've moved around
		self.lastQuadOffset = quadOfs
		self.lastQuad = nil
	end

	-- Calculate end quadrant
	-- (Quadrant 5 means 'wraparound')
	local quad = math.floor((angle + startA) / 90) + 1
	local endA = mod((angle + startA), 90)
	local effStartQuad = quadOfs + 1
	local effQuad = mod(quad+quadOfs-1, 4)+1

	local setSubsetFuncs = self.setSubsetFuncs
	local ringTexCoordMapFuncs = self.ringTexCoordMapFuncs
	local sliceTexCoordMapFuncs = self.sliceTexCoordMapFuncs

	-- Check to see if we've changed quandrants since the last time we were
	-- called. Quadrant changes re-configure some textures.
	if quad ~= self.lastQuad then
		-- Loop through all quadrants
		local quadCheck = mod(quad-1,4)+1
		local qi, TCM, STCM
		for i=1,4 do
			qi = mod(i+quadOfs-1, 4)+1
			TCM = ringTexCoordMapFuncs[qi]
			STCM = sliceTexCoordMapFuncs[qi]
			local T=self.quadrants[i]
			if i == 1 then
				-- This is the start quadrant, configure the 2nd slice and chip
				self.slice2:SetTexCoord(STCM(0,0, 0,1, .5,0, .5,1))
				self.chip2:SetTexture(T:GetTexture())
			end

			if i == quadCheck then
				-- This is the 'end' quadrant, configure slice and chip
				T:ClearAllPoints()
				setSubsetFuncs[qi](T, self, self.radius, 0,1,0,1, TCM)
				T:SetTexCoord(TCM(0,0,0,1,1,0,1,1))
				T:Show()
				self.slice:SetTexCoord(STCM(.5,0, .5,1, 1,0, 1,1))
				self.chip:SetTexture(T:GetTexture())
			elseif (i < quad) then
				-- If this quadrant is full shown, then show all of the texture
				-- It may be reduced later by start processing
				T:ClearAllPoints()
				setSubsetFuncs[qi](T, self, self.radius, 0,1,0,1, TCM)
				T:SetTexCoord(TCM(0,0,0,1,1,0,1,1))
				T:Show()
			else
				-- If this quadrant is not shown at all, hide it.
				T:Hide()
			end
		end

		-- Hide the chip and slice textures, and de-anchor them (They'll be
		-- re-anchored as necessary later).
		self.chip:Hide()
		self.chip:ClearAllPoints()
		self.slice:Hide()
		self.slice:ClearAllPoints()

		self.chip2:Hide()
		self.chip2:ClearAllPoints()
		self.slice2:Hide()
		self.slice2:ClearAllPoints()

		self.quadExtra:Hide()
		self.quadExtra:ClearAllPoints()

		-- Remember this for next time
		self.lastQuad = quad
	end

	-- Remember the angle for next time
	self.angle = angle
	self.startAngle = startAngle

	-- Get quadrant-specific elements
	local T = self.quadrants[mod(quad-1,4)+1]
	local SS = setSubsetFuncs[effQuad]
	local TM = ringTexCoordMapFuncs[effQuad]
	local STM = sliceTexCoordMapFuncs[effQuad]

	if quad ~= 5 or angle == 360 then
		self.quadExtra:Hide()
	end

	if quad == 1 then
		-- Start and end are in the same quadrant, normal subset of quadrant
		if startA == 0 then
			self.quadExtra:Hide()
			self.chip2:Hide()
			self.slice2:Hide()
		else
			T:Hide();
			self:DoQuadrantPartial(startA, endA, T, SS, TM,
									nil, nil, nil, nil, nil,
									STM)
			return
		end
	end

	-- Quick hit to handle all-visible case
	if angle == 360 then
		endA = 90
	end
	-- Do END of ring
	self:DoQuadrant(endA, T, SS, TM)

	if quad ~= 1 then
		local T = self.quadrants[1]
		if quad == 5 then
			if angle == 360 then
				return
			end
			self.quadExtra:SetTexture(T:GetTexture())
			T = self.quadExtra
		end
		local Qf = mod(quadOfs,4)+1
		local SS = setSubsetFuncs[Qf]
		local TM = ringTexCoordMapFuncs[Qf]
		-- Do START of ring
		self:DoQuadrantReversed(90-startA, T, SS, TM, self.slice2, self.chip2)
	end
end

--------------------------------------------------------------------------
-- Some handy method functions

-- StatsRingRingTemplate:ForceRefresh()
--
-- Clear saved state and refresh the display
--

function donutPrototype:ForceRefresh()
	local savedAngle = self.angle
	self.angle = nil
	self.lastQuad = nil

	if savedAngle then
		self:SetAngle(savedAngle)
	end
end

-- StatsRingRingTemplate:CallTextureMethod(method, ...)
--
-- Invokes the named method on all of the textures in the ring,
-- passing in whatever arguments are given.
--
--  e.g. ring:CallTextureMethod("SetVertexColor", 1.0, 0.5, 0.2, 1.0);

function donutPrototype:CallTextureMethod(method, ...)
	self.quadrants[1][method](self.quadrants[1], ...)
	self.quadrants[2][method](self.quadrants[2], ...)
	self.quadrants[3][method](self.quadrants[3], ...)
	self.quadrants[4][method](self.quadrants[4], ...)
	self.chip[method](self.chip, ...)
	self.slice[method](self.slice, ...)
	if (self.chip2) then
		self.chip2[method](self.chip2, ...)
		self.slice2[method](self.slice2, ...)
		self.quadExtra[method](self.quadExtra, ...)
	end
end


-- StatsRingRingTemplate:SetRingTextures(ringFactor,ringTexFile[,sliceTexFile])
--
-- Sets the textures to use for this ring
--
-- Param:
--   ringFactor   - The ring factor (Inner Radius / Outer Radius)
--   ringTexFile  - The ring texture filename
--   sliceTexFile - The slice texture filename (optional)

function donutPrototype:SetRingTextures(ringFactor, ringTexture, sliceTexture)
	self.ringFactor = ringFactor

	for i=1,4 do
		self.quadrants[i]:SetTexture(ringTexture)
	end
	self.chip:SetTexture(ringTexture)
	if (sliceTexture) then self.slice:SetTexture(sliceTexture) end
	if (self.chip2) then
		self.chip2:SetTexture(ringTexture)
		if (sliceTexture) then self.slice2:SetTexture(sliceTexture) end
		self.quadExtra:SetTexture(ringTexture)
	end
	self:ForceRefresh()
end

-- Method function to set a quadrant offset (CLOCKWISE, regardless of
-- direction of growth)
--
-- Param:
--  offset - The quadrant offset (0-3)
function donutPrototype:SetQuadrantOffset(offset)
	offset = math.floor(offset)
	if offset < 0 then
		offset = mod(-offset, 4)
		offset = mod(4-offset, 4)
	else
		offset = mod(offset, 4)
	end
      
	if self.quadOffset == offset then
		return
	end

	self.quadOffset = offset
	self:ForceRefresh()
end

-- Method function to set whether or not ring growth is reversed.
--
-- Param:
--  isReversed - Whether to reverse or not
function donutPrototype:SetReversed(isReversed)
	if isReversed then
		isReversed = true
	else
		isReversed = nil
	end
	if isReversed == self.reversed then
		return
	end
	self.reversed = isReversed
	self:ForceRefresh()
end


--------------------------------------------------------------------------------
-- Library functions
--

function lib:New(size, ringFactor, tex1, tex2)
	local frame = CreateFrame("Frame", nil, UIParent)
	local donut = setmetatable(frame, donutPrototype_meta)
	donut:SetWidth(size)
	donut:SetHeight(size)
	donut:Hide()
	
	donut.quadrants = {}
	
	for i = 1, 4 do
		donut.quadrants[i] = donut:CreateTexture(nil, "OVERLAY")
	end
	
	donut.chip = donut:CreateTexture(nil, "OVERLAY")
	donut.slice = donut:CreateTexture(nil, "OVERLAY")
	donut.chip2 = donut:CreateTexture(nil, "OVERLAY")
	donut.slice2 = donut:CreateTexture(nil, "OVERLAY")
	donut.quadExtra = donut:CreateTexture(nil, "OVERLAY")
	
	donut.radius = size / 2
	donut.ringFactor = ringFactor
	donut.quadOffset = 0
	
	donut:SetAngle(0)

	donut:SetRingTextures( ringFactor, tex1, tex2)
	
	donut:Hide()
	return donut
end

