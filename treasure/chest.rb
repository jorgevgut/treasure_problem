require "./chest_graph.rb"

class Treasure_case 

  def initialize(noc)
    @N = []
    @keys = []  
    @nChests = noc
    @solutions = []
    @output = ""  
  end

  def setStartingKeys(k)
    @keys = k
  end
  
  def addChest(chest)
   @N.push(chest)
  end

  #works great when keys < chests
  def isPossibleRec(keys,chests)
    # print "exec_Possible rec:\ncurrent keys: #{keys}\nCurrent chests:#{chests.length}\n"    
    
    possible = true
    my_chest_graph = Cgraph.new()
    #first add all vertices
    #first vertice is going to be v0 further vertices will be added +1
    my_chest_graph.addVertice(0)
    chests.each_index{
      |i|
      my_chest_graph.addVertice(i+1)
    }
    
    #second stage, add Edges
    my_chest_graph.getVertices.each_index{
      |i|
      #if we are on V0 then connect curent keys
      if i == 0
        
        for key in keys
          chests.each_index{ |ci|
            if chests[ci].unlockKey == key
              my_chest_graph.addEdge(i,ci+1) #perform union
              break
            end
          }
        end
      else
        for key in chests[i-1].getKeys
          chests.each_index{ |ci|
            if chests[i-1].unlockKey == key
              my_chest_graph.addEdge(i,ci+1) #perform union
            end
          }
        end
      end
    }
    #possible is false, now check if al points are connected to v0
    for i in my_chest_graph.getVertices
      if(i!=0)
        temp = my_chest_graph.isConnected(0,i)
        if temp == false
          possible = false
          break
        end
      end
    end
    #termino chingon
    return possible
    chests.each_index { 
      |i| # i being the index

      # get chests this dude can open
      _ckeys = chests[i].getKeys
      _ckeys = _ckeys.uniq #compact the keys
      joins = []
      
      for k in _ckeys
        chests.each_index { |j|
          if chests[j].unlockKey == k
            joins.push(j)
          end
        }
      end
      for k in joins
        graph.push([i.to_s.to_sym,k.to_s.to_sym,10])
      end
    }

    # g = Graph.new(graph)
    # nice = true 

    # chests.each_index{ |i|
    
    #   if graph == nil || graph[i] == nil
    #     return false
    #   end
    #   start,stop = graph[0][0],graph[i][0]
      
    #   path , dist = g.shortest_path(start,stop)
    #   if dist.to_s == "Infinity" 
    #     return false
    #   end
    # }
   
    # puts "shortest path from #{start} to #{stop} has cost #{dist}:"
    # puts path.join(" -> ")
    
 
    if chests.length==0
      return true
    elsif keys.length == 0 && chests.length > 0    
      return false
    else

      #create quick key array
      quick_key = []
      all_keys = []
      unlocks_left = []
      for chest in chests
        _tuk = chest.unlockKey()
        quick_key.push(_tuk)
        all_keys.push(_tuk)
      end
      quick_key = quick_key.uniq
      
      #store counts for quick access
      for elem in quick_key
        unlocks_left[elem] = all_keys.count(elem) #counter is stored in index as value
      end

      chest_index = 0
      stuck_counter = 0
      for chest in chests
        new_keys = keys.clone
        k = chest.unlockKey()        
        #for k in keys
        if new_keys.include?(k) == true
          
          
          count = new_keys.find_index(k)          
          #puts "k is #{k} the count index is #{count}"
          new_array = chests.clone
          new_array.delete_at(chest_index)
          new_keys.delete_at(count)
          chest.open(k)
          new_keys = new_keys + chest.getKeys
          intersect = new_keys.clone
          intersect -= quick_key
          new_keys -= intersect
          chest.close()
          #check next
          if chests[chest_index+1]!=nil
            next_i = 1
            next_uk = chests[chest_index+next_i].unlockKey
            fixed_i = chest_index
            
            while unlocks_left[next_uk] < new_keys.count(next_uk) && new_array.length > 1
              if chests[chest_index+next_i]!= nil
                next_uk = chests[chest_index+next_i].unlockKey                
                new_array.delete_at(fixed_i) # mismio indice
                chests[chest_index+next_i].open(next_uk)
                if new_keys.find_index(next_uk) == nil
                  return false
                end
                new_keys.delete_at(new_keys.find_index(next_uk))
                new_keys += chests[chest_index+next_i].getKeys
                chests[chest_index+next_i].close()
                
                chest_index+=next_i
                unlocks_left[next_uk]-=1
                #check if stuck
              end
            end
          end
          if isPossibleRec(new_keys,new_array) == true
            #possible
            #puts "Its posible!:"
            print "current keys: #{keys}\nCurrent chests:#{chests.length}\n"
            return true
          else
            # puts "Dio false y revisando nuevas cosas"
            stuck_counter+=1
            puts "Stuck counter #{stuck_counter} - number of chests #{chests.length}"
            if(stuck_counter>=chests.length)
              return "IMPOSSIBLE";
            end
          end
          #end for k
          chest_index+=1
        end
      end
    return false
  end
    end

  #Search Logic 
  def search()
    total_n_chests = @N.length
    chests = @N.clone #clone object and preserve original arrangement of chests
    av_keys = @keys.clone #clone set of keys and preserve original arrangement of keys
    opened_chests = 0
    number_of_keys = av_keys.length

    #puts "Keys obtained #{av_keys}"
    
    
    for chest in chests do 
      if chest.countKeys != nil
        number_of_keys += chest.countKeys
      end
    end
    
    #puts "Total number of keys #{number_of_keys}\nTotal number of chests #{chests.length}"
    
    #First Check, check if we have enough keys to open all the chests
    if number_of_keys < total_n_chests
      #it's impossible to open them all
      return "IMPOSSIBLE"
    end

    # if number_of_keys >= total_n_chests
    #attempt
    #create def attempt
    first_order =*(0..(chests.length-1))
    #first_order[1],first_order[6] = first_order[6],first_order[1]
    temp_c = chests.clone
    temp_k = av_keys.clone
    swap_count = 0
    start_point = 0
    temp_c2 = 0
    solution = []
    pending = [] #array to save pending startpoints
    
    pos = isPossibleRec(av_keys,chests)
    puts "first is it possible? #{pos}"
    if pos == "IMPOSSIBLE"
      return pos
    end
   # puts "is it possible? #{pos} "
    
    position = 0
    c_first = 0
    while first_order.length > 0
      
      if c_first > first_order.length
        return "IMPOSSIBLE"
      end
      match = false
      for c in chests

        if c_first  >  chests.length
          return "IMPOSSIBLE"
        end
        test_keys = av_keys.clone
        test_chest = chests.clone
        
        if c_first < test_chest.length
          uk = test_chest[c_first].unlockKey()
        else
          c_first = 0
          uk = test_chest[c_first].unlockKey()
        end
        k_counter=0
        #for k in test_keys
          if test_keys.include?(uk)
            k = uk
            test_chest[c_first].open(k)
            test_keys.delete_at(k_counter)
            test_keys+=test_chest[c_first].getKeys
            test_chest.delete_at(c_first)
            k_counter+=1
          end
        #end
          #print "Test chests #{test_chest.length}\n"
        if test_chest.length < chests.length && isPossibleRec(test_keys,test_chest) == true
          match = true
          av_keys = test_keys
          chests = test_chest
          #puts "current solution #{solution}"        
          solution.push(first_order[c_first])
          first_order.delete_at(c_first)
          c_first = 0
        else
          c_first+=1
        end
      end
      if match == false
        return "IMPOSSIBLE"
      end
      
      #puts "solution #{solution}"
      
    end

   
    return solution
    
  end  # end while of attempts 
  
  
  def toString()
    return output
  end
  
end 


class Chest
  
  def forceOpen()
    @isClosed = false
  end

  def printStatus()
    puts "Created chest unlockable with #{@unlock}"
    puts "And also contains these keys \n#{@keys}"  
  end

  def initialize(u,k)
    @unlock = u
    @keys = k
    @isClosed = true
  end

  def unlockKey()
    return @unlock
  end

  def toString()
    result = "Chest:\nUnlockable with:#{@unlock}"+
      "\nKeys inside:#{@keys}\nIsClosed:{#@isClosed}"
    return result
  end

  def countKeys()
    if @keys != nil
      return @keys.length
    else
      return 0
    end
  end

  # If chest is open might return keys
  # returns nil if closed or not keys in this chest
  def getKeys()
    # if @isClosed == false
      if @keys.length == 0
        return []
      else
        return @keys
      end
    #else
    # return []
    #end
  end
  
  def close()
    @isClosed = true
  end

  def open(key)
    if @unlock == key
      @isClosed = false
      return true #success
    else
      return false #not successful
    end
  end
  
  def isClosed()
    return @isClosed
  end
  
  def isOpen()
    return !@isClosed
  end
  
end

class Array
  def swap(a,b)
    self[a],self[b] = self[b],self[a]
  end
end
