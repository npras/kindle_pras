module KindlePras
  class Processor


    DEFAULT_PATH = 'data/My Clippings.txt'

    REGEXP_CHUNK_DELIMITER = /^==========$/
    REGEXP_TITLE_AUTHOR_LINE = /^(?<title>.*).*\((?<author>.*?)\)$/
    REGEXP_NOTE_IDENTIFIER = /Your Note on Location/


    def initialize(opts)
      @opts = opts
      @file_path = @opts[:file_path] || DEFAULT_PATH

      p @opts
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
      chunk = ''
      File.foreach(@file_path) do |line|
        if line.chomp.match?(REGEXP_CHUNK_DELIMITER)
          yield(chunk)
          chunk = ''
        else
          chunk << line
        end
      end
    end


    def list_books
      books = {}

      read_chunks do |chunk|
        line =  chunk.split("\r\n").first
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
      read_chunks do |chunk|
        next if chunk.match?(REGEXP_NOTE_IDENTIFIER)
        line =  chunk.split("\r\n").first
        md = line.match(REGEXP_TITLE_AUTHOR_LINE)
        if md&.[](:title)&.downcase&.match?(regexp_book_title)
          highlight = chunk.split("\r\n").last
          puts highlight
          puts
        end
      end
    end


    def delete_book(regex_book_title)
    end


  end
end

