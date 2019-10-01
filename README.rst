fwrite
======

Create files of the desired size.

A Python version is `also available <https://github.com/pdrb/fwrite>`_.

Simple example::

    $ fwrite testfile 100M


Install
=======

**Using nimble**::

    $ nimble install fwrite

**Using nim compiler**:

Since only the standard library is used, just download the single source code
file and compile it::

    $ wget https://raw.githubusercontent.com/pdrb/nim-fwrite/master/src/fwrite.nim
    $ nim c -d:release fwrite.nim


Usage
=====

::

    Usage: fwrite filename size [options]

    create files of the desired size, e.g., 'fwrite test 10M'

    Options:
      -v, --version     show program's version number and exit
      -h, --help        show this help message and exit
      -r, --random      use random data (very slow)
      -l, --linefeed    append line feed every 1023 bytes


Examples
========

Create file "test" with 100KB::

    $ fwrite test 100K

Create file "test" with 1GB::

    $ fwrite test 1G

Create file "test" with 10MB of random data::

    $ fwrite test 10M -r

Create file "test" with 10MB of random data with line feed::

    $ fwrite test 10M -r -n
