class Hal < Formula
  desc "HAL - The Hardware Analyzer"
  homepage "https://github.com/emsec/hal"
  url "https://github.com/emsec/hal.git",
      :tag      => "v1.0.14",
      :revision => "2cfb7dc1e93b003b1c4f72a68ee7744feab345db"
  head "https://github.com/emsec/hal.git"

  bottle do
    root_url "https://dl.bintray.com/emsec/bottles-hal"
    rebuild 4
    sha256 "00313f6312e7066b4e360a049a38f466debea6349e315fd7c0417c7f11ffe21c" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "boost"
  depends_on "libomp"
  depends_on "llvm"
  depends_on "python"
  depends_on "qt"

  def install
    llvm = Formula["llvm"]
    ENV["CPPFLAGS"]="-I#{llvm.include}"
    ENV["LDFLAGS"]="-L#{llvm.lib} -Wl,-rpath,#{llvm.lib}"
    args = [
      "-DCMAKE_BUILD_TYPE=RelWithDebInfo",
      "-DBUILD_ALL_PLUGINS=ON",
      "-DBUILD_TESTS=OFF",
      "-DWITH_GUI=ON",
      "-DBUILD_DOCUMENTATION=OFF",
      "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
      "-DBOOST_ROOT=#{Formula["boost"].opt_prefix}",
      "-DCMAKE_CXX_COMPILER=#{llvm.bin}/clang++",
      "-DCMAKE_C_COMPILER=#{llvm.bin}/clang",
    ]
    mkdir "build" do
      system "cmake", *args, *std_cmake_args, ".."
      system "make", "install", "-j#{ENV.make_jobs}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hal --version")
  end
end