class WarpX < Formula
  desc "An advanced, time-based electromagnetic & electrostatic Particle-In-Cell code"
  homepage "https://ecp-warpx.github.io/"
  url "https://github.com/ECP-WarpX/WarpX/archive/refs/tags/23.11.tar.gz"
  sha256 "80ae4f01b22b019aab5edba7af0b4ce77999ed0e77a0e69d6d9e408ec131e14e"
  head "https://github.com/ECP-WarpX/WarpX.git", :branch => "development"

  depends_on "cmake" => :build
  depends_on "adios2"
  depends_on "boost"
  depends_on "hdf5-mpi"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  #depends_on "openpmd-api"  # tap openpmd/openpmd
  depends_on "pybind11"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    args = std_cmake_args + %W[
      -DWarpX_APP=ON
      -DWarpX_DIMS="1;2;RZ;3"
      -DWarpX_EB=OFF
      -DWarpX_pybind11_internal=OFF
      -DWarpX_MPI=ON
      -DWarpX_OPENPMD=ON
      -DWarpX_PSATD=ON
      -DPython_EXECUTABLE=#{which(python3)}
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    #(pkgshare/"examples").install "examples/5_write_parallel.cpp"
    #(pkgshare/"examples").install "examples/5_write_parallel.py"

    # environment setups
    # TODO: PYTHONPATH?
    # bin.env_script_all_files("#{libexec}/lib/pkgconfig", :PKG_CONFIG_PATH => ENV["PKG_CONFIG_PATH"])
  end

#  test do
#    system "mpic++", "-std=c++17",
#           (pkgshare/"examples/5_write_parallel.cpp"),
#           "-I#{opt_include}",
#           "-lopenPMD"
#    system "mpiexec",
#           "-n", "2",
#           "./a.out"
#    assert_predicate testpath/"../samples/5_parallel_write.h5", :exist?
#
#    system "#{Formula["python"].opt_bin}/python3",
#           "-c", "import openpmd_api"
#
#    system "mpiexec",
#           "-n", "2",
#           "#{Formula["python"].opt_bin}/python3",
#           "-m", "mpi4py",
#           (pkgshare/"examples/5_write_parallel.py")
#    assert_predicate testpath/"../samples/5_parallel_write_py.h5", :exist?
#  end
end

