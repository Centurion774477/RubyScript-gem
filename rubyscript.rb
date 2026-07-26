#!/usr/bin/ruby

class Birth
  def initialize
    @default_file_name = 'foobar.txt'
    @default_dir_name = 'foobar'
  end

  # file_name can optionally be an array, but I'm omitting this feature for the PoC.
  def file(times=1, times_throwaway=nil, file_name: @default_file_name)
    file_name ||= @default_file_name
    
    times.times do
      FileUtils.touch(file_name)
    end
  end

  def directory(directory_name)
    directory_name ||= @default_dir_name
    Dir.mkdir(directory_name)
  end
end


def examine(file)
  need_to_parse = false
  if File.extname(file) in %w|.json| then need_to_parse = true end
  got_data = File.read(file)
  return got_data unless need_to_parse
  
  case File.extname(file)
  when 'json' then return JSON.parse(got_data)
  else raise "Sorry! RubyScript doesn't support that data type yet: #{File.extname(file)}"
  end
end

# remember the alias populate
def formulate(file_to_open, with_throwaway, data_to_add)
  File.write(file_to_open, '') unless File.exist?(file_to_open) 

  file_handle = File.new(file_to_open, 'w')
  file_handle.puts data_to_add
  file_handle.close
end

alias populate formulate

# I'll fix all these in a later update
def makeEveryExtension(replacement, including_exception=false, exception=nil)
  Dir.glob("./**/*").each do |path|
    # FIX THIS: this currently only works for the extension type.
    next if File.directory?(path) || path in %w|.. . DS_STORE|
    this_extension = File.extname(path)
    new_path = path.sub(/#{Regexp.escape(this_extension)}$/, ".#{replacement}")
    File.rename(path, new_path)
  end
end

def makeEveryTitle(replacement, including_exception=false, exception=nil)
  Dir.glob("./**/*").each do |path|
    next if File.directory?(path) || path in %w|.. . DS_STORE|
    this_title = File.basename(path, ".*")
    File.rename(this_title, replacement) unless including_exception && this_title == exception
  end
end

def makeEverything(replacement, including_exception=false, exception=nil)
    Dir.glob("./**/*").each do |path|
    next if File.directory?(path) || path in %w|.. . DS_STORE|
    this_fullname = File.basename(path)
    File.rename(this_fullname, replacement) unless including_exception && this_fullname == exception
  end
end

# options for type:
# extension: this refers to the extension of each file. This will return 'txt'; no need to say .txt when referring to the extension type.
# title: this refers to the name of the file, excluding the extension. This would return 'variables'
# everything: this refers to both the name of the file and the extension; variables.txt
def make(every_throwaway, directory, type, replacement, except_throwaway=nil, exception=nil)
  Dir.exist?(directory) or fail "RubyScript could not locate #{directory} in this context."

  including_exception = false
  including_exception = true if defined?(except_throwaway) && defined?(exception)
  return case type
  # fix the arguments passed
  when 'extension'  then makeEveryExtension(replacement, including_exception, exception)
  when 'title'      then makeEveryTitle(replacement, including_exception, exception)
  when 'everything' then makeEverything(replacement, including_exception, exception)
  else fail "Invalid type passed to make: #{type}"
  end
end

def scan(file_to_scan, for_throwaway, pattern)
  fail "Given file doesn't exist in this context: #{file_to_scan}" unless File.exist?(file_to_scan)
  occurences = []
  File.foreach(file_to_scan) do |line|
    # sorry this is so fucking bad.
    if pattern.is_a?(Regexp)
      occurences << line if line =~ pattern
    else
      occurences << line if line == pattern
    end
  end
  occurences.empty? ? nil : occurences
end



# I'm a fucking lazy jerkoff so I'm gonna comment this out; but I'll fix it later

# the options for amount_indicator are:
# all -> every file in the directory
# any -> one file in the directory
# I'm not going to implement this yet since any is pretty useless anyways; RubyScript doesn't save much time for one-off changes.

# options for identifier: (same as make)
# extension: this refers to the extension of each file. This will return 'txt'; no need to say .txt when referring to the extension type.
# title: this refers to the name of the file, excluding the extension. This would return 'variables'
# everything: this refers to both the name of the file and the extension; variables.txt
# class Work
  # def until(amount_indicator, directory, identifier, eq_throwaway, equal_to)
  #   Dir.exist?(directory)                        or fail 'Failed to locate directory: ' + directory
  #   amount_indicator in %w|all any|              or fail 'Invalid amount specified for a work clause: ' + amount_indicator
  
  #   # fix
  #   case identifier
  #   when 'extension'  then makeEveryExtension(replacement: equal_to)
  #   when 'title'      then makeEveryTitle(replacement: equal_to)
  #   when 'everything' then makeEverything(replacement: equal_to)
  #   else              fail 'Invalid type passed to a work statement: ' + identifier
  #   end
  # end
# end