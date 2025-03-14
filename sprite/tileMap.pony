use "fileExt"
use "stringExt"
use "flow"
use "png"
use "json"
use "bitmap"


class TileMap

	var bitmap:Bitmap val
	let tileWidth:USize
	let tileHeight:USize
	
	fun _tag():USize => 117
	
	new create(imgPath:String, tileWidth':USize, tileHeight':USize) =>
		
		tileWidth = tileWidth'
		tileHeight = tileHeight'
		
		bitmap = recover val Bitmap(1,1) end
		try
			if StringExt.endswith(imgPath, ".png") then
				bitmap = recover val PNGReader.read(imgPath)? end
			end
		end
	
	fun blitInto(destination:Bitmap ref, x:I64, y:I64, tileID:USize) =>
		let tx = (tileID * tileWidth) % bitmap.width
		let ty = ((tileID * tileWidth) / bitmap.width) * tileHeight		
		destination.blitPart(x, y, bitmap, tx.i64(), ty.i64(), tileWidth, tileHeight)
