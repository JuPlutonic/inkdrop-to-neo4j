class ParseInkdropBackupFolder
  def call(path)
    files = Dir.glob(path).map do |file_name|
      JSON.parse(File.read(file_name))
    end

    inkdrop = {
      notes: [],
      tags: [],
      books: []
    }

    files.each do |file|
      case file['_id'].split(':')
        in ['note', _id]
          inkdrop[:notes] << file
        in ['tag', _id]
          inkdrop[:tags] << file
        in ['book', _id]
          inkdrop[:books] << file
      else
        # nothing
      end
    end

    inkdrop
  end
end
