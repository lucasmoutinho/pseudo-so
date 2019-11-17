#
TAM_TR = 64
TAM_USER = 960

class MemoryManager
    @memory = Array.new(TAM_TR + TAM_USER)

    def save(process)
        if process
            offset = nil
            available = 0
            start = 0
            finish = TAM_TR + TAM_USER
            if(process["priority"] > 0)
                start = TAM_TR
            else
                finish = TAM_TR
            end
            (finish - start).times {|i|
                bloco = memory[i]
                if(bloco == nil)
                    available++
                    if(available == process['memory_blocks'])
                        offset = i - available + 1
                        @memory[offset % offset + available] = process['memoty_blocs'] * [process['PID']]
                        # break
                    end
                else
                    available = 0
                end
            }
        end
        return offset
    end

    def kill(process)
        @memory[process['offset'] % process['offset'] + process['memory_blocks']] = process['memory_blocs'] * [nil]
    end
end