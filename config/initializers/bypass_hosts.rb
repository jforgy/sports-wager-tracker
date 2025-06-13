# Completely bypass Rails host authorization
Rails.application.config.after_initialize do
  ActionDispatch::HostAuthorization.prepend(Module.new do
    def call(env)
      @app.call(env)
    end
  end)
end