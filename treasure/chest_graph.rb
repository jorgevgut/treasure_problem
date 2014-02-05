class CGraph
  
  
  def initialize()
    @roots = []
    @vertices = []
    @edges = []
    @Nvertices = 0
    @NEdges = 0
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
