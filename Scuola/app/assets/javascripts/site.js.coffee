# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
exports = this
site = exports.site = 
    stage : -> 
        if (view == 'site/tos')
            $body   = $(document.body)
            $stn = $(".bs-sidenav   ")
            $("h4>strong").each(
                (y,x)->
                    $(x).attr("id" , "topic-" + y)
                    $stn.append("<li><a href='#topic-" + y + "'>" + /^(.*?)、(.*)$/.exec($(x).text())[2] + "<\/a><\/li>")
            )
            $body.scrollspy({
                  target: '.bs-sidebar'
                  offset: 1
            })
            $sideBar = $('.bs-sidebar')
            fixtop = $(".row").offset().top
            setTimeout(
                ->
                    $sideBar.affix({
                        offset: {
                            top: 150
                            bottom: =>
                                return ($('.footer').outerHeight(true))
                        }
                    })
                100
            )
            $body.scrollspy('refresh')
            $.scrollUp({
                scrollDistance: 300, 
                scrollFrom: 'top',
                scrollSpeed: 300, 
                easingType: 'linear', 
                animation: 'fade',
                animationInSpeed: 200, 
                animationOutSpeed: 200, 
                scrollText: '', 
                scrollTitle: false, 
                scrollImg: true, 
                activeOverlay: false, 
                zIndex: 9996 
            })

    clear : ->


# Init
$ -> 
    site.stage()
$(window).bind(
    'page:change'
    -> site.stage()
)
$(window).bind(
    'page:before-change'
    -> 
        site.clear()
)