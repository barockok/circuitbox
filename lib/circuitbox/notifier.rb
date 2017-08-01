class Circuitbox
  class Notifier
    def initialize(service)
      @service = service
    end

    def notify(event, meta={})
      return unless notification_available?
      data = {circuit: circuit_name}
      data[:meta] = meta
      ActiveSupport::Notifications.instrument("circuit_#{event}", data)
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
