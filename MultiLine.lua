MultiLine = gideros.class(Sprite)

function MultiLine:init(text, width, font, align, textColor)
	--argument check
	if not align then align = "left" end
	--if not linespace then linespace = 2 end
	if not font then font = nil end
	if not textColor then textColor = 0xFFFFFF end
	
	--internal settings
	self.textColor = textColor
	--self.letterSpacing = 0.6
	self.text = text
	self.align = align
	self.width = width
	self.lineSpacing = 0
	self.font = font
	self.lineHeight = self.font:getLineHeight();
	self.wordSpace = 5; --self.lineHeight / 3
	
	self:setText(text)	
end

function MultiLine:createLine(value, j)
	
	self.fields[j] = TextField.new(self.font, value)
	self.fields[j]:setTextColor(self.textColor)
	if j > 1 then
		self.fields[j]:setY(self.lineHeight * (j - 1));
	end
	self:addChild(self.fields[j]);
end

function MultiLine:setText(text)
	
	self.text = text
	self.lines = {};
	self.fields = {};
	local i = 1;
	local j = 1;
	local tmpText = nil;
	local rn = false;
	
	self.text = self.text:gsub("\n", "|n| ");
	
	for line in string.gmatch(self.text, "%S+") do
	  self.lines[i] = line;
	  i = i + 1;
	end
		
	for k,value in pairs(self.lines) do
	
		rn = (string.find(value, "|n|") ~= nil);
		value = value:gsub("|n|", "");
	
		if self.fields[j] == nil then
			self:createLine(value, j)
		else
			tmpText = self.fields[j]:getText();
			self.fields[j]:setText(tmpText.." "..value);
			
			if self.fields[j]:getWidth() > self.width then
				self.fields[j]:setText(tmpText);
				j = j + 1;
				self:createLine(value, j);
			end
		end
		
		if rn then
			j = j + 1;
		end
	end
end
