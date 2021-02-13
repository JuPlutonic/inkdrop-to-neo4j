require 'kramdown'

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

    inkdrop[:tags].map! { |tag| { id: tag['_id'], title: tag['name'] } }
    inkdrop[:books].map! { |book| { id: book['_id'], parent_id: book['parentBookId'], title: book['name'] } }
    inkdrop[:notes].map! do |note|
      {
        id: note['_id'],
        title: note['title'],
        tags: note['tags'],
        book_id: note['bookId'],
        body: note['body'],
        nested_notes: note['body'].match(/\(inkdrop:\/\/note[[:punct:]](.+)\)/).captures
      }
    end

    # require 'debug'
    # Push n <enter> n <enter> n <enter> and debugging cursor will be placed
    # on `inkdrop` line beyond the comments.
    # Then push l and <enter> button and write
    # noteN = inkdrop[:notes][N] − where Ns is
    # a number (it must be a note where you see `inkdrop://note` link/links).
    #
    # To debug nested_notes urls, write − noteN[:body].match(/\(inkdrop:\/\/note[[:punct:]](.+)\)/)
    #
    # Method #to_hash_ast is to tough to use it to get aimed nested hash
    #
    # If you always use a related_notes template
    # you must change the inkdrop[:notes] here above the comments
    # Use note['body'].split('TEMPLATE TEXT FOR RELATED NOTES').first −
    # for first of nested_notes links and note['body']
    # .split('TEMPLATE TEXT FOR RELATED NOTES').last − for related_notes link from a template.

    inkdrop
  end
end
