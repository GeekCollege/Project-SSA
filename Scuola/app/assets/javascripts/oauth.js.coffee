exports = this
oauth = exports.oauth = 
    busy : false
    order : false

    orders : {}

    status : (x) ->
        oauth.busy = x
        if (oauth.busy)
            if ($("#oauth_busy").size()==0)
                oauth_busy = $("<div id='oauth_busy' class='oauth_screenholder'>")
                $("body").append(oauth_busy)
                oauth_busy.html("<div class='oauth_content'>" + exports.lang["auth_waiting"] + "<\/div>")
                exports.kitou.increaseWork()
                $(".stage").addClass("modal-active")
                return true
        else
            cs = $("#oauth_busy").size();
            $("#oauth_busy").remove()
            exports.kitou.decreaseWork() for i in [1..cs]
            $(".stage").removeClass("modal-active")
            oauth.order = false
        return false

    stage : ->
        exports.load_lang_pack("OAuth")
        $("a[data-oauth]").click -> 
            oauth.order = new OAuth($(this).attr("data-oauth"))
            oauth.order.authorize()
        $("a[data-oauth]").css("cursor","pointer")
        # $("body>*[mask-escape!='true']").attr('mask-escape',false)
    clear : ->
        oauth.busy = false
        oauth.order = false
        oauth.orders = {}

class OAuth
    constructor: (@url) ->
    authorize : -> 
        if !oauth.busy
            if oauth.status(true)
                @oid = Math.floor(Math.random() * 10000) while !@oid? || (oauth.orders[@oid]?)
                oauth.orders[@oid] = _this = oauth.order = this
                d = (exports.window.screenX || exports.window.screenLeft) + Math.max(0, (exports.window.outerWidth || exports.document.documentElement.clientWidth) - 800) / 2
                v = (exports.window.screenY || exports.window.screenTop) + Math.max(0, (exports.window.outerHeight || exports.document.documentElement.clientHeight) - 640) / 2
                @authorizationWindow = exports.window.open(
                    @url + "#" + @oid
                    'OAuth'
                    'height=640,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=yes,status=no,left=' + d + "top=" + v)

                func = ->
                    if oauth.order == _this && oauth.busy
                        if _this.authorizationWindow.closed
                            _this.failed({"failed":true,errors:"window closed"})
                            return
                        if !_this.authorizationWindow
                            return false
                        setTimeout(func, 0)
                func()
    fail: (@fail) ->
    succ: (@succ) ->
    did : (@did ) ->
    failed : (e) ->
        oauth.status(false)
        eval(@fail).call(this,e) if (@fail)
        @done();
    success : (e) ->
        oauth.status(false)
        eval(@succ).call(this,e) if (@succ)
        @done();
    done : (e) ->
        oauth.orders[@oid] = null
        delete(oauth.orders[@oid])
        eval(@did).call(this) if (@did)
$ -> 
    oauth.stage()
$(window).bind(
    'page:change'
    -> oauth.stage()
)
$(window).bind(
    'page:before-change'
    -> 
        oauth.clear()
)