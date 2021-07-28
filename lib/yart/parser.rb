# frozen_string_literal: true

module YART::Parser
  def parse(&block)
    raise "Must pass a block to render HTML" unless block_given?

    @@yart_buffer = []
    instance_eval(&block)
    @@yart_buffer.join
  end

  def method_missing(m, *args, &block)
    attributes = args.fetch(0, {})
    raise "The element attributes must be a Hash" unless attributes.is_a?(Hash)

    render(m, attributes, &block)
  end

  private

  # Renders an element with the raw name (doesn't have to be lowercase).
  def element(name, **attributes, &block)
    render(name, attributes, &block)
  end

  # Sets the innerText of the element being rendered.
  def text(&block)
    str = block.call
    raise "text's block must return a String" unless str.is_a?(String)

    str
  end

  # Override Ruby's p method to render the element instead of printing.
  def p(**attributes, &block)
    render("p", **attributes, &block)
  end

  def render(element, attributes, &block)
    @@yart_buffer << build_opening_tag(element, attributes)
    @@yart_buffer << instance_eval(&block) if block_given?
    @@yart_buffer << "</#{element}>"
  end

  def build_opening_tag(element, attributes)
    attributes = convert_attributes(attributes)
    html_attributes = attributes.
      map {|k, v| "#{k}='#{v}'" }.
      join(" ")
    separator = html_attributes.empty? ? "" : " "

    "<#{element}#{separator}#{html_attributes}>"
  end

  def convert_attributes(attributes)
    attributes.map do |k, v|
      k = kebab_case(k)
      v = v.respond_to?(:each) ?
        v.map { |v2| convert_attribute_value(v2) }.join(" ") :
        convert_attribute_value(v)

      [k, v]
    end.to_h
  end

  def convert_attribute_value(value)
    value = kebab_case(value)
    value = replace_illegal_chars(value)

    value
  end

  def kebab_case(s)
    return s unless s.is_a?(Symbol)

    s.to_s.gsub("_", "-").to_sym
  end

  def replace_illegal_chars(s)
    return s unless s.is_a?(String)

    s
      .gsub('"', "&quot;")
      .gsub("'", "&#39;")
      .gsub("<", "&lt;")
      .gsub(">", "&gt;")
  end
end
