gem "minitest"

require "minitest/autorun"
require "minitest/hooks/default"

class Minitest::HooksSpec
  around(:all) do |&block|
    DB.transaction(rollback: :always) { super(&block) }
  end

  around do |&block|
    DB.transaction(rollback: :always, savepoint: true, auto_savepoint: true){super(&block)}
  end

  def log
    LOGGER.level = Logger::INFO
    yield
  ensure
    LOGGER.level = Logger::FATAL
  end
end
