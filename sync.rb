#author newdongyuwei@gmail.com

require 'rubygems'
require 'fsevents'
require 'net/ssh'
require 'net/scp'
require 'ruby-growl' #only macruby implemented growl lib supports click callback

host = "10.210.74.63"
username = "my name"
password = "my password"

source_dir = '/Users/yuwei/workspace/miniblog'
target_dir = '/data1/wwwroot/js.wcdn.cn/dev_js/miniblog'

def upload(host, username,password,source, target)
    Net::SCP.start(host, username, :password => password) do |scp|
        scp.upload!(source, target,:recursive => false)do |ch, name, sent, total|
         #progress reports
         #puts "#{name}: #{sent}/#{total}"
        end
        p "#{source} modified,synced to server !"
        begin
            #config growl listen to network connection
            g = Growl.new "127.0.0.1", "ruby-growl", ["ruby-growl Notification"]
            g.notify "ruby-growl Notification", "File sync", "#{source} modified,synced to server !"
        rescue
            p $!
        end
    end
end

stream = FSEvents::Stream.watch(source_dir) do |events|
    events.each do |event|
        event.modified_files.each do|modified|
            if File.file? modified and not modified.include? '.svn'
                #p modified
                target  = target_dir + modified.split(source_dir)[1]
                #p target
                upload(host, username,password,modified, target)
            end
        end
    end
end
stream.run
