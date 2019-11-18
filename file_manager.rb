require './file'

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
        # puts "name: #{name}"
        offset = nil
        available = 0
        if(files.any? {|file| file.name == name})
            @log.append({
                status: 'Falha',
                mensagem: "O processo P#{creator} nao criou o arquivo (Arquivo ja existe no disco)"
            })
            return
        end
        # puts "blocks_q: #{blocks_quantity}"
        blocks_quantity.times do |i|
            block = @disc[i]
            if(block == 0)
                available += 1
                # puts "fff: #{available == size} size: #{size}"
                if(available == size)
                    offset = i - available + 1
                    if offset != 0
                        size.times do |j|
                            @disc[offset % offset + available + j] = name
                            offset += 1
                        end
                    else
                        size.times do |j|
                            @disc[available + j] = name
                            offset += 1
                        end
                    end
                    file = File.new([name, offset, size], creator)
                    @files.append(file)
                    @log.append({
                        status: 'Sucesso',
                        mensagem: "O processo P#{creator} criou o arquivo"
                    })
                    return
                end
            else
                available = 0
            end
        end
        @log.append({
            status: "Falha",
            mensagem: "O processo P#{creator} nao criou o arquivo (sem espaco livre)"
        })
    end

    def delete_file(file)
        file.size.times do |i|
            @disc[file.start_block + i] = 0
        end
    end

    def operate_process(process)
        ops = @operations.select { |op| op.processId == process.pid }
        # puts "ops: #{ops}"
        ops.each do |op|
            # puts "opcode: #{op.opcode}"
            if(op.opcode == 0)
                create_file(op.file, op.size, process.pid)
            else
                file = @files.detect {|file| file.name == op.file}
                if(file != nil)
                    if(process.priority == 0 || file.creator == nil || process.pid == file.creator)
                        delete_file(file)
                        @log.append({
                            status: 'sucesso',
                            mensagem: "O processo P#{process.pid} deletou o arquivo"
                        })
                    else
                        @log.append({
                            status: 'Falha',
                            mensagem: "O processo #{process.pid} nao pode deletar o arquivo"
                        })
                    end
                else
                    @log.append({
                        status: "Falha",
                        mensagem: "O processo P#{process.pid} nao pode deletar o arquivo"
                    })
                end
            end
            @operations.delete(op)
        end
    end
end