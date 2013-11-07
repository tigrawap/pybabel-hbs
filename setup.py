#!/usr/bin/env python

from setuptools import setup, os


def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
    name='PyBabel-hbs',
    version='0.2.2',
    description='PyBabel handlebars gettext strings extractor',
    author='Anton Bykov aka Tigra San',
    author_email='tigrawap@gmail.com',
    long_description=read('README.rst'),
    packages=['pybabel_hbs'],
    url="https://github.com/tigrawap/pybabel-hbs",
    install_requires=[
        'babel',
        'pexpect-u'
    ],
    include_package_data=True,
    entry_points = """
        [babel.extractors]
        hbs = pybabel_hbs.extractor:extract_hbs
        """,
)
