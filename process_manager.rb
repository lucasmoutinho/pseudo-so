class ProcessManager
  MAX_SIZE = 1

  attr_accessor :real_time_queue
  attr_accessor :user_queue
  attr_accessor :first_queue
  attr_accessor :second_queue
  attr_accessor :third_queue
  attr_accessor :main_queue
  attr_accessor :in_execution
  attr_accessor :lastPID

  def initialize
    @real_time_queue = Array.new(MAX_SIZE)
    @user_queue = Array.new(MAX_SIZE)
    @first_queue = Array.new(MAX_SIZE)
    @second_queue = Array.new(MAX_SIZE)
    @third_queue = Array.new(MAX_SIZE)
    @main_queue = Array.new(MAX_SIZE)
    @in_execution = nil # processo em execução atualmente
    @lastPID = 0
  end

  def print_all_queues
    puts ":::::MAIN_QUEUE:::::"
    puts main_queue
    puts ":::::REAL_TIME_QUEUE:::::"
    puts real_time_queue
    puts ":::::USER_QUEUE:::::"
    puts user_queue
    puts ":::::FIRST_QUEUE:::::"
    puts first_queue
    puts ":::::SECOND_QUEUE:::::"
    puts second_queue
    puts ":::::THIRD_QUEUE:::::"
    puts third_queue
  end

  def scalonate_process # função utilizada para escalonar processos
    if @main_queue.length > 0
      process_on_top = @main_queue.shift # para ser uma fila

      case process_on_top.priority
      when 0 # Processo de prioridade 0 é de tempo real e é alocado nessa fila
        @real_time_queue.push process_on_top
      else # Senão é um processo com prioridade de usuário
        @user_queue.push process_on_top
      end
    else # se não tiver fila principal com nenhum processo, retorna
      puts "End of execution. Leaving..."
    end
  end

  def scalonate_user_process
    process_on_top = @user_queue.shift # para ser uma fila

    if process_on_top
      # puts "priority: #{process_on_top.priority}"
      case process_on_top.priority.to_i
      when 0 # Processo de prioridade 0 é de tempo real e é alocado nessa fila
        @real_time_queue.push process_on_top
      when 1
        @first_queue.push process_on_top
      when 2
        @second_queue.push process_on_top
      when 3
        @third_queue.push process_on_top
      else
        puts "No default priority found"
        return "cafebabe"
      end
    else
      return "Sem processos na fila de usuario"
    end
  end

  def any_process_left? # se tiver alguma fila com processo ainda então volta true
    @real_time_queue.any? or
    @user_queue.any? or
    @first_queue.any? or
    @second_queue.any? or
    @third_queue.any? or
    @main_queue.any? or
    !@in_execution.nil?
  end

  # Gera um pid para o processo e atualiza qual foi o último gerado
  def generate_pid(process)
    if process
      process.pid = self.lastPID + 1
      self.lastPID += 1
    end
  end

  # Atualiza prioridades com base no tempo que o processo não foi executado para evitar starvation
  def change_priorities
    real_time_process = real_time_queue.shift
    first_queue_process = first_queue.shift
    second_queue_process = second_queue.shift

    # aumenta as prioridades antes de trocar de fila (aging)
    if real_time_process
      real_time_process.priority += 1
      first_queue.push real_time_process
      puts "Decresceu a prioridade de P#{real_time_process.pid} - Agora #{real_time_process.priority}"
    end
    if first_queue_process
      first_queue_process.priority += 1
      second_queue.push first_queue_process
      puts "Decresceu a prioridade de P#{first_queue_process.pid} - Agora #{first_queue_process.priority}"
    end
    if second_queue_process
      second_queue_process.priority += 1
      third_queue.push second_queue_process
      puts "Decresceu a prioridade de P#{second_queue_process.pid} - Agora #{second_queue_process.priority}"
    end

  end

  def remove_process(process)
    case process.priority.to_i
    when 0
      @real_time_queue.delete process
    when 1
      @first_queue.delete process
    when 2
      @second_queue.delete process
    when 3
      @third_queue.delete process
    else
      puts "No default priority found"
      return "cafebabe"
    end
  end
end