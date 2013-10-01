exports = this
home = exports.home = 
    editor : null
    process_newuser: (j) -> 
        if j.failed
            $("#alert_reg").removeClass("alert-info")
            $("#alert_reg").addClass("alert-danger")
            $("#alert_reg_box").html("");
            $("#alert_reg_box").html("<h3>" + lang['register']['error_appear'] + "<\/h3>")
            ul = $("<ul>")
            for i in j.errors
                ul.append("<li>" + i + "<\/li>")
            $("#alert_reg_box").append(ul)
            
            $("#alert_reg").addClass("shake")
            exports.window.setTimeout(
                -> $("#alert_reg").removeClass("shake")
                1000
            )
        else
            $("#home_box_reg").addClass("bounceOutLeft")
            exports.window.setTimeout(
                -> 
                    $("#home_box_reg").after(lang["register"]["success-welcome"]( j["user"] ))
                    $("#home_box_reg").remove()
                    $(".page-header>h1").text(lang["register"]["RegistrationSuccessful"]);
                1000
            )
        $(this).find("[type=submit]").removeAttr('disabled')
    process_login: (j) ->
        if j.failed
            $("#form_home_login").addClass("shake")
            exports.window.setTimeout(
                -> $("#form_home_login").removeClass("shake")
                1000
            )
            e = $("<div class='alert alert-block alert-danger' id='home_alert_error'>")
            e.html( '<a class="close" data-dismiss="alert" href="#">×</a>' + "<h3>" + lang['login']['error_appear'] + "<\/h3>")
            ul = $("<ul>")
            for i in j.errors
                ul.append("<li>" + i + "<\/li>")
            e.append(ul)
            $("#err_b").html("")
            $("#err_b").append(e)
            $("#home_alert_error").alert()
        else
            $("#home_tp_login_box").removeClass("home_left_border")
            $("#home_u_login_box").addClass("bounceOutLeft")
            $("#home_tp_login_box").addClass("bounceOutRight")
            exports.window.setTimeout(
                ->
                    $("#home_login_box").after(lang["login"]["success-welcome"]( j["user"] ))
                    $("#home_login_box").remove()
                    $(".page-header>h1").text(lang["login"]["LoginSuccessful"]);
                1000
            )
        $(this).find("[type=submit]").removeAttr('disabled')
    process_oauth_login: (j)->
    
    process_messagesend: (j)->
        if (j.failed)
            alert("失败")
        else
            alert("成功")
            home.editor.remove();
        home.editor.unload();
        home.editor = null;
        $('#newmessage').modal('hide')
        $(this).find("[type=submit]").removeAttr('disabled')
    process_messagelist : (j)->
        if (j.failed)
            console.log('failed load message list');
            return ;
        $("[role=msgholder]").html("")
        unread = (mid,title,sender,senderid,date) -> 
            return '<tr><td><strong><a data-toggle="tooltip" data-target="openmsg" data-mid="' + mid + '" title="' + date + '">' + title + '</a></strong></td><td><a data-target="openuser" data-uid="' + senderid + '">' + sender + '</a></td></tr>';

        read = (mid,title,sender,senderid,date) -> 
            return '<tr><td><a data-toggle="tooltip" data-target="openmsg" data-mid="' + mid + '" title="' + date + '">' + title + '</a></td><td><a data-target="openuser" data-uid="' + senderid + '">' + sender + '</a></td></tr>';
        for x in j.body
            element = null
            dt = new Date(Date.parse(x.created_at))
            dt = dt.format("yyyy年MM月dd日hh时mm分ss秒");
            if (x.read)
                element = $(read(x.mid,x.title,x.sender,x.senderid,dt))
            else
                element = $(unread(x.mid,x.title,x.sender,x.senderid,dt))
            $("[role=msgholder]").append element
        $("[role=msgholder]").find("[data-target=openmsg]").tooltip({placement:"right"}).click(
            -> $.get(
                message.load + $(this).attr('data-mid')
                (d) -> eval(d["callback"]).call(this,d)
            )
        )

    process_message : (j) ->
        if (j.failed)
            console.log('failed load message');
            return ;
        #~ alert(j + "TODO : Use div instead of alert in home.js.coffee")
        $('#senduser').text(j.body.sender)
        $('#sendtitle').text(j.body.title)
        $('#getmessage').html((j.body.message))
        $('#getmessage').find('pre code').each(
            (i, e) ->
                hljs.highlightBlock(e)
        )
        $('#readmessage').modal('show');
    stage : ->
        if (view == 'home/register')
            $("#formcheck_agrees").change =>
                if ($("#formcheck_agrees")[0].checked==true)
                    $("#btn_reg_sbt").removeAttr("disabled")
                else
                    $("#btn_reg_sbt").attr('disabled','')
            return ;
        if (view == 'home/center')
            $('#uc_tabs a').click(
                (e)->
                    e.preventDefault()
                    $(this).tab('show')
            )
            $("#uc_tabs a:first").tab('show')
            $.get(
                message.list
                (d) -> eval(d["callback"]).call(this,d)
            )
            # Markdown editor
            $('#newmessage').on(
                'shown.bs.modal'
                ->      
                    home.editor = new EpicEditor({
                        parser: (str)->
                            marked str
                        container : "message_area"
                        basePath : ""
                        autogrow : {
                            minHeight : 256
                            maxHeight : 256
                            scroll : true
                        }
                        file: {
                            name: 'message_box',
                            defaultContent: '',
                            autoSave: 100
                        }
                        textarea : "user_message_text"

                    }).load().reflow();
            ).on(
                'hidden.bs.modal'
                ->
                    if (home.editor) 
                        home.editor.unload();
                        home.editor = null

            )
    clear : ->
    

# Init
$ -> 
    home.stage()
$(window).bind(
    'page:change'
    -> home.stage()
)
$(window).bind(
    'page:before-change'
    -> 
        home.clear()
)