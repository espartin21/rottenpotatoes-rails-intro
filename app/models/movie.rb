class Movie < ActiveRecord::Base
    @all_ratings = ['G', 'PG', 'PG-13', 'R']

    def self.all_ratings
        return @all_ratings
    end
end
