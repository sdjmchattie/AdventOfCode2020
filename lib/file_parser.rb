class FileParser

  attr_reader :file_name

  def initialize(file_name)
    self.file_name = file_name
  end

  def read_chunked_data
    File.readlines(self.file_name).map(&:strip).slice_before('').map do |chunk|
      chunk.drop(1).join(' ')
    end
  end

private

  attr_writer :file_name

end
