import json
import os
from subprocess import Popen, PIPE


def extract_hbs(fileobj, keywords, comment_tags, options):
    """Extract messages from Handlebars templates.

    It returns an iterator yielding tuples in the following form ``(lineno,
    funcname, message, comments)``.

    TODO: Things to improve:
    --- Return comments
    --- make translation pipe/http server, so node will be run only once and will accept files to translate. This will be much much faster
    """

    extractor_src = os.path.join(os.path.dirname(__file__),'extract_i18n.coffee')
    extractor = os.path.join(os.path.dirname(__file__),'extract_i18n.js')
    if not os.path.isfile(extractor) or 'PYBABEL_HBS_EXTRACTOR_DEBUG' in os.environ:
        Popen(['coffee','-c',extractor_src],stdout=PIPE).communicate()

    print extractor
    trans_strings= Popen(['node',extractor],stdout=PIPE,stdin=fileobj).stdout.read()

    for item in json.loads(trans_strings):
        messages = [item['content']]
        if item['funcname'] == 'ngettext':
            messages.append(item['alt_content'])


        yield item['line_number'],item['funcname'],tuple(messages),[]
