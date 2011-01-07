watch( 'examples/.*\.haml' )  {|md| system("haml #{md[0]} #{md[0].gsub(/haml$/,'html')}") }
