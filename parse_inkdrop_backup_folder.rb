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
        nested_notes: get_note_links(note['body'], 0)
        #, related_notes: get_note_links(note['body'],1)
      }
    end

    # require 'debug' # debug notes' bodies
    # Push n <enter> n <enter> n <enter> and debugging cursor will be placed
    # on `inkdrop` line beyond the comments.
    # Then push l and <enter> button and write
    # noteN = inkdrop[:notes][N] − where Ns is
    # a number (it must be a note where you see `inkdrop://note` link/links).
    # To debug in this note nested_notes links, write −
    # noteN[:body].match(/\(inkdrop:\/\/note[[:punct:]](.+)\)/).captures
    #
    # If you always use a related_notes template
    # you must change the inkdrop[:notes] here above the comments
    # Use note['body'].split('TEMPLATE TEXT FOR RELATED NOTES')[0] −
    # for first of nested_notes links and note['body']
    # .split('TEMPLATE TEXT FOR RELATED NOTES')[1] − for related_notes link from a template.

    inkdrop
  end
  private

    def get_note_links(body, part)
      results = body.split('RELATED NOTES:')[part]&.scan(/\(inkdrop:\/\/note[[:punct:]](.+)\)/)
      results ? results.map { |matched_link| "note:#{matched_link.first}" } : []
    end
end
