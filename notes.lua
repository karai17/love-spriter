--[[
http://www.brashmonkey.com/forum/viewtopic.php?f=3&t=15575

Basically each <mainline><key> has information about the bones and zorder. They are listed in an order that doesn't require you to do more than one pass in the hierarchy. 

Bones are the only parents anything can have. The 'parent' refers the bone_ref id, correct. If you copy the position values for the bone_refs in order, then 'parent' will also refer to the array index:
bone_refs[parent] would be where it'd get the parent value from.

Bone's don't have any point of rotation, just x,y,angle,scale, and that's all the information you need for animating. If you actually want to draw the bones themselves for a debug mode, or something, their pivot would be 0,0, and their length would be their scale * the bone length information at the beginning of the scml in the <obj_info> structures


Spriter saves so Y increases as you go up, and many engines are the opposite. It also uses angles that increase clockwise, and pivot coordinates with 0,0 at the bottom left. Some engines and api's use these same coordinate systems and some don't. So if your engine is the opposite it will need one or more of these changes. This information will be included in the upcoming documentation.

--]]



{
	--One entity in file, treat as singleton
	entity: [
		--Array of named animations
		"animation": [
			"id": 0,
			--Milliseconds?
			"length": 4000,
			--Actual name of animation
			"name": "idle",
			"soundline": [],
			--Mainline is z orders and relationships
			"mainline": {
				--Each key potentially has multiple bone_refs and object_refs 
				"key": [
					{
						"bone_ref": [
							{
								"id": 0,
								--These below indices together reference a unique "key" in the timeline
								--So, to "dig" into the data structure to find it we go:
								--foo.animation[i].timeline[timelineID].key[keyID]
								"timeline": 15
								"key": 5,
							},
							{
								"id": 1,
								"key": 0,
								"parent": 0,
								"timeline": 16
							},
							--...
						]
						"id": 0,
						"object_ref": [
							{
								"id": 0,
								"key": 0,
								--Index into bone_ref above
								"parent": 6,
								"timeline": 2,
								"z_index": "0"
							},
							{
								"id": 1,
								"key": 0,
								"parent": 7,
								"timeline": 3,
								"z_index": "1"
							},
							--...
						]
					}
				] --key(s)
			},
			"timeline": [
				{
					"id": 0,
					"key": [
						{
							"id": 0,
							"object": {
								"angle": 180.740013,
								"file": 0,
								"folder": 0,
								"scale_x": 4.080783,
								"x": -20.399667,
								"y": 0.10202
							},
							"spin": 0
						}
					] --key(s)

				}
			] --timeline(s)

		], --animation(s)
		"character_map": [],
		"id": 0,
		"name": "Player",
		"obj_info": [
			--Lots
		]
	]
	folder: [
		--files
	],
	"generator": "BrashMonkey Spriter",
	"generator_version": "b8",
	"scon_version": "1.0"
}


