use "fileExt"
use "stringExt"
use "flow"
use "png"
use "json"
use "bitmap"
use "collections"

class Face
	let anchorX:I64
	let anchorY:I64
	
	let x:I64
	let y:I64
	let w:USize
	let h:USize
	let bitmapIdx:USize
	
	new create(bitmapIdx':USize, anchorX':I64, anchorY':I64, x':I64, y':I64, w':USize, h':USize) =>
		bitmapIdx = bitmapIdx'
		anchorX = anchorX'
		anchorY = anchorY'
		x = x'
		y = y'
		w = w'
		h = h'
		

class Sprite

	let bitmaps:Array[Bitmap]
	let faces:Array[Face]

	new create() =>
		bitmaps = Array[Bitmap](6)
		faces = Array[Face](256)
	
	fun ref addSheet(imagePath:String, jsonPath:String) =>
		try
			let bitmap:Bitmap val = _loadImageFromPath(imagePath)?
			_loadJSON(bitmaps.size(), jsonPath)?
			
			bitmaps.push(bitmap)
		end
	
	fun blitInto(destination:Bitmap ref, x:I64, y:I64, faceIdx:USize) =>
		try
			let face = faces(faceIdx)?
			let bitmap = bitmaps(face.bitmapIdx)?
			destination.blitPart(x + face.anchorX, y + face.anchorY, bitmap, face.x, face.y, face.w, face.h)
		end
	
	fun blitOver(destination:Bitmap ref, x:I64, y:I64, faceIdx:USize) =>
		try
			let face = faces(faceIdx)?
			let bitmap = bitmaps(face.bitmapIdx)?
			destination.blitPartOver(x + face.anchorX, y + face.anchorY, bitmap, face.x, face.y, face.w, face.h)
		end

		
	fun _loadImageFromPath(imgPath:String):Bitmap val ? =>
		try
			if StringExt.endswith(imgPath, ".png") then
				return PNGReader.read(imgPath)?
			end
		end
		error
	
	fun ref _loadJSON(bitmapIdx:USize, jsonPath:String)? =>		
		let jsonString = recover val FileExt.fileToString(jsonPath)? end
		
	    let doc: JsonDoc = JsonDoc
	    doc.parse(jsonString)?

	    let root = doc.data as JsonObject
		
		try
			let metaContainer = root.data("meta")? as JsonObject
						
			let frames = root.data("frames")? as JsonArray			
			for i in Range[USize](0, frames.data.size()) do
				let frameObj = frames.data(i)? as JsonObject
				
				let trimmed = frameObj.data("trimmed")? as Bool
				
				let frameRect = frameObj.data("frame")? as JsonObject
				let frame_x = frameRect.data("x")? as I64
				let frame_y = frameRect.data("y")? as I64
				let frame_w = frameRect.data("w")? as I64
				let frame_h = frameRect.data("h")? as I64
								
				var anchor_x:I64 = 0
				var anchor_y:I64 = 0
				
				if trimmed then
					let sourceSizeRect = frameObj.data("sourceSize")? as JsonObject
					let spriteSourceSizeRect = frameObj.data("spriteSourceSize")? as JsonObject
					
					let source_size_w = sourceSizeRect.data("w")? as I64
					let source_size_h = sourceSizeRect.data("h")? as I64
					
					let sprite_source_size_x = spriteSourceSizeRect.data("x")? as I64
					let sprite_source_size_y = spriteSourceSizeRect.data("y")? as I64
					
					anchor_x = sprite_source_size_x - (source_size_w / 2)
					anchor_y = sprite_source_size_y - (source_size_h / 2)
				end
				
				faces.push(Face(bitmapIdx, anchor_x, anchor_y, frame_x, frame_y, frame_w.usize(), frame_h.usize()))
				
			end
				/*
{
	"filename": "Down Bow Character 1 03",
	"frame": {"x":245,"y":4,"w":120,"h":204},
	"rotated": false,
	"trimmed": true,
	"spriteSourceSize": {"x":198,"y":118,"w":120,"h":204},
	"sourceSize": {"w":512,"h":512}
}
				*/
						
		else
			@fprintf[I32](@pony_os_stdout[Pointer[U8]](), ("error loading the JSON\n").cstring())
		end
	
	
