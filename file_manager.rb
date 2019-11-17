class FileManager
    attr_accessor :blocks_quantity
    attr_accessor :segments_quantity
    attr_accessor :files
    attr_accessor :operations
    attr_accessor :disc
    attr_accessor :log
    def initialize()
        @blocks_quantity = 0
        @segments_quantity = 0
        @files = []
        @operations = []
        @disc = []
        @log = []
    end

    def initialize_disc()
        @disc = []
        @blocks_quantity.times {|i| @disc[i] = 0}
        @files.each do |file|
            if file.start_block != 0
                @disc[file.start_block % file.start_block + file.size] = file.size * file.name.to_i
            end
        end
    end

    def create_file(name, size, creator)
        offset = nil
        available = 0
        if(files.any? {|file| file.name == name})
            @log.append({
                status: 'Falha',
                mensagem: 'O processo nao criou o arquivo (Arquivo ja existe no disco)'
            })
            return
        end
        blocks_quantity.times {|i|
            block = @disc[i]
            if(block == 0)
                available++
                if(available == size)
                    offset = i - available + 1
                    @disc[offset % offset + available]
                    file = File([name, offset, size], creator)
                    @files.append(file)
                    @log.append({
                        status: 'Sucesso',
                        mensagem: "O processo criou o arquivo"
                    })
                    # return
                end
            else
                available = 0
            end
        }
        @log.append({
            status: "Falha",
            mensagem: "O processo nao criou o arquivo (sem espaco livre)"
        })
    end

    def delete_file(file)
        @disc[file.start_block % file.start_block + file.size] = file.size * [0]
    end

    def operate_process(process)
        ops = @operations.select { |op| op.processId == process.pid }
        puts "ops: #{ops}"
        ops.each do |op|
            if(op.opcode == 0)
                create_file(op.file, op.size, process.pid)
            else
                file = @files.detect {|file| file.name == op.file}
                if(file != nil)
                    if(process.priority == 0 || file.creator == nil || process.pid == file.creator)
                        delete_file(file)
                        @log.append({
                            status: 'sucesso',
                            mensagem: "O processo deletou o arquivo"
                        })
                    else
                        @log.append({
                            status: 'Falha',
                            mensagem: 'O processo nao pode deletar o arquivo'
                        })
                    end
                else
                    @log.append({
                        status: "Falha",
                        mensagem: 'O processo nao pode deletar o arquivo'
                    })
                end
            end
            @operations.delete(op)
        end
    end
end