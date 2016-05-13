class Trie
  def initialize
    @root = Node.new('a')
  end

  def insert_or_update(key : String)
    unless key.empty?
      push_recursive(@root, key, 0)
      key
    end
  end

  private def push_recursive(node : Node, string, index)
    char = string[index]

    child = node.find_child(char)

    if child.nil?
      child = node.add_child(char, Node.new(char))
    end

    if index < string.size - 1
      node.update_child(char, push_recursive(child, string, index + 1))
    else
      child.end = true
      child.increment
    end

    node
  end

  def has_key?(key : String)
    !get_recursive(@root, key, 0).nil?
  end

  def get(key : String)
    get_recursive(@root, key, 0).try &.value
  end

  def [](key : String)
    get(key)
  end

  private def get_recursive(node : Node, string, index)
    if node
      char = string[index]

      child = node.has_child(char) ? node.find_child(char) : nil
      return nil if child.nil?

      if index < string.size - 1
        get_recursive(child, string, index + 1)
      else
        if child.last?
          child
        else
          nil
        end
      end
    end
  end

  def each(&block : Tuple(String, Int32) -> Int32)
    each_recursive(@root, "", &block)
  end

  private def each_recursive(node : Node, prefix, &block : Tuple(String, Int32) -> Int32)
    if node
      if node.last?
        yield Tuple(String, Int32).new(prefix.nil? ? node.char.to_s : prefix + node.char, node.value)
      else
        new_prefix = prefix.nil? ? node.char.to_s : prefix + node.char unless node == @root
        node.children.each do |entry|
          each_recursive(entry.last, new_prefix, &block)
        end
      end
    end
  end

  # private
  class Node
    getter :char
    getter :value
    getter :children
    property :end

    def initialize(@char : Char)
      @children = Array(Tuple(Char, Node)).new
      @value = 0
      @end = false
    end

    def find_child(char)
      @children.each { |child| return child.last if child.first == char }
      return nil
    end

    def has_child(char)
      !find_child(char).nil?
    end

    def add_child(char, node)
      @children << {char, node}
      node
    end

    def update_child(char, node)
      index = -1
      @children.each_with_index do |child, i|
        if child.first == char
          index = i
          break
        end
      end

      if index > -1
        @children[index] = {char, node}
      else
        @children << {char, node}
      end
    end

    def increment
      @value += 1
    end
  
    def last?
      @end == true
    end
  end
end
