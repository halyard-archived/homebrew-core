class SphinxDoc < Formula
  desc "Tool to create intelligent and beautiful documentation"
  homepage "http://sphinx-doc.org"
  url "https://files.pythonhosted.org/packages/c7/e9/b1bed881847680cecc70159b8b9d5fd1cd4e85627c534712c2c7b339f8b6/Sphinx-1.8.1.tar.gz"
  sha256 "652eb8c566f18823a022bb4b6dbc868d366df332a11a0226b5bc3a798a479f17"

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install sphinx-doc
  EOS

  # generated from sphinx, setuptools, and numpydoc
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/26/e5/9897eee1100b166a61f91b68528cb692e8887300d9cbdaa1a349f6304b79/setuptools-40.5.0.zip"
    sha256 "2a2a200f4a760adbded23a091a00be2eca4e28efed65c6120ea275f7e89a1eab"
  end

  resource "alabaster" do
    url "https://files.pythonhosted.org/packages/cc/b4/ed8dcb0d67d5cfb7f83c4d5463a7614cb1d078ad7ae890c9143edebbf072/alabaster-0.7.12.tar.gz"
    sha256 "a661d72d58e6ea8a57f7a86e37d86716863ee5e92788398526d58b26a4e4dc02"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/be/cc/9c981b249a455fa0c76338966325fc70b7265521bad641bf2932f77712f4/Babel-2.6.0.tar.gz"
    sha256 "8cba50f48c529ca3fa18cf81fa9403be176d374ac4d60738b839122dfaaa3d23"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/b6/4f0cefba47656583217acd6cd797bc2db1fede0d53090fdc28ad2c8e0716/certifi-2018.10.15.tar.gz"
    sha256 "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "imagesize" do
    url "https://files.pythonhosted.org/packages/41/f5/3cf63735d54aa9974e544aa25858d8f9670ac5b4da51020bbfc6aaade741/imagesize-1.1.0.tar.gz"
    sha256 "f3832918bc3c66617f92e35f5d70729187676313caa60c187eb0f28b8fe5e3b5"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "numpydoc" do
    url "https://files.pythonhosted.org/packages/95/a8/b4706a6270f0475541c5c1ee3373c7a3b793936ec1f517f1a1dab4f896c0/numpydoc-0.8.0.tar.gz"
    sha256 "61f4bf030937b60daa3262e421775838c945dcdd671f37b69e8e4854c7eb5ffd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/cf/50/1f10d2626df0aa97ce6b62cf6ebe14f605f4e101234f7748b8da4138a8ed/packaging-18.0.tar.gz"
    sha256 "0886227f54515e592aaa2e5a553332c73962917f2831f1b0f9b9f4380a4b9807"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/1a/e2/4a7ad8f2808e03caebd3ec0a250b4afbb26d4ba063c39c3286185dd06dd1/pyparsing-2.2.2.tar.gz"
    sha256 "bc6c7146b91af3f567cf6daeaec360bc07d45ffec4cf5353f4d7a208ce7ca30a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/cd/71/ae99fc3df1b1c5267d37ef2c51b7d79c44ba8a5e37b48e3ca93b4d74d98b/pytz-2018.7.tar.gz"
    sha256 "31cb35c89bd7d333cd32c5f278fca91b523b0834369e757f4c5641ea252236ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/97/10/92d25b93e9c266c94b76a5548f020f3f1dd0eb40649cb1993532c0af8f4c/requests-2.20.0.tar.gz"
    sha256 "99dcfdaaeb17caf6e526f32b6a7b780461512ab3f1d992187801694cba42770c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/20/6b/d2a7cb176d4d664d94a6debf52cd8dbae1f7203c8e42426daa077051d59c/snowballstemmer-1.2.1.tar.gz"
    sha256 "919f26a68b2c17a7634da993d91339e288964f93c274f1343e3bbbe2096e1128"
  end

  resource "sphinxcontrib-websupport" do
    url "https://files.pythonhosted.org/packages/07/7a/e74b06dce85555ffee33e1d6b7381314169ebf7e31b62c18fcb2815626b7/sphinxcontrib-websupport-1.1.0.tar.gz"
    sha256 "9de47f375baf1ea07cdb3436ff39d7a9c76042c10a769c52353ec46e4e8fc3b9"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/bf/9b/2bf84e841575b633d8d91ad923e198a415e3901f228715524689495b4317/typing-3.6.6.tar.gz"
    sha256 "4027c5f6127a6267a435201981ba156de91ad0d1d98e9ddc2aa173453453492d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/a5/74/05ffd00b4b5c08306939c485869f5dc40cbc27357195b0a98b18e4c48893/urllib3-1.24.tar.gz"
    sha256 "41c3db2fc01e5b907288010dec72f9d0a74e37d6994e6eb56849f59fea2265ae"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"sphinx-quickstart", "-pPorject", "-aAuthor", "-v1.0", "-q", testpath
    system bin/"sphinx-build", testpath, testpath/"build"
    assert_predicate testpath/"build/index.html", :exist?
  end
end
