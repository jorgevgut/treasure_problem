class Cgraph

  def initialize()
    @roots = []
    @vertices = []
    @edges = []
    @Nvertices = 0
    @NEdges = 0
    
  end
  
  def new()
  end
  
  def getVertices()
    return @vertices
  end
  
  def addVertice(i)
    @vertices.push(i)
    @roots.push(i) # element's root is itself
    @Nvertices+=1
  end

  def addEdge(a,b)
    @edges.push([a,b])
    #b will have a as father
    
    @roots[getRoot(a)] = getRoot(b) 

    @NEdges +=1
  end

  def getRoot(i)
    while i !=  @roots[i] do
      i = @roots[i]
    end
    return i
  end

  # Returns true if a possible path exist between A and B
  def isConnected(a,b)
    if getRoot(a) == getRoot(b)
      return true
    else
      return false
    end
  end

  def to_s
    return "Vertices:#{@vertices}\nEdges:#{@edges}\nRoots:#{@roots}\n"
  end

end

class Vertex 

  def initialize(id)
    @id = id
    @pointsTo = []
  end

  def getId
    return @id
  end

  # set a path from this vertex to another vertex
  def setPathTo(vertex)
    included = false
    for v in @pointsTo
      if(v.getId == vertex.getId)
        included = true
        break
      end
    end
    if included == false
      @pointsTo.push(vertex)
    end
    
  end
  # use to get the IDs of other vertexes to which you can get from here
  def getPaths
    return @pointsTo
  end

  # usage set visited as empty array
  # ex. vertexSomething.isConnectedWith(Vertex2,[])
  def isConnectedWith(vertex,visited)
    # determines wether there is a path or no
    found = false #at the begining you stil haven't found a connection
    prev = @id #previous is always it self
    if visited.include?(@id) == false
      puts "Not visited yet"
      visited.push(@id)
      targetId = vertex.getId
      for element in self.getPaths
        currentId = element.getId
        # found the path
        if currentId  == targetId
          return true
          break
       # elsif
          # if !visited.include?(currentId)
          #   visited.push(currentId)
          # end
        end
      end
      #didn't found adjacent
      for elem in self.getPaths
        
        if elem.isConnectedWith(vertex,visited)
          return true
        end
      end
    end
      return false
  end


end
