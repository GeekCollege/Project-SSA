class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception
    before_filter :define_controller , :check_login , :set_locale , :check_return
    protected
    def check_return
        @return_to = params['return_url'] || ""
        if (params['return_url'].blank?)
            @return_to = nil
        end
    end
    protected
    def define_controller   
        @page_controller = self.class.to_s[0,self.class.to_s.size - "Controller".size]
    end
    protected
    def check_login
        return if session[:email].blank? || session[:password].blank?
        user_base = UserBase.try_login(session[:email],session[:password] , true)
        if (user_base.is_a?(String))
            user_base = nil
            session[:email] = session[:password] = nil
        end
        @user_base = user_base
    end

    protected    
    def set_locale
      if params[:locale] && I18n.available_locales.include?( params[:locale].to_sym )
        session[:locale] = params[:locale]
      end

      I18n.locale = session[:locale] || I18n.default_locale
    end 

    protected
    def try_login(email,password,mixed = false)
        user_base = UserBase.try_login(email,password,mixed)
        if (user_base.is_a?(String)) 
            session[:email] = session[:password] = nil
            return user_base
        end
        session[:email] = user_base.email
        session[:password] = user_base.password
        return @user_base = user_base
    end

    protected
    def markdown(text)
        markdown = Redcarpet::Markdown.new(
            Redcarpet::Render::HTML.new({
                :safe_links_only => true,
                :hard_wrap => true,
                :filter_html => true
            }),
            {
                :fenced_code_blocks => true,
                :autolink => true,
                :tables=>true,
                :quote=>true
            }
        )
        #~ mess = Nokogiri::HTML::DocumentFragment.parse(markdown.render(text))
        #~ mess.css("script").each { | pre |
        #~     pre.replace ERB::Util.html_escape pre.text
        #~ }
        return markdown.render(text)
    end

end
