# L numero de letras en minusculas
# D es el numero de palabras

filename = ARGV.first
file = File.open(filename)

numeros = file.readline.split.map(&:to_i)
L = numeros[0]
D = numeros[1]
N = numeros[2]

diccionario = []

for i in (0..D-1) do

  diccionario.push(file.readline.chomp)

end


salida = File.open("r.out","w")

for j in (0..N-1)
  line = file.readline.chomp
  # Expresiones regulares - regex
  line = line.gsub(/[(]/,"[") #[]
  line = line.gsub(/[)]/,"]")

  regex = Regexp.new line

  coincidencias = 0
  for palabra in diccionario do
    #palabra  - [asbp]alabra
    if palabra =~ regex
      coincidencias+=1
    end
  end
  output = "Case ##{j+1}: #{coincidencias}\n"
  salida.write(output)

end
salida.close
