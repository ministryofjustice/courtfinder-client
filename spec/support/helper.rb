def fixture(file)
  File.new(File.expand_path(file, 'spec/support')).read
end
