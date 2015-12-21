module FixtureHelper
  def fixture(name)
    File.new(File.join(File.expand_path(File.dirname(__FILE__)), "../fixtures/#{name}"), 'r:utf-8')
  end
end
