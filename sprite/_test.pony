use "fileExt"
use "ponytest"
use "files"
use "flow"
use "png"
use "bitmap"


actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
		test(_TestTileMap)
		test(_TestSprite)


class iso _TestSprite is UnitTest
	fun name(): String => "read png"

	fun apply(h: TestHelper) =>
	
		let buffer = Bitmap(512,512)
		buffer.clear(RGBA.black())
	
		let sprite = Sprite
		try
			sprite.addSheet("sheet/sheet.png", "sheet/sheet.json")?
			sprite.blitOver(buffer, 256, 256, 0)
		
			PNGWriter.write("/tmp/sprite_sample.png", buffer)?
		end


class iso _TestTileMap is UnitTest
	fun name(): String => "read png"

	fun apply(h: TestHelper) =>
		// Load a sprite and render a couple of faces into the buffer
		let buffer = Bitmap(512,512)
				
		let t = TileMap("grassland.png", 64, 64)
		
		t.blitInto(buffer, 0, 0, 0)
		t.blitInto(buffer, 64, 0, 1)
		t.blitInto(buffer, 128, 0, 2)
		t.blitInto(buffer, 192, 0, 3)
		t.blitInto(buffer, 256, 0, 4)
		
		try
			PNGWriter.write("/tmp/tilemap_sample.png", buffer)?
		end
		
		
	
