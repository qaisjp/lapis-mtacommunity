# Installation
The community website uses Lapis, a web framework built on top of OpenResty. Lapis is also installed using `luarocks`, a package manager for Lua. In addition, the web application uses a database and you will therefore to also need to set up PostgreSQL.

You will need to visit the [OpenResty website](https://openresty.org), download the tarball and follow the installation instructions there.

As of writing this document, OpenResty requires the following dependencies installed on your system:

* `perl 5.6.1+`
* `libreadline`
* `libpcre`
* `libssl`

To install LuaRocks, you will need to visit the [LuaRocks website](https://luarocks.org) and follow the installation instructions there. LuaRocks also requires Lua **5.1.5** to be installed.

Lapis does not currently support the latest version of Lua so that specific version of Lua is required. Visit the [Lua website](http://lua.org) to download and install it.

Some distributions on Linux don’t bundle the `unzip` utility. You will need this packa for LuaRocks to work correctly. To install all the dependencies for the website, you just need to run `luarocks install mtacommunity-1.0.0-1.rockspec --local --only-deps`. The file `mtacommunity-1.0.0-1.rockspec` contains dependency information, making it easier to get started with the project.

Since the web application is written in `moonscript`, we need the compiler for moonscript to be installed. Execute `luarocks install moonscript`. This isn’t required for the website to run, but it is required to build the website. 

Another dependency required is tup, the build system that screws everything together. Just visit [the website](http://gittup.org/tup/) and follow the instructions. Then execute `tup` to build the system.

The website frontend requires three libraries:

* `bootstrap-v4`
* `jquery`
* `font-awesome`
* 
To make things easier I use the `bower` package manager to handle the frontend libraries. After installing Bower, execute `bower install` and the package manager will download the other libraries.

You also need to install Go. Run `go get -d` and then `go build` to build the zip file checker.

The final dependency required is `postgres`, the database system being used. You will need to install that and change the username and password to whatever you chose inside the `config.moon` file of the main project. Make sure you also set the API tokens and secret tokens inside `secret.moon`. See `secret.example.moon` for an example of how to structure `secret.moon`.
