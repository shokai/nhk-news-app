app_path = File.expand_path "node-webkit.app", File.dirname(__FILE__)
nw_path = "#{app_path}/Contents/Resources/app.nw"
src_path = File.expand_path "src", File.dirname(__FILE__)

task :default => [:build, :run]

desc 'build app'
task :build do
  puts 'build start'
  File.delete nw_path if File.exists? nw_path
  if system "cd #{src_path} && zip #{nw_path} *"
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
