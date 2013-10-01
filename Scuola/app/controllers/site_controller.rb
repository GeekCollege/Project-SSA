class SiteController < ApplicationController
    def tos
        File.open("TOS.md","r") {|f| @tos = f.read }
        @page_title = "Geek学院服务协议"
        respond_to do |format|
            format.md{
                render :text => "Geek学院服务协议（Terms of Service）\n" + @tos
            }
            format.html{

            }
        end
    end #terms of service
    def donate
        @page_title = "捐助我们"
    end
    def aboutus
        @page_title = "关于我们"
    end
    def privacy
        @page_title = "隐私政策"
    end
end
