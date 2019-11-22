all: copy-libs
	stable env /Volumes/Development/Development/pony/ponyc/build/release/ponyc -p ./lib -o ./build/ ./sprite
	./build/sprite

copy-libs:
	@cp ../pony.bitmap/lib/*.a ./lib/
