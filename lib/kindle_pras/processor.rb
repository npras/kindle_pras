module KindlePras
  class Processor


    DEFAULT_PATH = 'data/My Clippings.txt'
    #DEFAULT_PATH = 'data/My Clippings.txt.sample'

    REGEXP_CHUNK_DELIMITER = '=========='
    REGEXP_TITLE_AUTHOR_LINE = /^(?<title>.*).*\((?<author>.*?)\)$/
    REGEXP_NOTE_CHUNK = /Your Note on Location/
    REGEXP_BOOKMARK_CHUNK = /Your Bookmark on Location/


    def initialize(opts)
      @opts = opts
    end


    def do_the_work!
      if @opts[:list_books]
        list_books
      elsif @opts[:extract_book]
        extract_book(@opts[:extract_book])
      end
    end


    private def list_books
      books = {}

      read_chunks do |chunk|
        line =  chunk.split("\r\n").first
        next if line.nil?
        md = line.match(REGEXP_TITLE_AUTHOR_LINE)
        if md
          books[md[:title].strip] = md[:author].strip
        else
          books[line.strip] = nil
        end
      end

      KindlePras::Outputter.print_books_list(books)
    end


    private def extract_book(regexp_book_title)
      fail "Name needed to save the notes in a file. Pass the '-n' flag." if @opts[:name].nil? || @opts[:name].empty?

      highlights = []
      regexp_book_title = Regexp.new(regexp_book_title, 'i')
      title, author = book_title_and_author(regexp_book_title)

      read_chunks do |chunk|
        next if [REGEXP_NOTE_CHUNK, REGEXP_BOOKMARK_CHUNK].any? {|r| chunk.match?(r)}
        line = chunk.split("\r\n").first
        next if line.nil?
        md = line.match(REGEXP_TITLE_AUTHOR_LINE)
        if md&.[](:title)&.downcase&.match?(regexp_book_title)
          highlights << chunk.split("\r\n").last
        end
      end

      KindlePras::Outputter.print_book_notes(
        title: title,
        author: author,
        notes: highlights,
        short_name: @opts[:name],
        preview: @opts[:preview]
      )
    end

    
    private def read_chunks
      File.foreach(DEFAULT_PATH, REGEXP_CHUNK_DELIMITER) do |raw_chunk|
        chunk = raw_chunk.gsub(/#{REGEXP_CHUNK_DELIMITER}$/, '').strip
        yield(chunk)
      end
    end


    private def book_title_and_author(regexp_book_title)
      title, author = nil, nil
      
      read_chunks do |chunk|
        line =  chunk.split("\r\n").first
        next if line.nil?
        md = line.match(REGEXP_TITLE_AUTHOR_LINE)
        if md&.[](:title)&.downcase&.match?(regexp_book_title)
          title = md[:title].strip
          author = md[:author].strip
          break
        end
      end

      [title, author]
    end


  end
end
