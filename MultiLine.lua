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
	
	local i = 1;
	local j = 1;
	local tmpText = nil;
	local rn = false;
	local sn = "|n|";
	
	if self.fields ~= nil then 
		for k,field in pairs(self.fields) do
			self:removeChild(field);
		end
	end
	
	self.fields = {};
	
	tmpText = self.text:gsub("\n", sn.." ");
	
	for line in string.gmatch(tmpText, "%S+") do
	  self.lines[i] = line;
	  i = i + 1;
	end
		
	for k,value in pairs(self.lines) do
	
		rn = (string.find(value, sn) ~= nil);
		value = value:gsub(sn, "");
	
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
	
	local tmpText = nil;
	
	if self.align == "left" or self.align == "center" or self.align == "right" then
		for k,field in pairs(self.fields) do
			tmpText = field:getText();
			tmpText = tmpText:gsub("%s+", " ");
			field:setText(tmpText);
		end
	end
	
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
	
	if self.align == "justify" then
		for k,field in pairs(self.fields) do
			field:setX(0);
			tmpText = field:getText();
			local f = 1;
			local startText = tmpText;
			while(field:getWidth() < self.width) do
				tmpText = tmpText:gsub("%s+", string.rep(" ", f));
				field:setText(tmpText);
				f = f + 1;
				if f > 10 then
					field:setText(startText);
					break;
				end
			end
		end
	end

end

function MultiLine:setFont(font, lineHeight)

	self.font = font;

	if not lineHeight then 
		self.lineHeight = self.font:getLineHeight();
	else
		self.lineHeight = lineHeight;
	end
		
	self:setText(self.text);
end

function MultiLine:setFontSize(fontSize, lineHeight)

	local fontName = self.font:getFontname();

	self.font = TTFont.new(fontName, fontSize, false);

	if not lineHeight then 
		self.lineHeight = self.font:getLineHeight();
	else
		self.lineHeight = lineHeight;
	end
		
	self:setText(self.text);

end

function MultiLine:setLineHeight(lineHeight)
	self.lineHeight = lineHeight
	self:setText(self.text)
end

function MultiLine:setWidth(width)
	self.width = width
	self:setText(self.text)
end
