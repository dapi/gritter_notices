
# https://github.com/rspec/rspec-rails/blob/master/specs.watchr

# Other examples:
# https://gist.github.com/298168

# --------------------------------------------------
# Convenience Methods
# --------------------------------------------------

def all_spec_files
  'spec/**/*_spec.rb'
end

def run_spec_matching(thing_to_match)
  puts "Matching #{thing_to_match}"
  matches = Dir[all_spec_files].grep(/#{thing_to_match}_spec/i)
  if matches.empty?
    puts "Sorry, thanks for playing, but there were no matches for #{thing_to_match}"
  else
    run matches.join(' ')
  end
end

def run(files_to_run)
  puts "Running #{files_to_run}"
  system "bundle exec rspec -d #{files_to_run}"
  no_int_for_you
  notify
  puts
end

def notify message=''
  # message = message.split('---------------------------------------------------------------')[3].split('Time taken by tests')[0]
  # image = message.include?('fails') ? "~/.watchr_images/failed.png" : "~/.watchr_images/passed.png"

  # Grub images from autotest-growl
  image = $?.success? ? "~/.watchr_images/passed.png" : "~/.watchr_images/failed.png"
  message = $?.success? ? "success" : "failed"

  options = "-i #{File.expand_path(image)} "
  options += '-u critical -t 10000 ' unless $?.success?

  notify_send = `which notify-send`.chomp
  cmd = "#{notify_send} #{options} 'Watchr Test Results: #{message}'"
  system cmd
end

def run_all_specs
  run('spec/') #all_spec_files
end


# def run_suite
#   system "clear"
#   run_spec('spec/*/*_spec.rb spec/*/*/*_spec.rb')
# end



# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch('^app/(.*)\.(.*)') { |m| run_spec_matching(m[1]) }
watch('^lib\/(.*)\.rb') { |m| run_spec_matching(m[1]) }
watch('^spec\/(.*)_spec\.rb') { |m| run_spec_matching(m[1]) }
watch('^spec\/factories/(.*)_factory\.rb') { |m| run_spec_matching(m[1]) }
watch('^spec/spec_helper\.rb') { run_all_specs }
watch('^spec/support/.*\.rb') { run_all_specs }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------

def no_int_for_you
  @sent_an_int = nil
end

# Ctrl-C
Signal.trap 'INT' do
  if @sent_an_int then
    puts " A second INT? Ok, I get the message. Shutting down now."
    exit
  else
    puts " Did you just send me an INT? Ugh. I'll quit for real if you do it again."
    @sent_an_int = true
    Kernel.sleep 1.5
    run_all_specs
  end
end


# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all tests ---\n\n"
  run_suite
end

puts "Watching.."
