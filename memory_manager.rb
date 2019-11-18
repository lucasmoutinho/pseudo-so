#
TAM_TR = 64
TAM_USER = 960

class MemoryManager
    def initialize
        @memory = Array.new(TAM_TR + TAM_USER)
    end

    def save(process)
        if process
            offset = nil
            available = 0
            start = 0
            finish = TAM_TR + TAM_USER
            if(process.priority.to_i > 0)
                start = TAM_TR
            else
                finish = TAM_TR
            end
            (finish - start).times {|i|
                bloco = @memory[i]
                if(bloco == nil)
                    available += 1
                    if(available == process.memory_blocks)
                        offset = i - available + 1
                        if offset != 0
                            process.memory_blocks.times do |i|
                                @memory[offset % offset + available] = process.pid
                            end
                        end
                        break
                    end
                else
                    available = 0
                end
            }
            return offset
        end
        return nil
    end

    def kill(process)
        if process.offset != 0
            process.memory_blocks.times do |i|
                @memory[process.offset % process.offset + process.memory_blocks + i] = nil
            end
        end
    end
end