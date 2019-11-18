class IOManager
  SCANNER_QUANTITY = 1
  PRINTER_QUANTITY = 2
  MODEM_QUANTITY = 1
  SATA_QUANTITY = 2

  attr_accessor :resources

  def initialize
    @resources = {
        scanner: Array.new(SCANNER_QUANTITY),
        printer: Array.new(PRINTER_QUANTITY),
        modem: Array.new(MODEM_QUANTITY),
        sata: Array.new(SATA_QUANTITY)
    }
  end

  def is_resource_available?(resource) # checa se tem algum espaço disponivel daquele recurso
    @resources[resource].any?{ |e| e.nil? }
  end

  def alocate_resource(process)
    pid = process.pid

    if process.scanner?
      if is_resource_available?(:scanner)
        index = @resources[:scanner].index(nil)
        @resources[:scanner][index] = pid
        puts "Scanner sendo usado por P#{pid}"
      end
    end

    if process.printer?
      if is_resource_available?(:printer)
        index = @resources[:printer].index(nil)
        @resources[:printer][index] = pid
        puts "Impressora sendo usado por P#{pid}"
      end
    end

    if process.modem?
      if is_resource_available?(:modem)
        index = @resources[:modem].index(nil)
        @resources[:modem][index] = pid
        puts "Modem sendo usado por P#{pid}"
      end
    end

    if process.sata_code
      if is_resource_available?(:sata)
        index = @resources[:sata].index(nil)
        @resources[:sata][index] = pid
        puts "Sata sendo usado por P#{pid}"
      end
    end
  end

  def free_resource(process)
    pid = process.pid

    scanner_index = self.resources[:scanner].index(pid)
    if scanner_index
      puts "Liberado scanner"
      @resources[:scanner][scanner_index] = nil
    end

    printer_index = @resources[:printer].index(pid)
    if printer_index
      puts "Liberado impressora"
      @resources[:printer][printer_index] = nil
    end

    modem_index = @resources[:modem].index(pid)
    if modem_index
      puts "Liberado modem"
      @resources[:modem][modem_index] = nil
    end

    sata_index = @resources[:sata].index(pid)
    if sata_index
      puts "Liberado sata"
      @resources[:sata][sata_index] = nil
    end
  end

end