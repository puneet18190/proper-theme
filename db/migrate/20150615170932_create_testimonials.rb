class CreateTestimonials < ActiveRecord::Migration
  def change
    create_table :testimonials do |t|
      t.string :name
      t.string :title
      t.text :testimonial
      t.date :t_date
      t.string :user_type

      t.timestamps
    end
  end
end
