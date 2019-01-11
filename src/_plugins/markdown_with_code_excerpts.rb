require_relative 'code_excerpt_processor'

module Jekyll
  module Converters
    module MarkdownWithCodeExcerptsConverterMixin
      # Ensure subclass sets the following property:
      #
      # priority :high

      def matches(ext)
        ext =~ /^\.md$/i
      end

      def output_ext(_ext)
        '.html'
      end

    end

    class MarkdownWithCodeExcerpts
      def initialize(config = {}, code_framer = nil)
        @config = config
        @code_framer = code_framer || IdentityCodeFramer.new
      end

      def convert(content)
        @cep ||= DartSite::CodeExcerptProcessor.new(@code_framer)
        @cep.code_excerpt_processing_init
        content.gsub!(@cep.code_excerpt_regex) {
          @cep.process_code_excerpt(Regexp.last_match)
        }

        @base_conv ||= Markdown::KramdownParser.new(@config)
        @base_conv.convert(content)
      end
    end

    class IdentityCodeFramer
      def frame_code(title, classes, attrs, escaped_code, indent)
        escaped_code
      end
    end
  end
end