require "./chest_graph.rb"

x = Vertex.new(1)
y = Vertex.new(2)
z = Vertex.new(3)
a,b,c = Vertex.new(4),Vertex.new(5),Vertex.new(6)

x.setPathTo(y)
y.setPathTo(z)
y.setPathTo(a)
z.setPathTo(a)
z.setPathTo(c)
a.setPathTo(c)
a.setPathTo(b)
b.setPathTo(x)

if a.isConnectedWith(x,[])
  puts "Hell yeah it is connected!!"
end

