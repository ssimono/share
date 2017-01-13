SHARE
=====

Ultra-simple command line utility to make file sharing on local network easy. At least if you have a folder somewhere in your system able to serve static files (e.g running a server like [Nginx](https://nginx.org/), [Apache](https://httpd.apache.org/), [http-server](https://www.npmjs.com/package/http-server)...)

What happens when I run
-----------------------

    share cat-picture.png

1. *cat-picture.png* is copied to your public folder (*/var/www* by default)
2. A job is set up so your picture will be deleted from your public folder using [atd](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/at.html) (after *1 hour* by default)
3. The shareable link for your picture will be printed to standard output (on all network interfaces by default)

That's it.

How do I install it
-------------------

    git clone https://github.com/ssimono/share
    sudo make install

or copy *share.sh* somewhere in your PATH, because that's all it does

How do I configure it
---------------------

Create a *~/.sharerc* file and set values to those settings, if following defaults don't suit you:

    # Directory over which the shared files will be copied
    SHARE_DIRECTORY='/var/www'

    # Time after which the file will be deleted
    SHARE_TTL=1hour

    # If your public folder is accessible via a prefix (e.g http://127.0.0.1/my-prefix)
    SHARE_URL_PATH='/'

    # You can specify which network interface you want the link to be generated from. If empty will output every possible url. Run `ifconfig` to get a list of your interfaces
    SHARE_INTERFACE=''

    # If set to true, will add a '.txt' extension to the shared url so browser can display it right away. It won't do it for binary files
    AUTO_TEXT=false
