all: copy-libs
	corral run -- ponyc -p ./lib -o ./build/ ./sprite
	./build/sprite

test: copy-libs
	corral run -- ponyc -V=0 -p ./lib -o ./build/ ./sprite
	./build/sprite

copy-libs:
	@cp ../pony.bitmap/lib/*.a ./lib/



corral-fetch:
	@corral clean -q
	@corral fetch -q

corral-local:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add /Volumes/Development/Development/pony/pony.fileExt -q
	@corral add /Volumes/Development/Development/pony/pony.flow -q
	@corral add /Volumes/Development/Development/pony/pony.jpg -q
	@corral add /Volumes/Development/Development/pony/pony.png -q
	@corral add /Volumes/Development/Development/pony/pony.stringExt -q
	@corral add /Volumes/Development/Development/pony/pony.bitmap -q

corral-git:
	-@rm corral.json
	-@rm lock.json
	@corral init -q
	@corral add github.com/KittyMac/pony.fileExt.git -q
	@corral add github.com/KittyMac/pony.flow.git -q
	@corral add github.com/KittyMac/pony.jpg.git -q
	@corral add github.com/KittyMac/pony.png.git -q
	@corral add github.com/KittyMac/pony.stringExt.git -q
	@corral add github.com/KittyMac/pony.bitmap.git -q

ci: corral-git corral-fetch all
	
dev: corral-local corral-fetch all

