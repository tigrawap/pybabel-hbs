import json
import os
from subprocess import Popen, PIPE
import pexpect

_shared={

}

def get_pipeserver():
    """
    @rtype: pexpect.spawn
    """
    server=_shared.get('SERVER')
    if server is None:
        server=launch_pipeserver()
    return server

def launch_pipeserver():
    extractor = os.path.join(os.path.dirname(__file__),'extract_i18n.js')
    extractor_src = os.path.join(os.path.dirname(__file__),'extract_i18n.coffee')
    if not os.path.isfile(extractor) or 'PYBABEL_HBS_EXTRACTOR_DEBUG' in os.environ:
        Popen(['coffee','-c',extractor_src],stdout=PIPE).communicate()

    server = pexpect.spawn('node',[extractor])
    server.expect('PYHBS RESPONSE:WAITING FOR COMMAND',timeout=3)
    _shared['SERVER'] = server
    return server


COMMAND = u"PYHBS COMMAND:"
RESPONSE =u"PYHBS RESPONSE:"

def extract_hbs(fileobj, keywords, comment_tags, options):
    """Extract messages from Handlebars templates.

    It returns an iterator yielding tuples in the following form ``(lineno,
    funcname, message, comments)``.

    TODO: Things to improve:
    --- Return comments
    """

    server = get_pipeserver()
    server.sendline(COMMAND+u'PARSE FILE:'+fileobj.name)
    server.expect(RESPONSE+'SENDING OUTPUT')
    server.expect(RESPONSE+'OUTPUT END')
    trans_strings = server.before

    for item in json.loads(trans_strings):
        messages = [item['content']]
        if item['funcname'] == 'ngettext':
            messages.append(item['alt_content'])
        yield item['line_number'],item['funcname'],tuple(messages),[]
