# frozen_string_literal: true

module YART::Parser
  CUSTOM_ATTRIBUTES = [:close]

  # Parses a block of Ruby, rendering and returning a HTML String.
  def parse(&block)
    raise "Must pass a block to parse" unless block_given?

    @@yart_buffer = []
    instance_eval(&block)
    @@yart_buffer.join
  end

  # Allows elements to be called and rendered via a DSL.
  def method_missing(m, *args, &block)
    attributes = args.fetch(0, {})

    render(m, attributes, &block)
  end

  # Renders an element with the raw name (case insensitive).
  def element(name, **attributes, &block)
    render(name, attributes, &block)
  end

  # Renders a <!DOCTYPE html> element, for convenience.
  def doctype
    element("!DOCTYPE", html: true, close: true)
  end

  # Renders a JS <script src="..."> element, for convenience.
  def script(src = nil, &block)
    raise "Must pass a String param or a block returning a String" unless src || block_given?

    src ||= block.call
    element("script", src: src, close: true)
  end

  # Renders a CSS <link href="..."> element, for convenience.
  def stylesheet(href = nil, &block)
    raise "Must pass a String param or a block returning a String" unless href || block_given?

    href ||= block.call
    element("link", href: href, rel: :stylesheet, type: "text/css", close: true)
  end

  # Overrides Ruby's `p` method to render the element instead of printing.
  def p(**attributes, &block)
    render("p", attributes, &block)
  end

  # Sets the `innerText` of the element being rendered.
  def text(str = nil, &block)
    raise "Must pass a String param or a block returning a String" unless str || block_given?

    str ||= block.call
    buffer(str)
  end

  private

  def buffer(str)
    @@yart_buffer << str if str.is_a?(String)
  end

  def render(element, attributes, &block)
    raise "Must pass attributes as a Hash" unless attributes.is_a?(Hash)

    buffer(build_opening_tag(element, attributes))
    buffer(instance_eval(&block)) if block_given?
    buffer(build_closing_tag(element, attributes))
  end

  def build_opening_tag(element, attributes)
    attributes_str = sanitise_attributes(attributes)
      .reject { |k, v| CUSTOM_ATTRIBUTES.include?(k) }
      .map { |k, v| v == true ? k.to_s : "#{k}='#{v}'" }
      .join(" ")
    separator = attributes_str.empty? ? "" : " "

    "<#{element}#{separator}#{attributes_str}>"
  end

  def build_closing_tag(element, attributes)
    attributes[:close] ? "" : "</#{element}>"
  end

  def sanitise_attributes(attributes)
    attributes.map do |k, v|
      k = kebab_case(k)
      v = v.respond_to?(:map) ?
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

    s
      .to_s
      .gsub("_", "-")
      .to_sym
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
