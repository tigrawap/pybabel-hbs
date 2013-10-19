Handlebars = require('./lib/custom_handlebars.js').Handlebars

process.stdin.resume()
process.stdin.setEncoding('utf8')
process.stdin.on 'data', (chunk)->
    if chunk.indexOf('PYHBS COMMAND')==0
        command=chunk.split(':')[1].trim()
        if command=='TRANSFER BEGIN'
            Extractor.communicate 'AWAITING'
            Extractor.init()
        else if command=='TRANSFER END'
            Extractor.flush()
    else
        Extractor.received_data += chunk

Extractor =
    init:->
        @received_data=""
        @output=[]
        @communicate 'WAITING FOR COMMAND'

    communicate:(message)->
        process.stdout.write('PYHBS RESPONSE:'+message)

    flush:->
        @communicate 'SENDING OUTPUT'
        parsed_data = Handlebars.parse(@received_data)
        @extract parsed_data
        process.stdout.write(JSON.stringify(@output))
        @communicate 'OUTPUT END'

    extract: (node)->
        if node.statements
            for statement in node.statements
                @extract statement

        else if node.type == 'block' and node.mustache.id.original == 'trans'
            content_node = node.program.statements[0]
            @output.push
                line_number:content_node.first_line
                content:content_node.string
                funcname:'_'

        else if node.type == 'block' and node.mustache.id.original == 'ntrans'
            content_node = node.program.statements[0]
            alt_content_node = node.program.inverse.statements[0]
            @output.push
                line_number:content_node.first_line
                alt_line_number:alt_content_node.first_line
                content:content_node.string
                alt_content:alt_content_node.string
                funcname:'ngettext'

        else if node.type == 'block'
            @extract node.program
            if node.program.inverse
                @extract node.program.inverse
            return

        else if node.type == 'mustache'

            if node.id.original == '_'
                @output.push
                    line_number:node.first_line
                    content:node.params[0].string
                    funcname:'_'

            else if node.id.original == 'n_'
                @output.push
                    line_number:node.first_line
                    content:node.params[0].string
                    alt_content:node.params[1].string
                    funcname:'ngettext'


Extractor.init()