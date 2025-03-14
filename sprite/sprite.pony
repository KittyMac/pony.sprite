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
	
	new createWithSheet(imagePath:String, jsonPath:String, scale:F64 = 1.0)? =>
		bitmaps = Array[Bitmap](6)
		faces = Array[Face](256)
		
		let bitmap:Bitmap val = _loadImageFromPath(imagePath)?
		_loadJSON(bitmaps.size(), jsonPath, scale)?
		bitmaps.push(bitmap)
	
	fun ref addSheet(imagePath:String, jsonPath:String, scale:F64 = 1.0)? =>
		let bitmap:Bitmap val = _loadImageFromPath(imagePath)?
		_loadJSON(bitmaps.size(), jsonPath, scale)?
		
		bitmaps.push(bitmap)
	
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
	
	fun size(faceIdx:USize):(USize,USize) =>
		try
			let face = faces(faceIdx)?
			return (face.w, face.h)
		end
		(1,1)
	
	fun rect(x:I64, y:I64, faceIdx:USize):(I64,I64,I64,I64) =>
		try
			let face = faces(faceIdx)?
			return (x + face.anchorX, y + face.anchorY, face.w.i64(), face.h.i64())
		end
		(1,1,1,1)
		
	fun _loadImageFromPath(imgPath:String):Bitmap val ? =>
		try
			if StringExt.endswith(imgPath, ".png") then
				return PNGReader.read(imgPath)?
			end
		end
		error
	
	fun ref _loadJSON(bitmapIdx:USize, jsonPath:String, scale:F64)? =>		
		let jsonString = recover val FileExt.fileToString(jsonPath)? end
		
	    let doc: JsonDoc = JsonDoc
	    doc.parse(jsonString)?

	    let root = doc.data as JsonObject
					
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
				
				anchor_x = sprite_source_size_x - ((source_size_w.f64() / 2.0).round()).i64()
				anchor_y = sprite_source_size_y - ((source_size_h.f64() / 2.0).round()).i64()
			end
			
			faces.push(Face(bitmapIdx, 
				(anchor_x.f64() * scale).i64(), 
				(anchor_y.f64() * scale).i64(), 
				(frame_x.f64() * scale).i64(), 
				(frame_y.f64() * scale).i64(), 
				(frame_w.f64() * scale).usize(), 
				(frame_h.f64() * scale).usize()))
			
		end

	
	
