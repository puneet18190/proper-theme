# == Schema Information
#
# Table name: testimonials
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  title       :string(255)
#  testimonial :text
#  t_date      :date
#  user_type   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class TestimonialTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
