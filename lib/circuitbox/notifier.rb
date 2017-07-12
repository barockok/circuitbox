class Circuitbox
  class Notifier
    def initialize(service)
      @service = service
    end

    def notify(event, exception=nil)
      return unless notification_available?
      meta = {circuit: circuit_name}
      meta[:exception] = exception if exception
      ActiveSupport::Notifications.instrument("circuit_#{event}", meta)
    end

    def notify_warning(message)
      return unless notification_available?
      ActiveSupport::Notifications.instrument("circuit_warning", { circuit: circuit_name, message: message})
    end

    def metric_gauge(gauge, value)
      return unless notification_available?
      ActiveSupport::Notifications.instrument("circuit_gauge", { circuit: circuit_name, gauge: gauge.to_s, value: value })
    end

    private
    def circuit_name
      @service.to_s
    end

    def notification_available?
      defined? ActiveSupport::Notifications
    end
  end
end
