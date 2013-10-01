module ApplicationHelper
	USERLEVEL = {0=>"lv0",100=>"lv1",1000=>"lv2",2000=>"lv3",5000=>"lv4",12000=>"lv5",300000=>"lv6",900000=>"lv7",200000=>"lv8",4500000=>"lv9",10000000=>"lv10",2147483647=>"lvNaN"}
	def display_username(user,experience=nil,_class="")
		raise 'Input Error' if (user.is_a?(String) && experience.nil?)
		_class = experience,experience=nil if experience.is_a?(String)
		if (experience.nil?)
			experience = user.user_asset.experience.to_i 
			user = user.username
		end
		a=[10000000,""]
		USERLEVEL.each{|k,v|
			a = [k,v] if (experience <= k && k < a[0])
		}
		user = html_escape user
		return "<span class=\"display_user #{a[1]} #{_class}\"><strong>#{user}</strong></span>".html_safe
	end

	def oauth_link(text,planform,action)
		return "<a data-oauth=\"#{oauth_client_path(planform,action).html_safe}\" data-planform=\"#{planform}\" data-action=\"#{action}\">#{text}</a>".html_safe
	end

	def markdown(text)
		markdown = Redcarpet::Markdown.new(
            Redcarpet::Render::HTML.new({
                :safe_links_only => true,
                :hard_wrap => true,
                :filter_html => true,
            }),
            {
                :fenced_code_blocks => true,
                :autolink => true,
                :tables=>true,
                :quote=>true
            }
        )
        #~ mess = Nokogiri::HTML::DocumentFragment.parse()
        #~ mess.css("script").each { | pre |
        #~     pre.replace html_escape pre.text
        #~ }
        return markdown.render(text)
	end

end
