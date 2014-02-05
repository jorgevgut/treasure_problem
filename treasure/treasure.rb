require_relative "./chest.rb"

filename = ARGV.first
file = File.open(filename)

counter = 0
cases = nil
cases_objs = []
keys = []
case_start = 1 #define where the next case is going to start
next_case = nil
active_case = nil

file.each_line do
  |line|
  if counter == 0
    cases = line.to_i
  end
  
  values = line.split.map(&:to_i)
  #puts values

  k = 0
  
  puts "Info:\nCase_start:#{case_start}\nCounter:#{counter}\nNext case:#{next_case}"

  if case_start == counter
    active_case = Treasure_case.new(values.last)
    k = values.first #number of keys
    next_case = (values[1].to_i ) #define where the next case is going to be
  elsif (case_start+1) == counter
    active_case.setStartingKeys(values)
  elsif counter > 0
    #add chest
    puts "Creating new chest"   
    key_needed = values.first
    n_keys = values[1]
    keys_in_chest = []
    if n_keys > 0
      keys_in_chest = values.slice(2,n_keys)
    end
    
    chest = Chest.new(values.first,keys_in_chest)
    active_case.addChest(chest)
    chest.printStatus
  end

 
  if next_case != nil
    if (case_start + next_case) == counter-1
      case_start = counter+1 #going to start next case
      cases_objs.push(active_case)
    end  
end
  counter+=1
end
puts "Lines read #{counter}"
puts "Number of chests  #{cases}"
#create a test chest
file.close()

puts "Number of cases #{cases_objs.length}"

result = File.new("result.out","w")

case_number = 1
for elem in cases_objs do 
  out_line = "Case \##{case_number}: "
  out = elem.search
  if out == "IMPOSSIBLE"
    out_line+= out
  else
    print "\nResult: #{out}\n"
    for letter in out do
      out_line += letter.to_s + " "
    end
  end
  out_line+="\n"
  result.write(out_line)
  puts "Done case ##{case_number}"
  case_number+=1
  
  #testing only
end


result.close()
