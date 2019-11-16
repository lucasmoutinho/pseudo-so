class Process
  @@io_request_types = %i[scanner printer modem sata none]

  def initialize(process)
    @created_at = Time.now
    @priority = process.priority
    @cpu_time = process.cpu_time
    @io_request_type = process.io_request_type # scanner, printer, modem, sata, none
    @pid = nil
    @times_executed = 0
  end
end