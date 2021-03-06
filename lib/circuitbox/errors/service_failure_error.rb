class Circuitbox
  class ServiceFailureError < Circuitbox::Error
    attr_reader :service, :original

    def initialize(service, exception)
      @service = service
      @original = exception
      # we copy over the original exceptions backtrace if there is one
      set_backtrace(exception.backtrace) unless exception.backtrace.empty?
    end

    def to_s
      "#{self.class.name} wrapped: #{original}"
    end
  end
end
