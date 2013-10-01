var langs = {
    'zh-CN':{
        'common':{
            
        },
        'Home':{
             'register':{
                'error_appear':'出错啦！',
                "success-welcome" : (function(x){return '<div class="alert alert-block alert-success flipInY animated"><h3>注册成功</h3><p>亲爱的 ' + x + '，你已经成功注册了！接下来您应该在邮箱中收到一封验证邮件，并激活您的账号。<\/p><p>如果没有收到激活邮件，请在用户中心重新发送验证邮件。<\/p><br/></div>';}),
                "RegistrationSuccessful" : "注册成功"
             },
             'login':{
                'error_appear':'出错啦！',
                'success-welcome' : (function(x){
                    return '<div class="alert alert-block alert-success flipInY animated">  \
    <h3>登陆成功</h3>                                                           \
    <p>亲爱的 '+ x +'，你已经成功登陆了！接下来你可以前往：</p>                 \
    <ul>                                                                        \
    <li>用户中心</li>                                                           \
    <li>课程列表</li>                                                           \
    <li>论坛</li>                                                               \
    </ul>                                                                       \
    <br />                                                                      \
</div>';
                }),
                'LoginSuccessful' : "登陆成功"
             }
        },
        'OAuth':{
            "auth_waiting":"请在弹出窗口中完成OAuth认证"
        }
    }
};