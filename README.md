# Renewed-Mining

Welcome to Renewed Mining, a free QBCore resource utilizing the [K4MB1](https://www.k4mb1maps.com/package/4881018) mining MLO.

The resource includes, a server sided spawning of ores that syncs across all players that join or leave the mine.

The resource also include a way to break down the ores into materials that can be used on your server(s).

Resource also contains a good amount of protection to make sure no modders will destroy your server by bypassing the events to get free items.

This is a completely **FREE** resource, if you want to support me for the work I've put in you can buy me a coffee.

- [Ko-Fi](https://ko-fi.com/FjamZoo)
- Join my [Discord](https://discord.gg/AS2Y8TWejt) for additional support.

## Preview

- [Mining](https://streamable.com/0jyzc0)
- [Smelting Ores](https://streamable.com/vum6q1)

## Installation

- Download the latest version of Renewed-Mining from GitHub
- Drop the resource into your Server folder.
- Ensure the resource
- Drop the images into your inventory resource (example qb-inventory/html/images)
- Add the following items to your qb-core/shared/items.lua

```lua
	-- Renewed Mining --
	['iron_ore'] 			     	 = {['name'] = 'iron_ore', 						['label'] = 'Iron Ore', 				['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'iron_ore.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Iron Ore...'},
	['copper_ore'] 			     	 = {['name'] = 'copper_ore', 					['label'] = 'Copper Ore', 				['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'copper_ore.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Copper Ore...'},
	['gold_ore'] 			     	 = {['name'] = 'gold_ore', 						['label'] = 'Gold Ore', 				['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'gold_ore.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Gold Ore...'},
	['tin_ore'] 			     	 = {['name'] = 'tin_ore', 						['label'] = 'Tin Ore', 					['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'iron_ore.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Tin Ore...'},
	['crystal_red'] 			     = {['name'] = 'crystal_red', 					['label'] = 'Red Crystal Ore', 			['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'crystal_red.png', 		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Red Crystal Ore...'},
	['crystal_green'] 			     = {['name'] = 'crystal_green', 				['label'] = 'Green Crystal Ore', 		['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'crystal_green.png', 	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Green Crystal Ore...'},
	['crystal_blue'] 			     = {['name'] = 'crystal_blue', 					['label'] = 'Blue Crystal Ore', 		['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'crystal_blue.png', 	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Blue Crystal Ore...'},


	['gold_nugget'] 			     = {['name'] = 'gold_nugget', 					['label'] = 'Golden Nugget', 			['weight'] = 500, 		['type'] = 'item', 		['image'] = 'golden_nugget.png', 	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Golden Nugget...'},
	['tin'] 			     		 = {['name'] = 'tin', 							['label'] = 'Tin Bar', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'tin.png', 				['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'A Tin Bar...'},
	['pickaxe'] 			     	 = {['name'] = 'pickaxe', 						['label'] = 'Pickaxe', 					['weight'] = 1500, 		['type'] = 'item', 		['image'] = 'pickaxe.png', 			['unique'] = false, 	['useable'] = false, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'Just a pickaxe used for mining...'},
```

### Other resources used in the previews

- [qb-menu](https://github.com/Renewed-Scripts/qb-menu)
- [qb-target](https://github.com/Renewed-Scripts/qb-target)
- [Tebex](https://renewed.tebex.io/)
