local CollectionService = game:GetService("CollectionService")

local Tagger = {}

-- FUNCTIONS --

-- Returns true if the Instance has all of the specified Tags, false if not.
function Tagger.HasTags(tags: {string}, instance: Instance): boolean
	if #tags == 0 then return false end
	
	local instanceTags = instance:GetTags()
	local tagSet = {}
	
	for _, t in ipairs(instanceTags) do 
		tagSet[t] = true 
	end
	
	for _, tag in ipairs(tags) do
		if not tagSet[tag] then return false end
	end
	
	return true
end

-- Returns true if the Instance has at least one of the specified Tags, false if not.
function Tagger.HasAnyTag(tags: {string}, instance: Instance): boolean
	if #tags == 0 then return false end
	
	local instanceTags = instance:GetTags()
	local tagSet = {}
	
	for _, t in ipairs(instanceTags) do
		tagSet[t] = true
	end
	
	for _, tag in ipairs(tags) do
		if tagSet[tag] then return true end
	end
	
	return false
end

-- Checks if an Instance has the specified Tags and no more, no less. Returns true if succeeds, false if not.
function Tagger.HasExactTags(tags: {string}, instance: Instance): boolean
	if #tags == 0 then return false end
	
	local instanceTags = instance:GetTags()
	if #tags ~= #instanceTags then return false end

	local tagSet = {}
	for _, t in ipairs(instanceTags) do
		tagSet[t] = true
	end
	
	for _, tag in ipairs(tags) do
		if not tagSet[tag] then return false end
	end
	
	return true
end

-- Adds an array of Tags to an Instance.
function Tagger.AddTags(tags: {string}, instance: Instance)
	if #tags == 0 then return end
	
	for _, tag in ipairs(tags) do
		instance:AddTag(tag)
	end
end

-- Removes an array of Tags from an Instance.
function Tagger.RemoveTags(tags: {string}, instance: Instance)
	if #tags == 0 then return end
	
	for _, tag in ipairs(tags) do
		instance:RemoveTag(tag)
	end
end

-- Clears all tags from an Instance.
function Tagger.ClearTags(instance: Instance)
	local instanceTags = instance:GetTags()
	for _, tag in ipairs(instanceTags) do
		instance:RemoveTag(tag)
	end
end

-- Returns an array containing all Instances that have all the Tags provided.
function Tagger.GetInstancesWithAllTags(tags: {string}): {Instance}
	if #tags == 0 then return {} end

	local minTag = tags[1]
	local minCount = #CollectionService:GetTagged(minTag)
	for i = 2, #tags do
		local count = #CollectionService:GetTagged(tags[i])
		if count < minCount then
			minTag = tags[i]
			minCount = count
		end
	end

	local results = {}
	for _, inst in ipairs(CollectionService:GetTagged(minTag)) do
		if Tagger.HasTags(tags, inst) then
			table.insert(results, inst)
		end
	end

	return results
end

-- Returns an array containing all Instances that have at least one of the Tags provided.
function Tagger.GetInstancesWithAnyTags(tags: {string}): {Instance}
	if #tags == 0 then return {} end
	
	local results = {}
	local seen = {}
	
	for _, tag in ipairs(tags) do
		for _, inst in ipairs(CollectionService:GetTagged(tag)) do
			if not seen[inst] and Tagger.HasAnyTag(tags, inst) then
				seen[inst] = true
				table.insert(results, inst)
			end
		end
	end
	
	return results
end

-- Returns an array containing all Instances that have the EXACT MATCH of the Tags provided.
function Tagger.GetInstancesWithExactTags(tags: {string}): {Instance}
	if #tags == 0 then return {} end
	
	local results = {}
	local seen = {}
	
	for _, tag in ipairs(tags) do
		for _, inst in ipairs(CollectionService:GetTagged(tag)) do
			if not seen[inst] and Tagger.HasExactTags(tags, inst) then
				seen[inst] = true
				table.insert(results, inst)
			end
		end
	end
	
	return results
end

-- DEBUG / QOL --

function Tagger.PrintTags(inst: Instance)
	for _, tag in ipairs(inst:GetTags()) do
		print(tag)
	end
end

function Tagger.IsNotTagged(inst: Instance): boolean
	return #inst:GetTags() == 0
end

-- WRAPPERS FOR THE COLLECTION SERVICE --
-- Made this just so you don't need to have both Tagger and CollectionService required in your script

-- Returns an array of all tags applied to a given instance.
function Tagger.GetTags(instance: Instance): {any}
	return CollectionService:GetTags(instance)
end

-- Returns an array of instances in the game with the given tag.
function Tagger.GetTagged(tag: string): {Instance}
	return CollectionService:GetTagged(tag)
end

-- Check whether an instance has a given tag.
function Tagger.HasTag(instance: Instance, tag: string): boolean
	return CollectionService:HasTag(instance, tag)
end

-- Applies a tag to an Instance.
function Tagger.AddTag(instance: Instance, tag: string)
	CollectionService:AddTag(instance, tag)	
end

-- Removes a tag from an instance.
function Tagger.RemoveTag(instance: Instance, tag: string)
	CollectionService:RemoveTag(instance, tag)
end

-- Returns an array of all tags in the experience.
function Tagger.GetAllTags(): {any}
	return CollectionService:GetAllTags()
end

return Tagger
