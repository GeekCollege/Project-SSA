exports = this
kitou = exports.kitou = 
    backgroundWork: 1
    increaseWork: ->
        kitou.backgroundWork++
        kitou.updateKitou()
    decreaseWork: ->
        kitou.backgroundWork--
        kitou.updateKitou()
    updateKitou: ->
        $("#kitou").removeClass("hide") if (kitou.backgroundWork == 1)
        $("#kitou").addClass("hide") if (kitou.backgroundWork == 0)
    clear: ->
        kitou.backgroundWork = 1;
        $("#kitou").addClass("hide")
common = exports.common = 
    stage : ->
        kitou.decreaseWork()
        $("form[data-remote=true]").bind(
            "ajax:success"
            (e,d) -> eval(d["callback"]).call(this,d)
        )
        $( document ).ajaxStart => kitou.increaseWork();
        $( document ).ajaxStop => kitou.decreaseWork();
        $("form[data-remote=true]").bind(
            "ajax:beforeSend"
            -> $(this).find("[type=submit]").attr('disabled',"true")
        )      
        # init markdown 
        marked.setOptions({
            gfm: true,
            highlight: (code, lang) -> 
                if (lang)
                    return hljs.highlight(lang, code).value;
                return hljs.highlightAuto(code).value;
            tables: true
            breaks: true
            pedantic: false
            sanitize: true
            smartLists: true
            smartypants: false
            langPrefix: ''
            emoji: (emoji) ->
                getemojis(emoji)
            
        });

    clear : ->
$ -> 
    common.stage()
    
$(window).bind(
    'page:change'
    -> common.stage()
)
$(window).bind(
    'page:before-change'
    -> 
        common.clear()
        kitou.clear()
)