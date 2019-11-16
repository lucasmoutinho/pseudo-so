class Process
  @@io_request_types = %i[scanner printer modem sata none]

  def initialize(process)
    @created_at = Time.now
    @priority = process.priority
    @cpu_time = process.cpu_time
    @memory_blocks = process.memory_blocks
    @printer_code = process.printer_code
    @scanner_request = process.scanner_request
    @modem_request = process.modem_request
    @sata_code = process.sata_code
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