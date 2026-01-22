# Gracefully handle connection errors during SolidQueue process deregistration
# This prevents "Too many connections" errors from crashing the shutdown process
if defined?(SolidQueue) && defined?(SolidQueue::Process)
  module SolidQueueGracefulShutdown
    def deregister
      instrument("deregister.solid_queue.process") do
        destroy!
      end
    rescue ActiveRecord::ConnectionNotEstablished, ActiveRecord::StatementInvalid => e
      # If we can't establish a connection during shutdown, log it but don't crash
      # The process will be cleaned up by the supervisor's stale process cleanup
      Rails.logger.warn("Could not deregister SolidQueue process #{id} during shutdown: #{e.message}")
    rescue StandardError => e
      # Log other errors but don't crash shutdown
      Rails.logger.error("Error deregistering SolidQueue process #{id}: #{e.class} #{e.message}")
      Rails.logger.error(e.backtrace.join("\n")) if Rails.env.development?
    end
  end

  SolidQueue::Process.prepend(SolidQueueGracefulShutdown)
end
