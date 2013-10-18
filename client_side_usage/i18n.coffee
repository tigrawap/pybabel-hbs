define [
    'jed'
],(
    Jed
)->
    i18n = new Jed       #great library for i18n
        locale_data : {} #po2json output goes here
        "domain" : "messages"

    trans = (string,params)->
        i18n.translate(string).fetch(params)

    ntrans = (string,plural_string,num,params)->
        i18n.translate(string).ifPlural(num,plural_string).fetch(params)

    return {
        trans:trans
        ntrans:ntrans
    }