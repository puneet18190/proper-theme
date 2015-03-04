class RubyzohosController < ApplicationController

  def index

  end

  def get_accounts
    @acc = RubyZoho::Crm::Account.all
  end

  def get_contacts
    @co = RubyZoho::Crm::Contact.all
  end

  def get_leads
    @le = RubyZoho::Crm::Lead.all
  end

  def get_tasks
    @ta = RubyZoho::Crm::Task.all
  end

  def get_potentials
    @po = RubyZoho::Crm::Potential.all
  end


  def contact
    @con = RubyZoho::Crm::Contact.new
  end

  def create_contact
    @con = RubyZoho::Crm::Contact.new(
        :contact_owner => params[:Contact_owner],
        :lead_source => params[:Lead_source],
        :account_name => params[:Account_name],
        :title => params[:Title],
        :first_name => params[:Firstname],
        :last_name => params[:Lastname],
        :email => params[:Email],
        :department => params[:Department],
        :mobile => params[:Mobile],
        :phone => params[:Phone],
        :home_phone => params[:Home_phone],
        :other_phone => params[:Other_phone],
        :fax => params[:Fax],
        :assistant => params[:Assistant],
        :asst_phone => params[:Asst_phone],
        :reports_to => params[:Reports_to],
        :secondary_email => params[:Secondary_email],
        :twitter => params[:Twitter],
        :mailing_street => params[:Mailing_street],
        :other_street => params[:Other_street],
        :mailing_city => params[:Mailing_city],
        :other_city => params[:Other_city],
        :mailing_state => params[:Mailing_province],
        :other_state => params[:Other_province],
        :mailing_zip => params[:Mailing_postal_code],
        :other_zip => params[:Other_postal_code],
        :mailing_country => params[:Mailing_country],
        :other_country => params[:Other_country],
        :description => params[:Description]
    )
    @con.save
    redirect_to "/crm_contact"
  end



  def leads
    @ld = RubyZoho::Crm::Lead.new
  end

  def create_lead
    @ld = RubyZoho::Crm::Lead.new(
        :lead_owner => params[:Lead_owner],
        :company => params[:Company],
        :first_name => params[:Firstname],
        :last_name => params[:Lastname],
        :email => params[:Email],
        :phone => params[:Phone],
        :fax => params[:Fax],
        :mobile => params[:Mobile],
        :lead_source => params[:Lead_source],
        :lead_status => params[:Lead_status],
        :industry => params[:Industry],
        :annual_revenue => params[:Annual_revenue],
        :rating => params[:Rating],
        :twitter => params[:Twitter],
        :secondary_email => params[:Secondary_email],
        :street => params[:Street],
        :city => params[:City],
        :website => params[:Website],
        :state => params[:Province],
        :zip_code => params[:Postal_code],
        :country => params[:Country],
        :description => params[:Description]

    )
    @ld.save
    redirect_to "/leads"
  end

  def accounts
    @ac = RubyZoho::Crm::Account.new
  end

  def create_account
    @ac = RubyZoho::Crm::Account.new(
        :account_owner => params[:Account_Owner],
        :rating => params[:Rating],
        :account_name => params[:Account_Name],
        :account_number => params[:Account_Number],
        :account_site => params[:Account_site],
        :parent_account => params[:Parent_account],
        :website => params[:Website],
        :phone => params[:Phone],
        :fax => params[:Fax],
        :ticker_symbol => params[:Ticker_Symbol],
        :account_type => params[:Account_type],
        :ownership => params[:Ownership],
        :description => params[:Description],
        :industry => params[:Industry],
        :employees => params[:Employees],
        :annual_revenue => params[:Annual_revenue],
        :sic_code => params[:Sic_code],
        :billing_street => params[:Billing_street],
        :billing_city => params[:Billing_city],
        :billing_state => params[:Billing_province],
        :billing_code => params[:Billing_code],
        :billing_country => params[:Shipping_country],
        :shipping_street => params[:Shipping_street],
        :shipping_city => params[:Shipping_city],
        :shipping_state => params[:Shipping_province],
        :shipping_code => params[:Shipping_code],
        :shipping_country => params[:Shipping_country],

    )
    @ac.save
    redirect_to "/accounts"
  end

  def tasks
    @ts = RubyZoho::Crm::Task.new
  end

  def create_task
    @ts = RubyZoho::Crm::Task.new(
        :task_owner => params[:Task_Owner],
        :subject => params[:Subject],
        :description => params[:Description],
    )
    @ts.save
    redirect_to "/tasks"
  end

  def potential
    @ts = RubyZoho::Crm::Potential.new
  end

  def create_potential
    @ts = RubyZoho::Crm::Potential.new(
        :potential_owner => params[:Potential_owner],
        :amount => params[:Amount],
        :account_name => params[:Account_name],
        :stage => params[:Stage],
        :type => params[:Type],
        :probability => params[:Probability],
        :next_step => params[:Next_step],
        :expected_revenue => params[:Expected_revenue],
        :lead_source => params[:Lead_source],
        :potential_name => params[:Potential_name],
        :description => params[:Description]
    )
    @ts.save
    redirect_to "/potential"
  end

end
