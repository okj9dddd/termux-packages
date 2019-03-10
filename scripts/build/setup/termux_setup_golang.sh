# Utility function for golang-using packages to setup a go toolchain.
termux_setup_golang() {
	export GOOS=android
	export CGO_ENABLED=1
	export GO_LDFLAGS="-extldflags=-pie"
	export CGO_LDFLAGS="$LDFLAGS"
	if [ "$TERMUX_ARCH" = "arm" ]; then
		export GOARCH=arm
		export GOARM=7
	elif [ "$TERMUX_ARCH" = "i686" ]; then
		export GOARCH=386
		export GO386=sse2
	elif [ "$TERMUX_ARCH" = "aarch64" ]; then
		export GOARCH=arm64
	elif [ "$TERMUX_ARCH" = "x86_64" ]; then
		export GOARCH=amd64
	else
		termux_error_exit "Unsupported arch: $TERMUX_ARCH"
	fi

	local TERMUX_GO_VERSION=go1.12
	local TERMUX_GO_PLATFORM=linux-amd64

	local TERMUX_BUILDGO_FOLDER=$TERMUX_COMMON_CACHEDIR/${TERMUX_GO_VERSION}
	export GOROOT=$TERMUX_BUILDGO_FOLDER
	export PATH=$GOROOT/bin:$PATH

	if [ -d "$TERMUX_BUILDGO_FOLDER" ]; then return; fi

	local TERMUX_BUILDGO_TAR=$TERMUX_COMMON_CACHEDIR/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz
	rm -Rf "$TERMUX_COMMON_CACHEDIR/go" "$TERMUX_BUILDGO_FOLDER"
	termux_download https://storage.googleapis.com/golang/${TERMUX_GO_VERSION}.${TERMUX_GO_PLATFORM}.tar.gz \
		"$TERMUX_BUILDGO_TAR" \
		750a07fef8579ae4839458701f4df690e0b20b8bcce33b437e4df89c451b6f13

	( cd "$TERMUX_COMMON_CACHEDIR"; tar xf "$TERMUX_BUILDGO_TAR"; mv go "$TERMUX_BUILDGO_FOLDER"; rm "$TERMUX_BUILDGO_TAR" )
}