class FileManager
    attr_reader :blocks_quantity
    attr_reader :segments_quantity
    attr_reader :files
    attr_reader :operations
    attr_reader :disc
    attr_reader :log
    def initialize()
        @blocks_quantity = 0
        @segments_quantity = 0
        @files = []
        @operations = []
        @log = []
    end

    def initialize_disc()
        @disc = []
        @blocks_quantity.times{|i| @disc[i] = 0}
        @files.each{|file| @disc[file['begining_block'] % file['start_block'] + file['size']] = file['size'] * [file['name']] }
    end

    def create_file(name, size, creator)
        offset = nil
        available = 0
        if(files.any?{|file| file.name == name})
            @log.append({
                "status": 'Falha',
                "mensagem": 'O processo nao criou o arquivo (Arquivo ja existe no disco)'
            })
            return
        end
        blocks_quantity.times{|i|
            block = @disc[i]
            if(block == 0)
                available++
                if(available == size)
                    offset = i - available + 1
                    @disc[offset % offset + available]
                    file = File([name, offset, size], creator)
                    @files.append(file)
                    @log.append({
                        "status": 'Sucesso',
                        "mensagem": "O processo criou o arquivo"
                    })
                    return
                end
            else
                available = 0
            end
        }
        @log.append({
            "status": "Falha",
            "mensagem": "O processo nao criou o arquivo (sem espaco livre)"
        })
    end

    def delete_file(file)
        @disc[file['start_block'] % file['start_block'] + file['size']] = file['size'] * [0]
    end

    def operate_process(process)
        ops = @operations.select { |op| op[:process_id] == process['process_id'] }
        ops.each do |op|
            if(op['opcode'] == 0)
                create_file(op['file'], op['size'], process['process_id'])
            else
                file = @files.detect {|file| file['name'] == op['file']}
                if(file != nil)
                    if(process['priority'] == 0 || file['creator'] == nil || process['process_id'] == file['creator'])
                        delete_file(file)
                        @log.append({
                            "status": 'sucesso',
                            "mensagem": "O processo deletou o arquivo"
                        })
                    else
                        @log.append({
                            'status': 'Falha',
                            'mensagem': 'O processo nao pode deletar o arquivo'
                        })
                    end
                else
                    @log.append({
                        "status": "Falha",
                        "mensagem": 'O processo nao pode deletar o arquivo'
                    })
                end
            end
            @operations.delete(op)
        end
    end
end