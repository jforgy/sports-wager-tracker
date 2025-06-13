# Ensure database exists in production
if Rails.env.production?
  begin
    ActiveRecord::Base.connection.execute("SELECT 1")
  rescue
    # Database doesn't exist, create it
    Rails.logger.info "Creating database..."
    ActiveRecord::Tasks::DatabaseTasks.create_current
  end
end