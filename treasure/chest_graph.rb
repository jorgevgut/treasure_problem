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
    @NVertices+=1
  end

  def addEdge(a,b)
    @Edges.push([a,b])
    #b will have a as father
    @roots[b] = a
    @NEdges +=1
  end

  # Returns true if a possible path exist between A and B
  def isConnected(a,b)
    result = false
    while @roots[a] != @roots[b]
      if temp_root == @roots[b]
        return false
      end
      temp_root = @roots[b]
      @roots[b] = @roots[temp_root]
      result = true
    end
    return result
  end

end
