#!/usr/bin/env ruby

require 'Nokogiri'
require 'pp'

xml_file = ARGV[0]
puts 'Loading XML document'

@result = {}

def clean_and_load_document(file_name)
  content = File.open(file_name, "r").read
  return Nokogiri::XML(content.gsub(/>\n\s*</, "><"))
end

def parse_node(node, path)
  path = path + '/' + node.name
  if node.children.count == 0 && node.content.length > 0 then
    @result[path] = {:document_occurences => 0} unless @result[path] != nil
    @result[path][:example_value] = (node.content) unless @result[path][:example] != nil
    @result[path][:document_occurences] += 1
  else
    node.children.each { |child| parse_node(child, path) }
  end
end

doc = clean_and_load_document(xml_file)
parse_node(doc.root, '/')
puts 'done'

pp @result
