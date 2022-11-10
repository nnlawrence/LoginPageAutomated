RSpec.configure do |config|
  # register around filter that captures stderr and stdout while still routing it through stdout
  config.around do |example|
    Pry.config.output = STDOUT

    $stdout = SplitIO.new
    $stderr = SplitIO.new

    example.run

    example.metadata[:stdout] = $stdout.string
    example.metadata[:stderr] = $stderr.string

    $stdout = STDOUT
    $stderr = STDERR
  end
end

# Split output to a StringIO like class to be saved to the JUnit report and still pass it through to STDOUT
class SplitIO < StringIO
  def puts(*args)
    super
    STDOUT.puts(*args)
  end

  def print(*args)
    super
    STDOUT.print(*args)
  end

  def <<(*args)
    super
    STDOUT.<<(*args)
    self
  end
end

# Force print method to route through standard output
def print(*args)
  $stdout.print(*args)
end
