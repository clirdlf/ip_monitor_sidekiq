# frozen_string_literal: true

class Sleeper
  @queue = :sleep

  def self.perform(seconds)
    sleep(seconds)
  end
end
