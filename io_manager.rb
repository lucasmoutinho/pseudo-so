class IOManager
  SCANNER_QUANTITY = 1
  PRINTER_QUANTITY = 2
  MODEM_QUANTITY = 1
  SATA_QUANTITY = 2

  @@resources = {
    scanner: Array.new(SCANNER_QUANTITY),
    printer: Array.new(PRINTER_QUANTITY),
    modem: Array.new(MODEM_QUANTITY),
    sata: Array.new(SATA_QUANTITY)
  }

  def is_resource_available?(resource) # checa se tem algum espaço disponivel daquele recurso
    @@resources[resource].any?{ |e| e.nil? }
  end

  def alocate_resource(process)
    pid = process.pid

    if process.scanner?
      if is_resource_available?(:scanner)
        index = @@resources[:scanner].index(nil)
        @@resources[:scanner][index] = pid
      end
    end

    if process.printer?
      if is_resource_available?(:printer)
        index = @@resources[:printer].index(nil)
        @@resources[:printer][index] = pid
      end
    end

    if process.modem?
      if is_resource_available?(:modem)
        index = @@resources[:modem].index(nil)
        @@resources[:modem][index] = pid
      end
    end

    if process.sata
      if is_resource_available?(:sata)
        index = @@resources[:sata].index(nil)
        @@resources[:sata][index] = pid
      end
    end

  end

end