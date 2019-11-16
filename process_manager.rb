class ProcessManager
  @@real_time_queue = Array.new(1000)
  @@user_queue = Array.new(1000)
  @@first_queue = Array.new(1000)
  @@second_queue = Array.new(1000)
  @@third_queue = Array.new(1000)
  @@main_queue = Array.new(1000)
  @@in_execution = nil # processo em execução atualmente
  @@lastPID = 0

  def scalonate_process # função utilizada para escalonar processos
    if @@main_queue.length > 0
      process_on_top = @@main_queue.shift # para ser uma fila

      case process_on_top.priority
      when 0 # Processo de prioridade 0 é de tempo real e é alocado nessa fila
        @@real_time_queue.push process_on_top
      else # Senão é um processo com prioridade de usuário
        @@user_queue.push process_on_top
      end
    else # se não tiver fila principal com nenhum processo, retorna
      puts "End of execution. Leaving..."
    end
  end

  def scalonate_user_process
    process_on_top = @@user_queue.shift # para ser uma fila

    case process_on_top.priority
    when 0 # Processo de prioridade 0 é de tempo real e é alocado nessa fila
      @@real_time_queue.push process_on_top
    when 1
      @@first_queue.push process_on_top
    when 2
      @@second_queue.push process_on_top
    when 3
      @@third_queue.push process_on_top
    else
      puts "No default priority found"
      return "cafebabe"
    end
  end

  def any_process_left? # se tiver alguma fila com processo ainda então volta true
    @@real_time_queue.any? or
    @@user_queue.any? or
    @@first_queue.any? or
    @@second_queue.any? or
    @@third_queue.any? or
    @@main_queue.any? or
    !@@in_execution.nil?
  end
end