module KindlePras
  module Outputter

    extend self


    def print_books_list(books)
      formatted_title = -> (title, author, i) {
        <<~OUTPUT
        Idx:    #{i}
        Book:   #{title}
        Author: #{author}
        -------
        OUTPUT
      }
      books
        .sort_by { |k, _| k }
        .each_with_index { |(title, author), i|
          puts formatted_title.call(title, author, i)
        }
    end


    def print_book_notes(title:, author:, notes:, short_name:, preview:)
      if notes.empty?
        warn "No highlights found for the given book!"
        return
      end

      Dir.mkdir('output') unless Dir.exists?('output')
      fname = "output/#{today}-#{short_name}.markdown"

      io = preview ? STDOUT : File.open(fname, 'w')

      io.puts metadata(title: title, author: author) unless preview
      notes.each { |n| io.puts("#{n}\n\n") }

      unless preview
        io.close
        puts "Notes extracted and saved in file: '#{fname}'"
      end
    end


    private def metadata(title:, author:)
      <<~STR
      ---
      kind: article
      created_at: #{today}
      title: "#{title} - by #{author}"
      unsplash: []
      ---

      READ: #{today}, RATING: XX/10

      <!--summary-and-lessons-i-learned-->

      See [__Goodreads Page__](XXXX) for reviews.

      ## My Highlights
      STR
    end


    private def today
      @_today ||= Time.now.strftime("%Y-%m-%d")
    end


  end
end

