app_path = File.expand_path "nhk-news.app", File.dirname(__FILE__)
nw_path = "#{app_path}/Contents/Resources/app.nw"
src_path = File.expand_path "src", File.dirname(__FILE__)

task :default => [:debug, :run]

desc 'build app (debug mode)'
task :debug => ['build:haml' , 'build:coffee', 'build:app:debug']

desc 'build app (release mode)'
task :release => ['build:haml', 'build:coffee', 'build:app:release']

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

task 'build:app:debug' do
  puts 'build:app:debug start'
  File.delete nw_path if File.exists? nw_path
  if system "cd #{src_path} && zip -q -r #{nw_path} *"
    puts 'build success'
    puts " => #{app_path}"
  else
    puts 'build failed'
  end
end

task 'build:app:release' do
  puts 'build:app:release start'
  require 'tmpdir'
  require 'json'

  File.delete nw_path if File.exists? nw_path
  Dir.mktmpdir do |tmpdir|
    patterns = ['*.js', '*.html', '*.css', '*.map', 'node_modules']
    patterns.each do |pat|
      Dir.glob("#{src_path}/#{pat}").each do |f|
        system "cp -R #{f} #{tmpdir}/"
      end
    end
    File.open("#{src_path}/package.json") do |f|
      package = JSON.parse f.read
      package['window']['toolbar'] = false
      File.open("#{tmpdir}/package.json", "w+") do |out|
        out.write package.to_json
      end
    end
    if system "cd #{tmpdir} && zip -q -r #{nw_path} *"
      puts 'build success'
      puts " => #{app_path}"
    else
      puts 'build failed'
    end
  end
end

desc 'run app'
task :run do
  puts 'run app'
  system "open #{app_path}"
end
