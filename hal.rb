class Hal < Formula
  desc "HAL - The Hardware Analyzer"
  homepage "https://github.com/emsec/hal"
  url "https://github.com/emsec/hal.git",
      :tag      => "v2.0.0",
      :revision => "4dc56cbd04ca864e670845c5cede6fb70643ab29"
  head "https://github.com/emsec/hal.git"

  bottle do
    root_url "https://dl.bintray.com/emsec/bottles-hal/"
    sha256 "a91d41cfd0afbe4d191a783a39a1dee59355e8b569e51a96401c304e9e596fa6" => :mojave
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
