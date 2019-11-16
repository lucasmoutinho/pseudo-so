class FileOperation
    attr_reader :processId
    attr_reader :opcode
    attr_reader :file
    attr_reader :size
    def initialize(operation)
        @processId = operation[0].to_i
        @opcode = operation[1].to_i
        @file = operation[2].to_i
        if(opcode == 0)
            @size = operation[3].to_i
        else
            @size = nil
        end
    end
end