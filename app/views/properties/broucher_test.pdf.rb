<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<%= wicked_pdf_stylesheet_link_tag "bootstrap.css" %>
<% no_image = "#{Rails.root}/app/assets/images/default_images/no.jpg" %>

<div class="page-break" style="display:block; clear:both; page-break-after:always;"></div>

<div class="float-left" style="">
  <% no_image = "#{Rails.root}/app/assets/images/default_images/no.jpg" %>
  <div class="float-left" style="position:relative;top:0px;left:0px;width:500px;"><%=image_tag(@properties.image1.present? ? @properties.image1.url(:large) : no_image, :height=> "1100",:width=>"500") %></div>
  <div class="float-left" style="position:relative;top:40px;left:0px;width:500px;"><%=image_tag(@properties.image2.present? ? @properties.image2.url(:large) : no_image, :height=> "340",:width=>"500") %></div>
  <div class="float-right" style="position:relative;top:-1440px;left:550px;width:500px;"><%=image_tag(@properties.image3.present? ? @properties.image3.url(:large) : no_image, :height=> "340",:width=>"500") %></div>
  <div class="float-right" style="position:relative;top:-1400px;left:550px;width:500px;"><%=image_tag(@properties.image4.present? ? @properties.image4.url(:large) : no_image, :height=> "340",:width=>"500") %></div>
  <div class="float-right" style="position:relative;top:-1360px;left:550px;width:500px;"><%=image_tag(@properties.image5.present? ? @properties.image5.url(:large) : no_image, :height=> "340",:width=>"500") %></div>
  <div class="float-right" style="position:relative;top:-1320px;left:550px;width:500px;"><%=image_tag(@properties.image5.present? ? @properties.image5.url(:large) : no_image, :height=> "340",:width=>"500") %></div>
</div>  