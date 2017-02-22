MultiLine = gideros.class(Sprite)

function MultiLine:init(text, width, font, align, textColor)

	if not align then align = "left" end
	if not font then font = nil end
	if not textColor then textColor = 0xFFFFFF end
	
	self.textColor = textColor
	self.text = text
	self.align = align
	self.width = width
	self.font = font
	self.lineHeight = self.font:getLineHeight();
	
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
		
		if rn then j = j + 1; end
	end
	
	self:setAlign(self.align);
end

function MultiLine:setTextColor(textColor)

	self.textColor = textColor
	
	for k,field in pairs(self.fields) do
		field:setTextColor(self.textColor);
	end

end

function MultiLine:setAlign(align)

	self.align = align
	
	if self.align == "left" then
		for k,field in pairs(self.fields) do
			field:setX(0);
		end
	end
	
	if self.align == "center" then
		for k,field in pairs(self.fields) do
			field:setX((self.width - field:getWidth()) / 2);
		end
	end
	
	if self.align == "right" then
		for k,field in pairs(self.fields) do
			field:setX(self.width - field:getWidth());
		end
	end

end
