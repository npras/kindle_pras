module KindlePras
  module Outputter

    extend self


    def print_books_list(books)
      books
        .sort_by { |k, _| k }
        .each_with_index { |(title, author), i|
        puts formatted_title(title, author, i)
      }
    end


    def print_book_notes(notes)
      notes.each do |note|
        puts note
        puts
      end
    end


    def formatted_title(title, author, i)
      output = <<~OUTPUT
      Idx:    #{i}
      Book:   #{title}
      Author: #{author}
      -------
      OUTPUT
    end


  end
end

