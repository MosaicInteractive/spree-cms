class SpreeCmsHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_tabs do
    %(<%=  tab(:posts)  %>)
  end

  insert_after :admin_tabs do
    %(<%=  tab(:pages)  %>)
  end
  
  insert_after :admin_user_form_fields, "admin/users/display_name"

  insert_after :home_panel2, "shared/recent_articles_module"
end
