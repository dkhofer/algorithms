require "spec"
require "../src/trie"

describe "Trie" do
  it "puts and gets" do
    t = Trie.new
    t.insert_or_update("foo")
    t["foo"].should eq 1

    t["baz"].should eq nil

    t.insert_or_update("foo")
    t["foo"].should eq 2
  end

  it "iterates over each leaf node" do
    t = Trie.new
    t.insert_or_update("foo")
    t.insert_or_update("baz")
    t.insert_or_update("abc")
    t.insert_or_update("abd")
    t.insert_or_update("foo")

    result = Hash(String, Int32).new
    t.each do |pair|
      result[pair.first] = pair.last
    end

    result.size.should eq 4
    result["foo"].should eq 2
    result["abc"].should eq 1
  end
end
