class Hal < Formula
  desc "HAL - The Hardware Analyzer"
  homepage "https://github.com/emsec/hal"
  url "https://github.com/emsec/hal.git",
      :tag      => "v1.1.8",
      :revision => "92490465df8ab5ff6ed04937a9fa016d8e8979ce"
  head "https://github.com/emsec/hal.git"

  bottle do
    root_url "https://dl.bintray.com/emsec/bottles-hal/"
    rebuild 1
    sha256 "a9f4cafb72c20ee0116a49e642295e32a3fb06cc3d9aebae9e7826ed1cbc89f2" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "boost"
  depends_on "igraph"
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
