require './file'
require './file_manager'
require './file_operations'
require './io_manager'
require './logger'
require './memory_manager'
require './process'
require './process_manager'

def main
  process_manager = ProcessManager.new
  memory_manager = MemoryManager.new
  io_manager = IOManager.new
  filesystem_manager = FileManager.new
  logger = SOLogger.new

  process_file = "processes.txt"
  files_file = "files.txt"

  puts "Before read"
  # puts process_manager.main_queue
  # puts filesystem_manager.files
  # Ler arquivo de processos
  aux_process_array = File.readlines(process_file)
  aux_process_array.each do |process|
    new_process = SOProcess.new(process.split(','))
    puts "New Process:"
    puts new_process.created_at
    process_manager.main_queue.push(new_process)
  end

  # Ler arquivo do sistema de arquivos
  aux_filesystem_array = File.readlines(files_file)
  aux_filesystem_array.each do |file|
    new_file = File.new(file.split(','))
    filesystem_manager.files.push(new_file)
  end

  puts "After read"
  puts process_manager.main_queue
  puts filesystem_manager.files

  # process_manager.main_queue = process_manager.main_queue.sort_by { |process| process.created_at  }

  # while(true)
  #
  # end
end

main