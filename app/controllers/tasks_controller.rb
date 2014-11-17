class TasksController < ApplicationController
  def index
    @tasks= Property.all
  end
end
