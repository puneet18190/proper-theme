class RubyzohosController < ApplicationController

  def index

  end

  def contact
    @con = RubyZoho::Crm::Contact.new
  end

  def con
    @con = RubyZoho::Crm::Contact.new(
        :first_name => params[:Firstname],
        :last_name => params[:Lastname],
        :email => params[:Email],
        :department => params[:Department],
        :date_of_birth => params[:Date_of_birth],
        :mobile => params[:Mobile]
    )
    @con.save
    redirect_to "/crm"
  end

  def leads
    @ld = RubyZoho::Crm::Lead.new
  end

  def ld
    @ld = RubyZoho::Crm::Lead.new(
        :first_name => params[:Firstname],
        :last_name => params[:Lastname],
        :email => params[:Email],
        :mobile => params[:Mobile],
        :phone => params[:Phone],
        :company => params[:Company]
    )
    @ld.save
    redirect_to "/crm"
  end

  def accounts
    @ac = RubyZoho::Crm::Account.new
  end

  def acc
    @ac = RubyZoho::Crm::Account.new(
        :account_owner => params[:Account_Owner],
        :account_name => params[:Account_Name],
        :account_number => params[:Account_Number],
        :phone => params[:Phone],
        :description => params[:Description],
        :industry => params[:Industry],
        :website => params[:Website]
    )
    @ac.save
    redirect_to "/crm"
  end

  def tasks
    @ts = RubyZoho::Crm::Task.new
  end

  def tsk
    @ts = RubyZoho::Crm::Task.new(
        :task_owner => params[:Task_Owner],
        :subject => params[:Subject],
        :due_date => params[:Due_date],
        :contact_name => params[:Contact_name],
        :description => params[:Description],
    )
    @ts.save
    redirect_to "/crm"
  end

  def potential
    @ts = RubyZoho::Crm::Potential.new
  end

  def pot
    @ts = RubyZoho::Crm::Potential.new(
        :potential_owner => params[:Potential_owner],
        :amount => params[:Amount],
        :potential_name => params[:Potential_name],
        :contact_name => params[:Contact_name],
        :description => params[:Description],
        :potential_Id => params[:Potential_Id],
    )
    @ts.save
    redirect_to "/crm"
  end

end
