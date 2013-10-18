Handlebars = require('./lib/custom_handlebars.js').Handlebars

received_data = ""
process.stdin.resume()
process.stdin.setEncoding('utf8')

process.stdin.on 'data', (chunk)->
    received_data = received_data + chunk

process.stdin.on 'end', ->
    parsed_data = Handlebars.parse(received_data);
    Extractor.extract parsed_data
    process.stdout.write(JSON.stringify(Extractor.output))
    do process.exit

Extractor =
    output:[]
    extract: (node)->
        if node.statements
            for statement in node.statements
                Extractor.extract statement

        else if node.type == 'block' and node.mustache.id.original == 'trans'
            content_node = node.program.statements[0]
            Extractor.output.push
                line_number:content_node.first_line
                content:content_node.string
                funcname:'_'

        else if node.type == 'block' and node.mustache.id.original == 'ntrans'
            content_node = node.program.statements[0]
            alt_content_node = node.program.inverse.statements[0]
            Extractor.output.push
                line_number:content_node.first_line
                alt_line_number:alt_content_node.first_line
                content:content_node.string
                alt_content:alt_content_node.string
                funcname:'ngettext'

        else if node.type == 'block'
            Extractor.extract node.program
            if node.program.inverse
                Extractor.extract node.program.inverse
            return

        else if node.type == 'mustache'

            if node.id.original == '_'
                Extractor.output.push
                    line_number:node.first_line
                    content:node.params[0].string
                    funcname:'_'

            else if node.id.original == 'n_'
                Extractor.output.push
                    line_number:node.first_line
                    content:node.params[0].string
                    alt_content:node.params[1].string
                    funcname:'ngettext'