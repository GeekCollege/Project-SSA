require 'net/http'
class OauthController < ApplicationController
    ALLOW_PROVIDER = ['sina','qq','google','surfing']
    ALLOW_ACTION = ['login']
    layout false
    def clientcall
        params.permit!
        @errors = []
        @errors = ["Access Forbidden"] unless (ALLOW_ACTION.include?(@act = params[:act]))
        @errors = ["Access Forbidden"] unless (ALLOW_PROVIDER.include?(@provider = params[:provider]))
        return if (@errors.any?)
        if (@provider=='qq')
            @wtfurl = ("https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id=801398052&response_type=code&redirect_uri=".html_safe) + (oauth_client_callback_url(@provider,@act).html_safe)
        end
    end
    def clientcallback
        params.permit!
        @errors = []
        @errors = ["Access Forbidden"] unless (ALLOW_ACTION.include?(@act = params[:act]))
        @errors = ["Access Forbidden"] unless (ALLOW_PROVIDER.include?(@provider = params[:provider]))
        return if (@errors.any?)
        if (@act == 'login')
            if (@provider == 'qq')
                url = URI.parse('https://open.t.qq.com/cgi-bin/oauth2/access_token?client_id=801398052&client_secret=c395dd0082c93580fb131a0eb9c578e7&grant_type=authorization_code&code=' + params[:code])
                Net::HTTP.start(url.host, url.port) do |http|
                    req = Net::HTTP::Get.new(url.path)
                    @result = http.request(req).body
                end
                @errors = ["Access Forbidden"] if (@result.nil?)
                return if (@errors.any?)
                @result = @result.split('&')
                @cfg = {}
                @result.each{|x|cfg[x.split('=')[0]] = x.split('=')[1]}
                if (@cfg['access_token'].nil? || @cfg['expires_in'].nil? || @cfg['refresh_token'].nil?)
                    @errors = ["Access Forbidden"]
                    return 
                end
                
            end
        end
=begin
{"code"=>"dd4483ca469ef4c523f9266ded43b308", "openid"=>"F23BF0095A33F8EF77096B38848FDBBE", "openkey"=>"09A1B9D452CB6F5611EE36A4CFDE1C62", "state"=>"", "controller"=>"oauth", "action"=>"clientcallback", "provider"=>"qq", "act"=>"login"}
=end

    end
end
