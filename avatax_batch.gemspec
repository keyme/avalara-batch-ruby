Gem::Specification.new do |s|
  s.name = "avatax_batch"
  s.version = "0.0.0"
  s.date = "2016-01-22"
  s.summary = "Library for accessing Avalara's Batch services."
  s.authors = ["Heather Petrow"]
  s.email = "heather@key.me"
  s.files = DIR['README.md', 'lib/*', 'samples/*', 'spec/*', 'Avatax_BatchService.gemspec']
  s.homepage = "https://github.com/keyme/avalara-batch-ruby"
  s.license = "MIT"
  s.add_dependency "savon", ">= 2.3.0"
end
