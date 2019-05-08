class HalRe < Formula
  desc "HAL – The Hardware Analyzer"
  homepage "https://github.com/emsec/hal"
  url "https://github.com/emsec/hal.git",
      :tag      => "v1.0.11.1",
      :revision => "96140b6a0ce2b11c64054fbf4e6a09634944e1cb"
  head "https://github.com/emsec/hal.git"
  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconfig" => :build
  depends_on "rapidjson" => :build
  depends_on "ninja" => :build
  depends_on "qt"
  depends_on "boost"
  depends_on "python"
  version "1.0.11.1"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    # Remove unrecognized options if warned by configure
    args =  %W[
      -DBUILD_ALL_PLUGINS=ON
      -DBUILD_TESTS=OFF
      -DWITH_GUI=ON
      -DBUILD_DOCUMENTATION=OFF
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
      -DBOOST_ROOT=#{Formula["boost"].opt_prefix}
    ] + std_cmake_args
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "-j#{ENV.make_jobs}"
    end

  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hal --version")
  end
end