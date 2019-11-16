class Logger
  @@last_process = nil

  def dispatch(process) # informações do processo à ser dispatched
    puts "dispatcher =>"
    puts "PID:\t #{process.pid}"
    puts "offset:\t #{process.offset}"
    puts "blocks:\t #{process.memory_blocks}"
    puts "priority:\t #{process.priority}"
    puts "time:\t #{process.cpu_time}"
    puts "printers:\t #{process.printer_code}"
    puts "scanner:\t #{process.scanner_request}"
    puts "modem:\t #{process.modem_request}"
    puts "drives:\t #{process.sata_code}"
  end

  def execute(process)
    if @@last_process != process.pid
      if @@last_process != -1
        puts "P#{@@last_process}"
      elsif process.times_executed.equal? 1 # primeira vez sendo executado
        puts "P#{process.pid} STARTED"
      else
        puts "P#{process.pid} RESUMED"
      end
    end
    puts "P#{process.pid} instruction #{process.times_executed}"
    @@last_process = process.pid
    if process.cpu_time == 0 # acabou o tempo de cpu
      puts "P#{process.pid} return SIGINT"
      @@last_process = -1
    end
  end
end