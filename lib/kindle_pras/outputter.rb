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


    def print_book_notes(title:, author:, notes:, short_name:, rating:, isbn:)
      if notes.empty?
        warn "No highlights found for the given book!"
        return
      end

      Dir.mkdir('output') unless Dir.exists?('output')
      fname = "output/#{today}-#{short_name}.markdown"

      File.open(fname, 'w') do |f|
        f.puts metadata(title: short_name, rating: rating, isbn: isbn)
        notes.each { |n| f.puts("#{n}\n\n") }
      end

      puts "Notes extracted and saved in file: '#{fname}'"
    end


    private def formatted_title(title, author, i)
      output = <<~OUTPUT
      Idx:    #{i}
      Book:   #{title}
      Author: #{author}
      -------
      OUTPUT
    end


    private def metadata(title:, rating:, isbn:)
      <<~STR
      ---
      layout: post
      title: #{title}
      ---

      ISBN: #{isbn}, READ: #{today}, RATING: #{rating}/10

      <!--summary-->

      <!--more-->

      See [Amazon Page]() for details and reviews.

      ## Key Takeaways For Me
      
      ## My Notes
      STR
    end


    def today
      @_today ||= Time.now.strftime("%Y-%m-%d")
    end


  end
end

