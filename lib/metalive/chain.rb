class Metalive::Chain

  attr_reader :updaters

  def initialize
    @updaters = []
  end

  def add(updater, options = {})
    updater = create(updater, options) unless updater.respond_to?(:update)
    updaters << updater
    self
  end

  def create(updater, options = {})
    updater = Metalive.const_get(updater.to_s.capitalize) if String === updater or Symbol === updater
    updater.new options
  end

  def method_missing(name, *arguments, &block)
    add name, arguments.first
  end
  
  def update(metadata)
    not updaters.collect do |updater|
      updater.update(metadata)
    end.include?(false)
  end

end
