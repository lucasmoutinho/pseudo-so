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
    @priority = process[1] #process.priority
    @cpu_time = process[2] #process.cpu_time
    @memory_blocks = process[3] #process.memory_blocks
    @printer_code = process[4] #process.printer_code
    @scanner_request = process[5] #process.scanner_request
    @modem_request = process[6] #process.modem_request
    @sata_code = process[7] #process.sata_code
    @offset = nil
    @pid = nil
    @times_executed = 0
  end

  def scanner?
    @scanner_request == 1
  end

  def printer?
    @printer_code != 0
  end

  def modem?
    @modem_request == 1
  end

  def sata?
    @sata_code != 0
  end
end