define [
    'Handlebars'
    'cs!./i18n'
],(
    Handlebars
    i18n
)->

    Handlebars.registerHelper 'trans', (options) ->
        content = options.fn(@)
        return i18n.trans content,options.hash

    Handlebars.registerHelper '_', (string,options) ->
        content = string
        return i18n.trans content,options.hash

    Handlebars.registerHelper 'ntrans', (num,options) ->
        content = options.fn(@)
        plural_content = options.inverse(@)
        return i18n.ntrans content,plural_content,num,options.hash

    Handlebars.registerHelper 'n_', (num,string,plural_string,options) ->
        return i18n.ntrans string,plural_string,num,options.hash
