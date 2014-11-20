class Task < ActiveRecord::Base

  define_index do
    indexes :name
  end

end