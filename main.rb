require './file'
require './file_manager'
require './file_operations'
require './io_manager'
require './logger'
require './memory_manager'
require './process'
require './process_manager'

def main
  # definindo tamanho do quantum
  quantum = 1

  process_manager = ProcessManager.new
  memory_manager = MemoryManager.new
  io_manager = IOManager.new
  filesystem_manager = FileManager.new
  logger = SOLogger.new

  process_file = "processes.txt"
  files_file = "files.txt"

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
  blocks_quantity = aux_filesystem_array.shift.to_i
  disk_segments = aux_filesystem_array.shift.to_i
  disk_segments.times do
    aux_file = aux_filesystem_array.shift
    new_file = File.new(aux_file.split(','))
    filesystem_manager.files.push(new_file)
  end

  aux_filesystem_array.each do |operation|
    aux_operation = FileOperation.new(operation.split(','))
    filesystem_manager.operations.push aux_operation
  end

  puts "After read"
  puts process_manager.main_queue
  puts filesystem_manager.files

  # inicializa o disco
  filesystem_manager.initialize_disc

  # Ordena a fila principal por prioridade
  process_manager.main_queue = process_manager.main_queue.compact.sort_by{|process| process.created_at}

  puts "After sort"
  puts process_manager.main_queue
  puts "\n\n"

  time = 0
  while process_manager.any_process_left?
    # puts time
    # process_manager.print_all_queues

    while process_manager.main_queue.any? # enquanto tiver processos na fila principal
      if process_manager.main_queue.first.created_at.to_i.equal? time.to_i # se o processo tiver chegado naquele tempo
        process_manager.scalonate_process
      else # ja esta por ordem de tempo
        break
      end
    end

    process_manager.user_queue.each do # para cada processo de usuário na fila ele é alocado na fila certa
      process_manager.scalonate_user_process
    end

    if process_manager.in_execution # Aqui vem a lógica de 'executar' o processo
      # puts "Processo P#{process_manager.in_execution.pid} em execução..."
      process_manager.in_execution.cpu_time -= quantum # diminui em 1 unidade de tempo a execucao
      process_manager.in_execution.times_executed += 1

      logger.execute(process_manager.in_execution)
      if process_manager.in_execution.cpu_time.zero? # se acabar o tempo de cpu do processo
        filesystem_manager.operate_process(process_manager.in_execution)
        io_manager.free_resource(process_manager.in_execution)
        memory_manager.kill(process_manager.in_execution)
        process_manager.remove_process(process_manager.in_execution)
        process_manager.in_execution = nil
      end
    else # Se não tiver processo sendo executado ve qual vai ser
      # dispachar processos de tempo real primeiro
      process_manager.real_time_queue.each do |real_time_process|
        next unless real_time_process
        process_manager.generate_pid(real_time_process)
        offset = memory_manager.save(real_time_process)
        # puts "aqui #{offset}"
        if offset
          process_manager.in_execution = real_time_process
          process_manager.in_execution.offset = offset
          logger.dispatch(process_manager.in_execution)
        else # nao foi possível salvar o processo na memoria
          real_time_process.pid = nil
          process_manager.lastPID -= 1
        end
      end

      # dispachar processos de usuário de acordo com as filas
      process_manager.first_queue.each do |first_priority_process|
        next unless first_priority_process

        if first_priority_process.offset # se ja tiver sido alocado
          offset = first_priority_process.offset
        else
          process_manager.generate_pid(first_priority_process)
          io_manager.alocate_resource(first_priority_process) # aloca recursos de io requisitados pelo processo de usuário
          offset = memory_manager.save(first_priority_process)
          if offset
            logger.dispatch(first_priority_process)
          end
        end

        if offset
          process_manager.in_execution = first_priority_process
          process_manager.in_execution.offset = offset
        else # se nao conseguir alocar o processo
          first_priority_process.pid = nil
          process_manager.lastPID -= 1
        end
      end

      process_manager.second_queue.each do |second_priority_process|
        next unless second_priority_process

        if second_priority_process.offset # se ja tiver sido alocado
          offset = second_priority_process.offset
        else
          process_manager.generate_pid(second_priority_process)
          io_manager.alocate_resource(second_priority_process) # aloca recursos de io requisitados pelo processo de usuário
          offset = memory_manager.save(second_priority_process)
          if offset
            logger.dispatch(second_priority_process)
          end
        end

        if offset
          process_manager.in_execution = second_priority_process
          process_manager.in_execution.offset = offset
        else # se nao conseguir alocar o processo
          second_priority_process.pid = nil
          process_manager.lastPID -= 1
        end
      end

      process_manager.third_queue.each do |third_priority_process|
        next unless third_priority_process

        if third_priority_process.offset # se ja tiver sido alocado
          offset = third_priority_process.offset
        else
          process_manager.generate_pid(third_priority_process)
          io_manager.alocate_resource(third_priority_process) # aloca recursos de io requisitados pelo processo de usuário
          offset = memory_manager.save(third_priority_process)
          if offset
            logger.dispatch(third_priority_process)
          end
        end

        if offset
          process_manager.in_execution = third_priority_process
          process_manager.in_execution.offset = offset
        else # se nao conseguir alocar o processo
          third_priority_process.pid = nil
          process_manager.lastPID -= 1
        end
      end

    end

    # unless process_manager.any_process_left?
    #   break
    # end

    if time > 100
      break
    end

    # fazer logica de escalonador aumentar prioridade de quem nao tem
    if time % 5 == 0
      process_manager.change_priorities
    end

    time += 1
  end

  logger.disk_manager(filesystem_manager)
end

main