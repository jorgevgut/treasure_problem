require "./chest_graph.rb"

g = CGraph.new

g.addVertice(0)
g.addVertice(1)
g.addVertice(2)
g.addVertice(3)

g.addEdge(0,3)
g.addEdge(1,3)

puts g.to_s

#check connections
puts g.isConnected(0,1)
