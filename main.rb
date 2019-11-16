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

  puts process_manager.main_queue
  puts filesystem_manager.files
  # Ler arquivo de processos
  process_manager.main_queue = File.readlines(process_file)

  # Ler arquivo do sistema de arquivos
  filesystem_manager.files = File.readlines(files_file)

  puts process_manager.main_queue
  puts filesystem_manager.files

  puts "Thats it"
end

main