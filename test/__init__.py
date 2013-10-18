import re
from subprocess import PIPE, Popen
import os

__author__ = 'tigra'


import unittest

class TestExtraction(unittest.TestCase):

    def setUp(self):
        self.found_transes = Popen(['pybabel','extract','-F','babel.cfg','-o','messages.pot','.'],stdout=PIPE,stderr=PIPE).stdout.read()
        with open(os.path.join(os.path.dirname(__file__),'messages.pot'),'r') as output:
            self.output = output.read()

    def test_number_of_occurences(self):
        self.assertEqual(len(re.findall(r'test\.hbs',self.output)),4,"Wrong number of found translations")

    def test_number_of_plural(self):
        self.assertEqual(len(re.findall(r'msgid_plural',self.output)),2,"Wrong number of plural translations")

if __name__ == '__main__':
    unittest.main()