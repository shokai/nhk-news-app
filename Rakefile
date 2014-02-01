app_path = File.expand_path "node-webkit.app", File.dirname(__FILE__)
nw_path = "#{app_path}/Contents/Resources/app.nw"
src_path = File.expand_path "src", File.dirname(__FILE__)

task :default => [:build, :run]
desc 'build app'
task :build => ['build:haml' , 'build:coffee', :buildapp]

desc 'install npm dependencies'
task 'npm:install' do
  system "cd #{src_path} && npm install"
end

task 'build:coffee' do
  puts 'build:coffee'
  system "coffee -cm src/*.coffee"
end

task 'build:haml' do
  puts 'buid:haml'
  Dir.glob("#{src_path}/*.haml").each do |src|
    dest = src.gsub(/\.haml$/, '.html')
    system "haml #{src} #{dest}"
  end
end

task :buildapp do
  puts 'build start'
  File.delete nw_path if File.exists? nw_path
  if system "cd #{src_path} && zip -r #{nw_path} *"
    puts 'build success'
  else
    puts 'build failed'
  end
end

desc 'run app'
task :run do
  puts 'run app'
  system "open #{app_path}"
end
