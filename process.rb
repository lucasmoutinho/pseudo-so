class SOProcess
  attr_accessor :created_at
  attr_accessor :priority
  attr_accessor :cpu_time
  attr_accessor :memory_blocks
  attr_accessor :printer_code
  attr_accessor :scanner_request
  attr_accessor :modem_request
  attr_accessor :sata_code
  attr_accessor :offset
  attr_accessor :pid
  attr_accessor :times_executed

  @@io_request_types = %i[scanner printer modem sata none]

  def initialize(process)
    @created_at = process[0]
    @priority = process[1].to_i #process.priority
    @cpu_time = process[2].to_i #process.cpu_time
    @memory_blocks = process[3].to_i #process.memory_blocks
    @printer_code = process[4] #process.printer_code
    @scanner_request = process[5] #process.scanner_request
    @modem_request = process[6] #process.modem_request
    @sata_code = process[7] #process.sata_code
    @offset = nil
    @pid = nil
    @times_executed = 0
  end

  def scanner?
    @scanner_request.to_i == 1
  end

  def printer?
    @printer_code.to_i < 2
  end

  def modem?
    @modem_request.to_i == 1
  end

  def sata?
    @sata_code.to_i < 2
  end

  def should_not_be_stoped?(real_time_queue, first_queue, second_queue)
    if self.priority.to_i == 0
      return true
    elsif self.priority.to_i == 1
      if real_time_queue.length > 0 # se tiver algum processo na fila de realtime, entao deve parar o de prioridade 1
        return false
      end
    elsif self.priority.to_i == 2
      if real_time_queue.length > 0 or first_queue.length > 0 # se tiver algum processo na fila de realtime ou primeira, entao deve parar o de prioridade 2
        return false
      end
    else
      if real_time_queue.length > 0 or first_queue.length > 0 or second_queue.length > 0 # se tiver algum processo na fila de realtime ou primeira, entao deve parar o de prioridade 2
        return false
      end
    end

    return true
  end

end