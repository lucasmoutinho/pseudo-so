class File
    attr_reader :name
    attr_reader :startBlock
    attr_reader :size
    attr_reader :creator
    def initialize(file, creator = nil)
        @name = file[0]
        @startBlock = file[1].to_i
        @size = file[2].to_i
        @creator = creator
    end
end

