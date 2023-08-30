class Game
    attr_accessor :rows, :columns, :generation, :initial_generation, :file

    def initialize
        if file_exist?
            @file = IO.readlines("input.txt")   
        else
            @file = IO.readlines("sample.txt")        
        end
            @rows = @file[1].split(' ')[0].to_i
            @columns = @file[1].split(' ')[1].to_i
            @initial_generation = @file[0].split(' ')[1].to_i
            @generation = @initial_generation
    end

    def correct_format?
         title_format? && size_format? && grid_format?
    end

    def file_exist?
        File.exist?("input.txt") && !File.zero?("input.txt")
    end

    def is_number?(obj)
        obj.to_s == obj.to_i.to_s
    end

    def title_format?
        (@file[0].split(' ')[0] == "Generation") &&  ( is_number? (@file[0].split(' ')[1].split(':')[0]) )
    end

    def size_format?
        (is_number?(@file[1].split(' ')[0])) &&
        (is_number?(@file[1].split(' ')[1])) &&
         (@file[1].split(' ')[0].to_i >= 1) &&
        (@file[1].split(' ')[1].to_i >= 1)
    end

    def grid_format?
        result = true
        read_file.each_with_index do |row, row_index| 
            row.each_with_index do |col, col_index|
                if  @file[row_index + 2].gsub(/\s+/, "")[col_index] == "*" ||  @file[row_index + 2].gsub(/\s+/, "")[col_index] == "."                       
                else
                    result = false                    
                end
            end
        end 
        return result
    end

    def load_grid(strings_grid)
        default = '.'
        grid = Array.new(@rows) {Array.new(@columns, default)}
        grid_view = strings_grid.split.each_slice(@columns).to_a 
            grid.each_with_index do |row, row_index| 
                row.each_with_index do |col, col_index|
                    grid[row_index][col_index] = grid_view[row_index][col_index]
                end
            end   
        return grid
    end

    def read_file
        default = '.'
        grid = Array.new(@rows) {Array.new(@columns, default)} 
        grid.each_with_index do |row, row_index| 
            row.each_with_index do |col, col_index|
                grid[row_index][col_index] = @file[row_index + 2].gsub(/\s+/, "")[col_index]
            end
        end 
    end

    def create_grid(row, column)
        default = '.'
        grid = Array.new(row) { Array.new(column) {['.', '*'].sample} }
    end

    def next_grid(grid)
        new_grid = Array.new(@rows) {Array.new(@columns, ".")}
        @generation += 1  
        grid.each_with_index do |row, row_index| 
            row.each_with_index do |col, col_index|
                #rule
                if live?(grid, row_index, col_index) 
                    #rule 1
                    if live_neighbours(grid, row_index, col_index) < 2
                        new_grid[row_index][col_index] = "."
                    end
                    #rule 2
                    if live_neighbours(grid, row_index, col_index) == 2 || live_neighbours(grid, row_index, col_index) == 3
                        new_grid[row_index][col_index] = "*"
                    end
                    #rule 3
                    if live_neighbours(grid, row_index, col_index) > 3
                        new_grid[row_index][col_index] = "."
                    end
                else
                    #rule 4
                    if live_neighbours(grid, row_index, col_index) == 3
                        new_grid[row_index][col_index] = "*"
                    end

                end
            end 
        end
        return new_grid
        
        
    end

    def live?(grid, x ,y)
        grid[x][y] == "*"
    end


    def live_neighbours(grid, x, y)
        #counter live neighbours  
        neighbours = 0 

        #check nord
        if x > 0 && grid[x-1][y] == '*'
            neighbours += 1
        end
        #check south
        if (x < @rows -1) && grid[x+1][y] == '*'
            neighbours += 1
        end
        #check east
        if (y < @columns -1 ) && grid[x][y+1] == '*'
            neighbours += 1
        end
        #check west
        if (y > 0 ) && grid[x][y-1] == '*'
            neighbours += 1
        end
        #check north west
        if (x > 0) && (y > 0) && grid[x-1][y-1] == '*'
            neighbours += 1
        end
        #check north east
        if (x > 0) && (y < @columns -1) && grid[x-1][y+1] == '*'
            neighbours += 1
        end
        #check south west
        if (x < @rows -1) && ( y > 0) && grid[x+1][y-1] == '*'
            neighbours += 1
        end
        #check south east
        if (x < @rows -1) && (y < @columns -1) && grid[x+1][y+1] == '*'
            neighbours += 1
        end

        return neighbours
    end
end