require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"

desc "Generate blog files"
task :generate do
  Jekyll::Site.new(Jekyll.configuration({
                                          "source"      => ".",
                                          "destination" => "_site"
                                        })).process
end


desc "Generate and publish blog to gh-pages"
task :publish => [:generate] do
  Dir.mktmpdir do |tmp|
    cp_r "_site/.", tmp
    cp_r "README.org", tmp

    sourceHash = `git rev-parse --short source`
    sourceHash = sourceHash.gsub("\n","")
    sourceHash = sourceHash.gsub("\"","")

    pwd = Dir.pwd
    Dir.chdir tmp

    system "git init"
    system "git add ."
    message = "Site updated at #{Time.now.utc} Related to #{sourceHash} commit on source"
    system "git commit -m #{message.inspect}"
    system "git remote add origin https://github.com/drorata/drorata.github.io.git"
    system "git push origin master --force"

    Dir.chdir pwd
  end
end
