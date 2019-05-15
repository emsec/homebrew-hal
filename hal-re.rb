class HalRe < Formula
  desc "HAL - The Hardware Analyzer"
  homepage "https://github.com/emsec/hal"
  url "https://github.com/emsec/hal.git",
      :tag      => "v1.0.13",
      :revision => "c951ac1381f9008613d43790b4339aff3bef7315"
  head "https://github.com/emsec/hal.git"
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "boost"
  depends_on "libomp"
  depends_on "python"
  depends_on "qt"

  def install
    llvm = Formula["llvm"]
    ENV["CPPFLAGS"]="-I#{llvm.include}"
    ENV["LDFLAGS"]="-L#{llvm.lib} -Wl,-rpath,#{llvm.lib}"
    args = [
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
