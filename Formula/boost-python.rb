class BoostPython < Formula
  desc "C++ library for C++/Python2 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.69.0/source/boost_1_69_0.tar.bz2"
  sha256 "8f32d4617390d1c2d16f26a27ab60d97807b35440d45891fa340fc2648b04406"
  head "https://github.com/boostorg/boost.git"

  depends_on "boost"

  needs :cxx14

  def install
    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged-1.66",
            "threading=multi,single",
            "link=shared,static"]

    # Boost is using "clang++ -x c" to select C compiler which breaks C++14
    # handling using ENV.cxx14. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++14"
    if ENV.compiler == :clang
      args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
    end

    pyver = Language::Python.major_minor_version "python"

    system "./bootstrap.sh", "--prefix=#{prefix}", "--libdir=#{lib}",
                             "--with-libraries=python", "--with-python=python"

    system "./b2", "--build-dir=build-python", "--stagedir=stage-python",
                   "python=#{pyver}", *args

    lib.install Dir["stage-python/lib/*py*"]
    doc.install Dir["libs/python/doc/*"]
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <boost/python.hpp>
      char const* greet() {
        return "Hello, world!";
      }
      BOOST_PYTHON_MODULE(hello)
      {
        boost::python::def("greet", greet);
      }
    EOS

    pyincludes = Utils.popen_read("python-config --includes").chomp.split(" ")
    pylib = Utils.popen_read("python-config --ldflags").chomp.split(" ")

    system ENV.cxx, "-shared", "hello.cpp", "-L#{lib}", "-lboost_python27", "-o",
           "hello.so", *pyincludes, *pylib

    output = <<~EOS
      from __future__ import print_function
      import hello
      print(hello.greet())
    EOS
    assert_match "Hello, world!", pipe_output("python", output, 0)
  end
end
