require 'graphviz'

class Giraffe
  
  PARTIAL_REGEX = /render\W+:partial\W+=>\W+"([\w\/]+)"/
  
  def self.generate(path, outfile)
    new(path).generate(outfile)
  end
  
  def initialize(path)
    @path  = path
    @graph = GraphViz.new(:G, :type => :digraph)
    @nodes = {}
  end
  
  def generate(outfile)
    Dir.chdir(@path) do
      Dir.glob("**/*.*").each do |file|
        parse_file(file)
      end
    end
    write_graph(outfile)
  end
  
  def write_graph(outfile)
    @graph.output( :png => outfile )      
  end
  
  def parse_file(path)
    File.open(path, 'r').each_line do |line|
      if match = line.match(PARTIAL_REGEX)
        add_edge(normalize(path), find_template(partial_path(path, match[1])))        
      end
    end
  end
  
  private
  
  def partial_path(container, partial)    
    unless partial.include? "/"
      normalize(File.join(File.dirname(container), "_#{partial}"))
    else
      normalize(File.join(File.dirname(partial), "_#{File.basename(partial)}"))
    end    
  end
  
  def normalize(path)
    File.expand_path(path, "/")
  end
  
  def find_template(name)
    "#{name}#{template_type(name)}"
  end
  
  def template_type(name)
    full_path = File.join(@path, name)
    if template = Dir.glob("#{full_path}.*")[0]
      template.match(/(\..+$)/)[1]
    end
  end
  
  def add_edge(template, partial)
    @graph.add_edge(add_node(template), add_node(partial))
  end
  
  def add_node(path)
    @nodes[path] ||= @graph.add_node(path)
  end
  
end