use "fileExt"
use "stringExt"
use "flow"
use "png"
use "json"

// Note: To keep things simple, I've removed the pony.jpg support from pony.sprite. The reasoning being pony.jpg relies on a
// shim library in order to function, which means extra hassle for sprite.pony users.  sprite.pony uses pony.png, which doesn't
// need any external shims it just needs to be able to link to libpng and the rest is FFI magic. Since 99.99% of the times
// you will want transparency for your sprites, this seemed like a reasonable trade off.

/*
actor Sprite

	var bitmap:Bitmap ref

	new create(imgPath:String, infoPath:String) =>
		bitmap = Bitmap(1,1)
		
		try
			bitmap = _loadAnyImageFromPath(imgPath)?
			_loadInfoJSON(infoPath)?
		end
	
	new createTiled(imgPath:String, tileWidth:USize, tileHeight:USize) =>
		bitmap = Bitmap(1,1)
	
		try
			bitmap = _loadAnyImageFromPath(imgPath)?
			_loadInfoJSON(infoPath)?
		end
		
		
	fun _loadAnyImageFromPath(imgPath:String):Bitmap ref ? =>
		try
			//if StringExt.endswith(imgPath, ".jpg") or StringExt.endswith(imgPath, ".jpeg") then
			//	return JPGReader.read(imgPath)?
			//end
			if StringExt.endswith(imgPath, ".png") then
				return PNGReader.read(imgPath)?
			end
		end
		error
	
	fun _loadInfoJSON(infoPath:String)? =>
		let jsonString = recover val FileExt.fileToString(infoPath)? end
		
	    let doc: JsonDoc = JsonDoc
	    doc.parse(jsonString)?

	    let root = doc.data as JsonObject
		
		// Is this a TexturePacker format?
		try
			let tiledversion = root.data("tiledversion")? as String
			
			// if so, we're only interested in extracting:
			// 1. tilesets
			
			let nextobjectid = root.data("nextobjectid")? as I64
			let width = root.data("width")? as I64
			let height = root.data("height")? as I64
			let version = root.data("version")? as I64
			let tiletype = root.data("type")? as String

		
			let tilewidth = root.data("tilewidth")? as I64
			let tileheight = root.data("tileheight")? as I64
			let renderorder = root.data("renderorder")? as String
			let orientation = root.data("orientation")? as String
			
		end
	
	

*/