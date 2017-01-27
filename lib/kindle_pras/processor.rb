module KindlePras
  class Processor


    DEFAULT_PATH = 'data/My Clippings.txt'

    REGEXP_CHUNK_DELIMITER = '=========='
    REGEXP_TITLE_AUTHOR_LINE = /^(?<title>.*).*\((?<author>.*?)\)$/
    REGEXP_NOTE_CHUNK = /Your Note on Location/
    REGEXP_BOOKMARK_CHUNK = /Your Bookmark on Location/


    def initialize(opts)
      @opts = opts
      @file_path = @opts[:file_path] || DEFAULT_PATH
    end


    def do_the_work!
      if @opts[:list_books]
        list_books
      elsif @opts[:extract_book]
        extract_book(@opts[:extract_book])
      elsif @opts[:delete_book]
        delete_book(@opts[:delete_book])
      end
    end


    def read_chunks
      File.foreach(@file_path, REGEXP_CHUNK_DELIMITER) do |raw_chunk|
        chunk = raw_chunk.gsub(/#{REGEXP_CHUNK_DELIMITER}$/, '').strip
        yield(chunk)
      end
    end


    def list_books
      books = {}

      read_chunks do |chunk|
        line =  chunk.split("\r\n").first
        next if line.nil?
        md = line.match(REGEXP_TITLE_AUTHOR_LINE)
        if md
          books[md[:title]] = md[:author]
        else
          books[line.strip] = nil
        end
      end

      KindlePras::Outputter.print_books_list(books)
    end


    def extract_book(regexp_book_title)
      highlights = []

      read_chunks do |chunk|
        next if [REGEXP_NOTE_CHUNK, REGEXP_BOOKMARK_CHUNK].any? {|r| chunk.match?(r)}
        line =  chunk.split("\r\n").first
        next if line.nil?
        md = line.match(REGEXP_TITLE_AUTHOR_LINE)
        if md&.[](:title)&.downcase&.match?(regexp_book_title)
          highlights << chunk.split("\r\n").last
        end
      end

      KindlePras::Outputter.print_book_notes(highlights)
    end


    def delete_book(regex_book_title)
    end


  end
end

