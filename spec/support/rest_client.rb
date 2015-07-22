module RestClient
  def self.get(*_args)
    { foo: 'bar' }.to_json
  end

  def self.post(*_args)
    { foo: 'bar ' }.to_json
  end

  def self.put(*_args)
    { foo: 'bar ' }.to_json
  end

  def self.delete(*_args)
    { foo: 'bar ' }.to_json
  end
end
