class File
    attr_reader :name
    attr_reader :start_block
    attr_reader :size
    attr_reader :creator
    def initialize(file, creator = nil)
        @name = file[0]
        @start_block = file[1].to_i
        @size = file[2].to_i
        @creator = creator
    end
end

