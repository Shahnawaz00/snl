def read_array()
    print("How many lines are you entering? ")
    count = gets.chomp.to_i()

    texts = []
    i = 0
    while i < count
        print("Enter text: ")
         text = gets.chomp()
         texts << text 
         i += 1
    end 
    return texts
end

def print_array(a)
    count = a.length 
    i = 0
    puts("Printing lines:")
    while i < count
        puts("#{i} #{a[i]}" )
        i += 1
    end
end

def main()
    a = read_array()
    print_array(a)
end

main()