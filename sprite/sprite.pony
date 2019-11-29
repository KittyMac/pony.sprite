use "fileExt"
use "stringExt"
use "flow"
use "png"
use "json"
use "bitmap"
use "collections"

class Face
	let x:I64
	let y:I64
	let w:USize
	let h:USize
	let bitmapIdx:USize
	
	new create(bitmapIdx':USize, x':I64, y':I64, w':USize, h':USize) =>
		bitmapIdx = bitmapIdx'
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
			destination.blitPart(x, y, bitmap, face.x, face.y, face.w, face.h)
		end
	
	fun blitOver(destination:Bitmap ref, x:I64, y:I64, faceIdx:USize) =>
		try
			let face = faces(faceIdx)?
			let bitmap = bitmaps(face.bitmapIdx)?
			destination.blitPartOver(x, y, bitmap, face.x, face.y, face.w, face.h)
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
				
				faces.push(Face(bitmapIdx, frame_x, frame_y, frame_w.usize(), frame_h.usize()))
				
				/*
if (sprite.trimmed) {
            cx = sprite.spriteSourceSize.x - (sprite.sourceSize.w * 0.5);
            cy = sprite.spriteSourceSize.y - (sprite.sourceSize.h * 0.5);
}
				*/
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
	
	
