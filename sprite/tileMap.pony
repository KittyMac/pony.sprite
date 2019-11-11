use "fileExt"
use "stringExt"
use "flow"
use "png"
use "json"


class TileMap

	var bitmap:Bitmap ref
	let tileWidth:USize
	let tileHeight:USize
	
	new create(imgPath:String, tileWidth':USize, tileHeight':USize) =>
		
		tileWidth = tileWidth'
		tileHeight = tileHeight'
		
		bitmap = Bitmap(1,1)
		try
			if StringExt.endswith(imgPath, ".png") then
				bitmap = PNGReader.read(imgPath)?
			end
		end
	
	fun blitInto(destination:Bitmap ref, x:USize, y:USize, tileID:USize) =>
		let tx = (tileID * tileWidth) % bitmap.width
		let ty = (tileID * tileWidth) / bitmap.width
		destination.blitPart(x, y, bitmap, tx, ty, tileWidth, tileHeight)
