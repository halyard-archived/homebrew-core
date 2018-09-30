class BoostPython < Formula
  desc "C++ library for C++/Python2 interoperability"
  homepage "https://www.boost.org/"
  url "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2"
  sha256 "5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9"

  depends_on "boost"

  needs :cxx11

  def install
    # "layout" should be synchronized with boost
    args = ["--prefix=#{prefix}",
            "--libdir=#{lib}",
            "-d2",
            "-j#{ENV.make_jobs}",
            "--layout=tagged",
            "threading=multi,single",
            "link=shared,static"]

    # Trunk starts using "clang++ -x c" to select C compiler which breaks C++11
    # handling using ENV.cxx11. Using "cxxflags" and "linkflags" still works.
    args << "cxxflags=-std=c++11"
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
